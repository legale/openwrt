# Починка `sysupgrade` WARN/PANIC на `jffs2` при переключении на ramdisk

## Кратко

Проблема выглядела как баг в `jffs2`:

- `VFS: Busy inodes after unmount of jffs2 (jffs2)`
- `WARNING: CPU ... at generic_shutdown_super()`
- при `panic_on_warn=1` это превращалось в `kernel panic`

Но реальная причина была не в `jffs2`, а в teardown пути `sysupgrade` stage2.
Процесс `stage2` после `pivot_root()` продолжал исполняться со старого overlay
root, сам удерживал старый mount живым и в итоге вынуждал код идти через
`umount -l`. Сама запись прошивки в `mtd` обычно уже успевала завершиться, а
падение происходило позже, на финальном cleanup.

После починки этого первого слоя вскрылась вторая, уже чисто mount-tree
проблема: старый overlay root `/mnt` нельзя было снять обычным `umount`,
потому что под ним оставался child mount `/mnt/rom` с `squashfs` lower root.
Пока этот child mount жив, `umount /mnt` закономерно получает `EBUSY`.

Итоговый фикс сделан в userspace upgrade path:

- `upgraded` перестаёт держать старый root;
- `stage2` теперь реально переисполняется из RAMFS;
- перед снятием старого root теперь снимаются его child mount'ы, в том числе
  `/mnt/rom`;
- старый root снимается обычным `umount`, а lazy umount остаётся только как
  fallback на случай другого mount-tree edge case;
- добавлена отладка держателей overlay/root и дамп busy inode'ов для лога.

После этого `sysupgrade` снова проходит штатно, без `panic` на финальном
размонтировании.

## Как проявлялась проблема

Типичный сбой выглядел так:

1. `sysupgrade` доходил до `Switching to ramdisk...`
2. иногда было видно `mount ... /overlay failed: Resource busy`
3. запись в `mtd` могла уже успешно завершиться
4. затем при cleanup срабатывал:
   `cleanup_mnt -> deactivate_super -> jffs2_kill_sb -> generic_shutdown_super`
5. ядро печатало:
   `VFS: Busy inodes after unmount of jffs2 (jffs2)`
6. из-за `panic_on_warn=1` машина сразу уходила в `panic`

Важно: это не означало, что ломалась сама запись прошивки. Основной сбой был
после записи, при teardown старого root/overlay.

## Почему сообщение про `jffs2` вводило в сторону

`generic_shutdown_super()` ругается в тот момент, когда VFS пытается добить
superblock, а список inode'ов всё ещё не пуст.

Это место проявления проблемы, а не её источник.

В нашем случае:

- старый `/mnt` после `pivot_root()` был overlayfs root;
- его `upperdir` и `workdir` жили на `/overlay`, то есть на `jffs2`;
- пока кто-то продолжал жить на старом root, VFS не мог корректно снять весь
  этот стек;
- потом warning вылезал уже на `jffs2`, потому что teardown дошёл до нижнего
  слоя.

То есть `jffs2` здесь был не виновником, а последней видимой жертвой плохого
размонтирования.

После того как userspace pins были убраны, kernel-диагностика показала ещё один
важный факт:

- blocker для `umount /mnt` был child mount `/mnt/rom`
- `fs=squashfs`
- `dev=/dev/root`

Это нижний `squashfs` root старого overlay tree. Пока он оставался child mount
под `/mnt`, сам `/mnt` снять было нельзя даже при полном отсутствии userspace
holder'ов.

## Что именно было сломано штатно

Проблема оказалась в сочетании двух вещей.

### 1. `upgraded` сам держал старый root

`procd` запускает `upgraded`, тот форкает child для `stage2`, а сам PID 1
остаётся жить и ждать завершения апгрейда.

Если parent остаётся привязан к старому root, то даже при правильной работе
child старый mount всё равно остаётся pinned до reboot.

Для этого добавлен патч:

- [100-upgraded-reroot-parent-before-wait.patch](/mnt/2tb/sdk4/ax835/package/system/procd/patches/100-upgraded-reroot-parent-before-wait.patch)

Смысл патча:

- сразу после fork parent делает `chroot(".")`
- затем `chdir("/")`

Это переводит PID 1 на уже подготовленный RAMFS-префикс и не даёт ему держать
старый overlay root во время teardown.

### 2. Сам `stage2` на самом деле не переезжал в RAMFS

Это была главная причина.

Скрипт [stage2](/mnt/2tb/sdk4/ax835/package/base-files/files/lib/upgrade/stage2)
копировал в RAMFS:

- `/lib/upgrade/*.sh`
- `/lib/upgrade/do_stage2`

Но сам файл `/lib/upgrade/stage2` туда не копировался, потому что он без
суффикса `.sh`.

В результате после `pivot_root()` происходило вот что:

- shell всё ещё исполнял старый `/lib/upgrade/stage2` со старого root;
- `busybox ash` тоже оставался старым: `exe=/mnt/bin/busybox`;
- у процесса оставался открытый fd на старый скрипт:
  `fd=... target=/mnt/lib/upgrade/stage2`

Именно это и показала добавленная диагностика. В логе был прямой маркер:

- `holder pid=... exe=/mnt/bin/busybox`
- `holder pid=... fd=... target=/mnt/lib/upgrade/stage2`

Пока этот процесс жив, старый `/mnt` нельзя корректно снять.

## Как проблему локализовали

Для поиска держателя были добавлены две отладки.

### Отладка в `stage2` и `do_stage2`

В обоих скриптах появилась диагностика, которая печатает:

- relevant строки из `/proc/self/mountinfo`
- для каждого PID:
  - `root`
  - `cwd`
  - `exe`
  - `cmdline`
- открытые `fd`, указывающие на `/mnt*` или `/overlay*`

Файлы:

- [stage2](/mnt/2tb/sdk4/ax835/package/base-files/files/lib/upgrade/stage2)
- [do_stage2](/mnt/2tb/sdk4/ax835/package/base-files/files/lib/upgrade/do_stage2)

Эта отладка и показала, что главный holder - это сам `stage2`.

### Отладка в ядре

Для случая, если userspace holder уже исчез, а warning всё ещё остаётся,
добавлен временный patch:

- [970-fs-super-dump-busy-inodes.patch](/mnt/2tb/sdk4/ax835/target/linux/mediatek/patches-6.18/970-fs-super-dump-busy-inodes.patch)

Он печатает metadata inode'ов, которые пережили `evict_inodes()` и дожили до
`generic_shutdown_super()`.

Это не сам фикс, а диагностический инструмент на случай, если после userspace
починки остался бы уже чисто VFS-side pin.

Дополнительно был добавлен второй временный patch:

- [971-fs-namespace-dump-busy-umount-holders.patch](/mnt/2tb/sdk4/ax835/target/linux/mediatek/patches-6.18/971-fs-namespace-dump-busy-umount-holders.patch)

Он печатал:

- mount refcount
- child mount'ы под проблемным mount
- exact task refs на этом mount

Именно он показал окончательную причину:

- `children=1`
- `child[0] mp=/rom fs=squashfs dev=/dev/root`

То есть блокером был не процесс и не inode leak сам по себе, а живой child
mount старого lower root.

## Что именно исправлено

### 1. `stage2` теперь явно копируется в RAMFS

В [stage2](/mnt/2tb/sdk4/ax835/package/base-files/files/lib/upgrade/stage2)
в `install_file` добавлен:

- `/lib/upgrade/stage2`

Это убирает главный structural bug: раньше RAMFS не содержал сам скрипт,
который должен был продолжать апгрейд после `pivot_root()`.

### 2. После `pivot_root()` делается re-exec `stage2` уже из RAMFS

После `supivot` код больше не продолжает выполнение старого shell-процесса на
старом root.

Теперь делается:

- `export RAMFS_STAGE2=1`
- `exec /bin/busybox ash /lib/upgrade/stage2 "$IMAGE" "$COMMAND"`

То есть:

- старый `exe=/mnt/bin/busybox` уходит;
- старый `fd=/mnt/lib/upgrade/stage2` уходит;
- новая копия `stage2` уже живёт целиком на RAMFS.

### 3. Старый root снимается уже после re-exec, из RAMFS-контекста

Добавлен отдельный путь `ramfs_stage2()`.

Во второй фазе, уже после re-exec, он делает:

1. debug dump текущих держателей
2. `mount -o remount,ro /mnt`
3. снятие child mount'ов старого root, начиная с самых глубоких
4. обычный `umount /mnt`
5. только если это не удалось:
   `umount -l /mnt`
6. cleanup loop/LVM
7. `exec` финальной команды апгрейда

Это принципиально отличается от старой логики, где lazy unmount происходил
слишком рано, пока сам `stage2` ещё жил на старом root.

Ключевая деталь финальной версии: перед `umount /mnt` явно снимаются submount'ы
под `/mnt`. Для этого конкретного бага решающим оказался именно `/mnt/rom`.

### 4. `cd /` после `pivot_root()`

После `pivot_root()` оставлен защитный `cd /`.

Он сам по себе проблему не решал, но это всё равно правильный шаг:

- inherited `cwd` не должен оставаться на старом overlay mount
- это убирает ещё один возможный pin старого root

## Почему это решение правильное

Фикс не маскирует warning и не ломает VFS силовым путём.

Он исправляет именно порядок жизни объектов:

- сначала переводит parent и child на RAMFS;
- потом убирает все прямые userspace-ссылки на старый root;
- только после этого снимает старый mount;
- уже потом выполняет запись/cleanup/reboot.

Это общий и правильный путь не только для данного устройства. Проблема была не
в DTS, не в layout флеша и не в частной особенности AX835, а в самом механизме
teardown `sysupgrade` при переходе на RAMFS.

## Что оказалось не решением

По ходу отладки были идеи, которые сами по себе проблему не решали:

- чинить `jffs2`, чтобы оно "само всё освобождало"
- просто убирать `panic_on_warn`
- делать `/overlay` необязательным и игнорировать ошибку
- сразу использовать `umount -l` как основной путь

Почему это плохо:

- `jffs2` не должен насильно уничтожать inode'ы, на которые ещё есть ссылки;
- отключение `panic_on_warn` только прячет симптом;
- игнорирование ошибки оставляет teardown неправильным;
- `umount -l` годится как fallback, но не как основной путь для корректного
  `sysupgrade`.

## Наблюдаемый результат после фикса

После перевода `stage2` на re-exec из RAMFS `sysupgrade` снова проходит
штатно:

- child mount `/mnt/rom` снимается до `umount /mnt`;
- `umount /mnt` больше не упирается в `children=1`;
- запись образа проходит;
- финальный cleanup больше не приводит к `Busy inodes after unmount of jffs2`;
- `panic_on_warn=1` больше не срабатывает на штатном обновлении;
- debug image снова можно обновлять обычным `sysupgrade`.

## Затронутые файлы

Функциональные изменения:

- [stage2](/mnt/2tb/sdk4/ax835/package/base-files/files/lib/upgrade/stage2)
- [100-upgraded-reroot-parent-before-wait.patch](/mnt/2tb/sdk4/ax835/package/system/procd/patches/100-upgraded-reroot-parent-before-wait.patch)

Диагностика:

- [do_stage2](/mnt/2tb/sdk4/ax835/package/base-files/files/lib/upgrade/do_stage2)
- [970-fs-super-dump-busy-inodes.patch](/mnt/2tb/sdk4/ax835/target/linux/mediatek/patches-6.18/970-fs-super-dump-busy-inodes.patch)
- [971-fs-namespace-dump-busy-umount-holders.patch](/mnt/2tb/sdk4/ax835/target/linux/mediatek/patches-6.18/971-fs-namespace-dump-busy-umount-holders.patch)

## Итог

`sysupgrade` падал не потому, что `jffs2` "не умеет освобождать inode", а
потому что teardown старого overlay root был неполным на двух уровнях:

- сначала userspace сам держал старый root;
- потом выяснилось, что под старым `/mnt` ещё живёт child mount `/mnt/rom`.

Главный баг был простой и конкретный:

- `stage2` должен был продолжать работу из RAMFS,
- но фактически продолжал жить со старого rootfs,
- после чего teardown старого overlay становился некорректным.

И финальная развязка тоже конкретная:

- old root child mount `/mnt/rom` надо снять до `umount /mnt`;
- после этого штатный `sysupgrade` снова работает без `panic`.

После явного копирования `stage2` в RAMFS и re-exec из нового root проблема
ушла штатным способом, без обходных костылей в VFS или `jffs2`.
