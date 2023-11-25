# ax840 dev
## external kernel tree
`./kernel_tree` скрипт, чтобы включать/выключать дерево исходников ядра
`./git-am` скрипт для применения патчей в том же порядке, в котором их применяет owrt.
Эти патчи нужно применить к ветке ядра v6.1.63 

# цель 
получить рабочую версию прошивки для ax840. Сейчас не работает wifi по
причине неработоспособности remoteproc

## план
1. Склонировать дерево исходников ядра нужной версии v6.1.63
1. Применить все патчи, которые применяет к ядру openwrt
1.1. Последними применяются патчи ядра из /target/linux/qualcommax/patches-6.1
1. попробовать применить патчи remoteproc, которые я нашел для 5 версии ядра
1. поискать другие патчи для remoteproc, сделать что-то еще с ядром, чтобы все заработало
1. собрать все найденные патчи в виде файлов, чтобы можно было их использовать
без kernel external tree


## справочная информация
### log.txt для сборки ядра `make target/compile V=s -j1 >log.txt 2>&1` 

### порядок применения патчей:
- `target/linux/generic/backport-6.1`
- `target/linux/generic/pending-6.1`
- `target/linux/generic/hack-6.1`
- `target/linux/qualcommax/patches-6.1`
```
WARNING: Makefile 'package/utils/busybox/Makefile' has a dependency on 'libpam', which does not exist
WARNING: Makefile 'package/utils/busybox/Makefile' has a dependency on 'libpam', which does not exist
WARNING: Makefile 'package/utils/busybox/Makefile' has a build dependency on 'libpam', which does not exist
WARNING: Makefile 'package/boot/kexec-tools/Makefile' has a dependency on 'liblzma', which does not exist
WARNING: Makefile 'package/network/services/lldpd/Makefile' has a dependency on 'libnetsnmp', which does not exist
WARNING: Makefile 'package/utils/policycoreutils/Makefile' has a dependency on 'libpam', which does not exist
WARNING: Makefile 'package/utils/policycoreutils/Makefile' has a dependency on 'libpam', which does not exist
WARNING: Makefile 'package/utils/policycoreutils/Makefile' has a build dependency on 'libpam', which does not exist
make[2]: Entering directory '/tmpram/openwrt/scripts/config'
make[2]: 'conf' is up to date.
make[2]: Leaving directory '/tmpram/openwrt/scripts/config'
make[1]: Entering directory '/tmpram/openwrt'
make[2]: Entering directory '/tmpram/openwrt/target/linux'
make[3]: Entering directory '/tmpram/openwrt/target/linux/qualcommax'
rm -rf /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx
mkdir -p /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx
xzcat /tmpram/openwrt/dl/linux-6.1.63.tar.xz | tar -C /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx -xf -
cp -fpR "/tmpram/openwrt/target/linux/generic/files"/. "/tmpram/openwrt/target/linux/qualcommax/files"/. /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/
find /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/ -name \*.rej -or -name \*.orig | xargs -r rm -f
if [ -d /tmpram/openwrt/target/linux/generic/patches ]; then echo "generic patches directory is present. please move your patches to the pending directory" ; exit 1; fi

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.3-01-UPSTREAM-mm-multi-gen-LRU-rename-lru_gen_struct-to-l.patch using plaintext: 
patching file include/linux/mm_inline.h
patching file include/linux/mmzone.h
patching file mm/vmscan.c
patching file mm/workingset.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.3-03-UPSTREAM-mm-multi-gen-LRU-remove-eviction-fairness-s.patch using plaintext: 
patching file mm/vmscan.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.3-04-BACKPORT-mm-multi-gen-LRU-remove-aging-fairness-safe.patch using plaintext: 
patching file mm/vmscan.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.3-05-UPSTREAM-mm-multi-gen-LRU-shuffle-should_run_aging.patch using plaintext: 
patching file mm/vmscan.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.3-06-BACKPORT-mm-multi-gen-LRU-per-node-lru_gen_folio-lis.patch using plaintext: 
patching file include/linux/memcontrol.h
patching file include/linux/mm_inline.h
patching file include/linux/mmzone.h
patching file mm/memcontrol.c
patching file mm/page_alloc.c
patching file mm/vmscan.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.3-07-BACKPORT-mm-multi-gen-LRU-clarify-scan_control-flags.patch using plaintext: 
patching file mm/vmscan.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.3-08-UPSTREAM-mm-multi-gen-LRU-simplify-arch_has_hw_pte_y.patch using plaintext: 
patching file mm/vmscan.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.3-09-UPSTREAM-mm-multi-gen-LRU-avoid-futile-retries.patch using plaintext: 
patching file mm/vmscan.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.3-10-UPSTREAM-mm-add-vma_has_recency.patch using plaintext: 
patching file include/linux/mm_inline.h
patching file mm/memory.c
patching file mm/rmap.c
patching file mm/vmscan.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.3-11-UPSTREAM-mm-support-POSIX_FADV_NOREUSE.patch using plaintext: 
patching file include/linux/fs.h
patching file include/linux/mm_inline.h
patching file mm/fadvise.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.3-12-UPSTREAM-mm-multi-gen-LRU-section-for-working-set-pr.patch using plaintext: 
patching file Documentation/mm/multigen_lru.rst
patching file mm/vmscan.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.3-13-UPSTREAM-mm-multi-gen-LRU-section-for-rmap-PT-walk-f.patch using plaintext: 
patching file Documentation/mm/multigen_lru.rst
patching file mm/vmscan.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.3-14-UPSTREAM-mm-multi-gen-LRU-section-for-Bloom-filters.patch using plaintext: 
patching file Documentation/mm/multigen_lru.rst
patching file mm/vmscan.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.3-15-UPSTREAM-mm-multi-gen-LRU-section-for-memcg-LRU.patch using plaintext: 
patching file Documentation/mm/multigen_lru.rst
patching file include/linux/mm_inline.h
patching file include/linux/mmzone.h
patching file mm/memcontrol.c
patching file mm/vmscan.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.3-16-UPSTREAM-mm-multi-gen-LRU-improve-lru_gen_exit_memcg.patch using plaintext: 
patching file mm/vmscan.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.3-17-UPSTREAM-mm-multi-gen-LRU-improve-walk_pmd_range.patch using plaintext: 
patching file mm/vmscan.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.3-18-UPSTREAM-mm-multi-gen-LRU-simplify-lru_gen_look_arou.patch using plaintext: 
patching file mm/vmscan.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/020-v6.4-19-mm-Multi-gen-LRU-remove-wait_event_killable.patch using plaintext: 
patching file include/linux/mmzone.h
patching file mm/vmscan.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/300-v6.2-powerpc-suppress-some-linker-warnings-in-recent-link.patch using plaintext: 
patching file arch/powerpc/boot/wrapper

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/406-v6.2-0001-mtd-core-simplify-a-bit-code-find-partition-matching.patch using plaintext: 
patching file drivers/mtd/mtdcore.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/406-v6.2-0002-mtd-core-try-to-find-OF-node-for-every-MTD-partition.patch using plaintext: 
patching file drivers/mtd/mtdcore.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/408-v6.2-mtd-core-set-ROOT_DEV-for-partitions-marked-as-rootf.patch using plaintext: 
patching file drivers/mtd/mtdcore.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/421-v6.2-mtd-parsers-add-TP-Link-SafeLoader-partitions-table-.patch using plaintext: 
patching file drivers/mtd/parsers/Kconfig
patching file drivers/mtd/parsers/Makefile
patching file drivers/mtd/parsers/tplink_safeloader.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/423-v6.3-mtd-spinand-macronix-use-scratch-buffer-for-DMA-oper.patch using plaintext: 
patching file drivers/mtd/nand/spi/macronix.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/424-v6.4-0004-mtd-core-prepare-mtd_otp_nvmem_add-to-handle-EPROBE_.patch using plaintext: 
patching file drivers/mtd/mtdcore.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/611-v6.3-net-add-helper-eth_addr_add.patch using plaintext: 
patching file include/linux/etherdevice.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/700-v6.2-net-phylink-add-phylink_get_link_timer_ns-helper.patch using plaintext: 
patching file include/linux/phylink.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/701-net-next-net-sfp-add-quirk-for-Fiberstone-GPON-ONU-34-20BI.patch using plaintext: 
patching file drivers/net/phy/sfp.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/707-v6.3-net-pcs-add-driver-for-MediaTek-SGMII-PCS.patch using plaintext: 
patching file MAINTAINERS
patching file drivers/net/pcs/Kconfig
patching file drivers/net/pcs/Makefile
patching file drivers/net/pcs/pcs-mtk-lynxi.c
patching file include/linux/pcs/pcs-mtk-lynxi.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/724-v6.2-net-ethernet-mtk_eth_soc-enable-flow-offloading-supp.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-01-v6.1-net-ethernet-mtk_wed-introduce-wed-mcu-support.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/Makefile
patching file drivers/net/ethernet/mediatek/mtk_wed_mcu.c
patching file drivers/net/ethernet/mediatek/mtk_wed_regs.h
patching file drivers/net/ethernet/mediatek/mtk_wed_wo.h
patching file include/linux/soc/mediatek/mtk_wed.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-02-v6.1-net-ethernet-mtk_wed-introduce-wed-wo-support.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/Makefile
patching file drivers/net/ethernet/mediatek/mtk_wed.c
patching file drivers/net/ethernet/mediatek/mtk_wed.h
patching file drivers/net/ethernet/mediatek/mtk_wed_mcu.c
patching file drivers/net/ethernet/mediatek/mtk_wed_wo.c
patching file drivers/net/ethernet/mediatek/mtk_wed_wo.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-03-v6.1-net-ethernet-mtk_wed-rename-tx_wdma-array-in-rx_wdma.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed.c
patching file include/linux/soc/mediatek/mtk_wed.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-04-v6.1-net-ethernet-mtk_wed-add-configure-wed-wo-support.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed.c
patching file drivers/net/ethernet/mediatek/mtk_wed.h
patching file drivers/net/ethernet/mediatek/mtk_wed_mcu.c
patching file drivers/net/ethernet/mediatek/mtk_wed_regs.h
patching file drivers/net/ethernet/mediatek/mtk_wed_wo.h
patching file include/linux/soc/mediatek/mtk_wed.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-05-v6.1-net-ethernet-mtk_wed-add-rx-mib-counters.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed_debugfs.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-07-v6.1-net-ethernet-mtk_eth_soc-remove-cpu_relax-in-mtk_pen.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-09-v6.2-net-ethernet-mtk_wed-add-wcid-overwritten-support-fo.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed.c
patching file drivers/net/ethernet/mediatek/mtk_wed_regs.h
patching file include/linux/soc/mediatek/mtk_wed.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-10-v6.2-net-ethernet-mtk_wed-return-status-value-in-mtk_wdma.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-11-v6.2-net-ethernet-mtk_wed-move-MTK_WDMA_RESET_IDX_TX-conf.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-12-v6.2-net-ethernet-mtk_wed-update-mtk_wed_stop.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed.c
patching file include/linux/soc/mediatek/mtk_wed.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-13-v6.2-net-ethernet-mtk_wed-add-mtk_wed_rx_reset-routine.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed.c
patching file drivers/net/ethernet/mediatek/mtk_wed_regs.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-14-v6.2-net-ethernet-mtk_wed-add-reset-to-tx_ring_setup-call.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed.c
patching file include/linux/soc/mediatek/mtk_wed.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-15-v6.2-net-ethernet-mtk_wed-fix-sleep-while-atomic-in-mtk_w.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed_wo.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-16-v6.3-net-ethernet-mtk_wed-get-rid-of-queue-lock-for-rx-qu.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed_wo.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-17-v6.3-net-ethernet-mtk_wed-get-rid-of-queue-lock-for-tx-qu.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed_wo.c
patching file drivers/net/ethernet/mediatek/mtk_wed_wo.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-18-v6.3-net-ethernet-mtk_eth_soc-introduce-mtk_hw_reset-util.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-19-v6.3-net-ethernet-mtk_eth_soc-introduce-mtk_hw_warm_reset.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-20-v6.3-net-ethernet-mtk_eth_soc-align-reset-procedure-to-ve.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h
patching file drivers/net/ethernet/mediatek/mtk_ppe.c
patching file drivers/net/ethernet/mediatek/mtk_ppe.h
patching file drivers/net/ethernet/mediatek/mtk_ppe_regs.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-21-v6.3-net-ethernet-mtk_eth_soc-add-dma-checks-to-mtk_hw_re.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-22-v6.3-net-ethernet-mtk_wed-add-reset-reset_complete-callba.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_wed.c
patching file drivers/net/ethernet/mediatek/mtk_wed.h
patching file include/linux/soc/mediatek/mtk_wed.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/729-23-v6.3-net-ethernet-mtk_wed-add-reset-to-rx_ring_setup-call.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed.c
patching file include/linux/soc/mediatek/mtk_wed.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/730-01-v6.3-net-ethernet-mtk_eth_soc-account-for-vlan-in-rx-head.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/730-02-v6.3-net-ethernet-mtk_eth_soc-increase-tx-ring-side-for-Q.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/730-03-v6.3-net-ethernet-mtk_eth_soc-avoid-port_mg-assignment-on.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_ppe.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/730-04-v6.3-net-ethernet-mtk_eth_soc-implement-multi-queue-suppo.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/730-05-v6.3-net-dsa-tag_mtk-assign-per-port-queues.patch using plaintext: 
patching file net/dsa/tag_mtk.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/730-06-v6.3-net-ethernet-mediatek-ppe-assign-per-port-queues-for.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_ppe.c
patching file drivers/net/ethernet/mediatek/mtk_ppe.h
patching file drivers/net/ethernet/mediatek/mtk_ppe_offload.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/730-08-v6.3-net-dsa-add-support-for-DSA-rx-offloading-via-metada.patch using plaintext: 
patching file net/core/flow_dissector.c
patching file net/dsa/dsa.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/730-09-v6.3-net-ethernet-mtk_eth_soc-fix-VLAN-rx-hardware-accele.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/730-12-v6.3-net-ethernet-mtk_eth_soc-disable-hardware-DSA-untagg.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/730-13-v6.3-net-ethernet-mtk_eth_soc-enable-special-tag-when-any.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/730-14-v6.3-net-ethernet-mtk_eth_soc-fix-DSA-TX-tag-hwaccel-for-.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/730-15-v6.3-net-ethernet-mtk_wed-No-need-to-clear-memory-after-a.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/730-16-v6.3-net-ethernet-mtk_wed-fix-some-possible-NULL-pointer-.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed.c
patching file drivers/net/ethernet/mediatek/mtk_wed_mcu.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/730-17-v6.3-net-ethernet-mtk_wed-fix-possible-deadlock-if-mtk_we.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/730-18-v6.3-net-ethernet-mtk_eth_soc-fix-tx-throughput-regressio.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.2-02-net-mtk_eth_soc-add-definitions-for-PCS.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.2-03-net-mtk_eth_soc-eliminate-unnecessary-error-handling.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_sgmii.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.2-04-net-mtk_eth_soc-add-pcs_get_state-implementation.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_sgmii.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.2-05-net-mtk_eth_soc-convert-mtk_sgmii-to-use-regmap_upda.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_sgmii.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.2-06-net-mtk_eth_soc-add-out-of-band-forcing-of-speed-and.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_sgmii.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.2-07-net-mtk_eth_soc-move-PHY-power-up.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_sgmii.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.2-08-net-mtk_eth_soc-move-interface-speed-selection.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_sgmii.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.2-09-net-mtk_eth_soc-add-advertisement-programming.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_sgmii.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.2-10-net-mtk_eth_soc-move-and-correct-link-timer-programm.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_sgmii.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.2-11-net-mtk_eth_soc-add-support-for-in-band-802.3z-negot.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_sgmii.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.2-12-net-mediatek-sgmii-ensure-the-SGMII-PHY-is-powered-d.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h
patching file drivers/net/ethernet/mediatek/mtk_sgmii.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.2-13-net-mediatek-sgmii-fix-duplex-configuration.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h
patching file drivers/net/ethernet/mediatek/mtk_sgmii.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.2-14-mtk_sgmii-enable-PCS-polling-to-allow-SFP-work.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_sgmii.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.3-15-net-ethernet-mtk_eth_soc-reset-PCS-state.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h
patching file drivers/net/ethernet/mediatek/mtk_sgmii.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.3-16-net-ethernet-mtk_eth_soc-only-write-values-if-needed.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_sgmii.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.3-18-net-ethernet-mtk_eth_soc-add-support-for-MT7981.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_path.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h
patching file drivers/net/ethernet/mediatek/mtk_sgmii.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.3-19-net-ethernet-mtk_eth_soc-set-MDIO-bus-clock-frequenc.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.3-20-net-ethernet-mtk_eth_soc-switch-to-external-PCS-driv.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/Kconfig
patching file drivers/net/ethernet/mediatek/Makefile
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h
patching file drivers/net/ethernet/mediatek/mtk_sgmii.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.4-21-net-mtk_eth_soc-use-WO-firmware-for-MT7981.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed_mcu.c
patching file drivers/net/ethernet/mediatek/mtk_wed_wo.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.4-22-net-ethernet-mtk_eth_soc-fix-NULL-pointer-dereferenc.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.4-23-net-ethernet-mtk_eth_soc-ppe-add-support-for-flow-ac.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h
patching file drivers/net/ethernet/mediatek/mtk_ppe.c
patching file drivers/net/ethernet/mediatek/mtk_ppe.h
patching file drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
patching file drivers/net/ethernet/mediatek/mtk_ppe_offload.c
patching file drivers/net/ethernet/mediatek/mtk_ppe_regs.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.4-24-net-ethernet-mediatek-fix-ppe-flow-accounting-for-v1.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_ppe.c
patching file drivers/net/ethernet/mediatek/mtk_ppe.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.4-25-net-ethernet-mtk_eth_soc-drop-generic-vlan-rx-offloa.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/733-v6.5-26-net-ethernet-mtk_eth_soc-always-mtk_get_ib1_pkt_type.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-01-net-ethernet-mtk_ppe-add-MTK_FOE_ENTRY_V-1-2-_SIZE-m.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_ppe.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-02-net-ethernet-mtk_eth_soc-remove-incorrect-PLL-config.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-03-net-ethernet-mtk_eth_soc-remove-mac_pcs_get_state-an.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-05-net-ethernet-mtk_eth_soc-add-version-in-mtk_soc_data.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h
patching file drivers/net/ethernet/mediatek/mtk_ppe.c
patching file drivers/net/ethernet/mediatek/mtk_ppe_offload.c
patching file drivers/net/ethernet/mediatek/mtk_wed.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-06-net-ethernet-mtk_eth_soc-increase-MAX_DEVS-to-3.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-07-net-ethernet-mtk_eth_soc-rely-on-MTK_MAX_DEVS-and-re.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-08-net-ethernet-mtk_eth_soc-add-NETSYS_V3-version-suppo.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-09-net-ethernet-mtk_eth_soc-convert-caps-in-mtk_soc_dat.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_path.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-10-net-ethernet-mtk_eth_soc-convert-clock-bitmap-to-u64.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-11-net-ethernet-mtk_eth_soc-add-basic-support-for-MT798.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_path.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-12-net-ethernet-mtk_eth_soc-enable-page_pool-support-fo.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-13-net-ethernet-mtk_eth_soc-enable-nft-hw-flowtable_off.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_ppe.c
patching file drivers/net/ethernet/mediatek/mtk_ppe.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-14-net-ethernet-mtk_eth_soc-support-per-flow-accounting.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_ppe.c
patching file drivers/net/ethernet/mediatek/mtk_ppe_regs.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-15-net-ethernet-mtk_eth_soc-fix-NULL-pointer-on-hw-rese.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_wed.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-16-net-ethernet-mtk_eth_soc-fix-register-definitions-fo.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-17-net-ethernet-mtk_eth_soc-add-reset-bits-for-MT7988.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-18-net-ethernet-mtk_eth_soc-add-support-for-in-SoC-SRAM.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-19-net-ethernet-mtk_eth_soc-support-36-bit-DMA-addressi.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-20-net-ethernet-mtk_eth_soc-fix-uninitialized-variable.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/750-v6.5-21-net-ethernet-mtk_eth_soc-fix-pse_port-configuration-.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_ppe_offload.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/777-v6.2-04-net-dsa-qca8k-introduce-single-mii-read-write-lo-hi.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-8xxx.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/777-v6.2-05-net-dsa-qca8k-improve-mdio-master-read-write-by-usin.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-8xxx.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/778-v6.3-01-net-dsa-qca8k-add-QCA8K_ATU_TABLE_SIZE-define-for-fd.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-common.c
patching file drivers/net/dsa/qca/qca8k.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/778-v6.3-02-net-dsa-qca8k-convert-to-regmap-read-write-API.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-8xxx.c
patching file drivers/net/dsa/qca/qca8k-common.c
patching file drivers/net/dsa/qca/qca8k.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/779-v6.5-net-dsa-qca8k-enable-use_single_write-for-qca8xxx.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-8xxx.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/780-v6.6-01-net-dsa-qca8k-make-learning-configurable-and-keep-of.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-8xxx.c
patching file drivers/net/dsa/qca/qca8k-common.c
patching file drivers/net/dsa/qca/qca8k.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/780-v6.6-02-net-dsa-qca8k-limit-user-ports-access-to-the-first-C.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-8xxx.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/780-v6.6-03-net-dsa-qca8k-move-qca8xxx-hol-fixup-to-separate-fun.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-8xxx.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/780-v6.6-04-net-dsa-qca8k-use-dsa_for_each-macro-instead-of-for-.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-8xxx.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/781-v6.6-01-net-dsa-qca8k-fix-regmap-bulk-read-write-methods-on-.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-8xxx.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/788-v6.3-net-dsa-mt7530-use-external-PCS-driver.patch using plaintext: 
patching file drivers/net/dsa/Kconfig
patching file drivers/net/dsa/mt7530.c
patching file drivers/net/dsa/mt7530.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/790-v6.4-0001-net-dsa-mt7530-make-some-noise-if-register-read-fail.patch using plaintext: 
patching file drivers/net/dsa/mt7530.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/790-v6.4-0002-net-dsa-mt7530-refactor-SGMII-PCS-creation.patch using plaintext: 
patching file drivers/net/dsa/mt7530.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/790-v6.4-0003-net-dsa-mt7530-use-unlocked-regmap-accessors.patch using plaintext: 
patching file drivers/net/dsa/mt7530.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/790-v6.4-0004-net-dsa-mt7530-use-regmap-to-access-switch-register-.patch using plaintext: 
patching file drivers/net/dsa/mt7530.c
patching file drivers/net/dsa/mt7530.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/790-v6.4-0005-net-dsa-mt7530-move-SGMII-PCS-creation-to-mt7530_pro.patch using plaintext: 
patching file drivers/net/dsa/mt7530.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/790-v6.4-0006-net-dsa-mt7530-introduce-mutex-helpers.patch using plaintext: 
patching file drivers/net/dsa/mt7530.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/790-v6.4-0007-net-dsa-mt7530-move-p5_intf_modes-function-to-mt7530.patch using plaintext: 
patching file drivers/net/dsa/mt7530.c
patching file drivers/net/dsa/mt7530.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/790-v6.4-0008-net-dsa-mt7530-introduce-mt7530_probe_common-helper-.patch using plaintext: 
patching file drivers/net/dsa/mt7530.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/790-v6.4-0009-net-dsa-mt7530-introduce-mt7530_remove_common-helper.patch using plaintext: 
patching file drivers/net/dsa/mt7530.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/790-v6.4-0010-net-dsa-mt7530-introduce-separate-MDIO-driver.patch using plaintext: 
patching file MAINTAINERS
patching file drivers/net/dsa/Kconfig
patching file drivers/net/dsa/Makefile
patching file drivers/net/dsa/mt7530-mdio.c
patching file drivers/net/dsa/mt7530.c
patching file drivers/net/dsa/mt7530.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/790-v6.4-0011-net-dsa-mt7530-skip-locking-if-MDIO-bus-isn-t-presen.patch using plaintext: 
patching file drivers/net/dsa/mt7530.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/790-v6.4-0012-net-dsa-mt7530-introduce-driver-for-MT7988-built-in-.patch using plaintext: 
patching file MAINTAINERS
patching file drivers/net/dsa/Kconfig
patching file drivers/net/dsa/Makefile
patching file drivers/net/dsa/mt7530-mmio.c
patching file drivers/net/dsa/mt7530.c
patching file drivers/net/dsa/mt7530.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/790-v6.4-0013-net-dsa-mt7530-fix-support-for-MT7531BE.patch using plaintext: 
patching file drivers/net/dsa/mt7530-mdio.c
patching file drivers/net/dsa/mt7530.c
patching file drivers/net/dsa/mt7530.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/791-v6.2-01-net-phy-Add-driver-for-Motorcomm-yt8521-gigabit-ethernet.patch using plaintext: 
patching file MAINTAINERS
patching file drivers/net/phy/Kconfig
patching file drivers/net/phy/motorcomm.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/791-v6.2-02-net-phy-fix-yt8521-duplicated-argument-to-or.patch using plaintext: 
patching file drivers/net/phy/motorcomm.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/791-v6.2-03-net-phy-add-Motorcomm-YT8531S-phy-id.patch using plaintext: 
patching file drivers/net/phy/Kconfig
patching file drivers/net/phy/motorcomm.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/791-v6.3-04-net-phy-fix-the-spelling-problem-of-Sentinel.patch using plaintext: 
patching file drivers/net/phy/motorcomm.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/791-v6.3-05-net-phy-motorcomm-change-the-phy-id-of-yt8521-and-yt8531s.patch using plaintext: 
patching file drivers/net/phy/motorcomm.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/791-v6.3-06-net-phy-Add-BIT-macro-for-Motorcomm-yt8521-yt8531-gigabit.patch using plaintext: 
patching file drivers/net/phy/motorcomm.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/791-v6.3-07-net-phy-Add-dts-support-for-Motorcomm-yt8521-gigabit.patch using plaintext: 
patching file drivers/net/phy/motorcomm.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/791-v6.3-08-net-phy-Add-dts-support-for-Motorcomm-yt8531s-gigabit.patch using plaintext: 
patching file drivers/net/phy/motorcomm.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/791-v6.3-09-net-phy-Add-driver-for-Motorcomm-yt8531-gigabit-ethernet.patch using plaintext: 
patching file drivers/net/phy/Kconfig
patching file drivers/net/phy/motorcomm.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/791-v6.3-10-net-phy-motorcomm-uninitialized-variables-in.patch using plaintext: 
patching file drivers/net/phy/motorcomm.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/792-v6.6-net-phylink-add-pcs_enable-pcs_disable-methods.patch using plaintext: 
patching file drivers/net/phy/phylink.c
patching file include/linux/phylink.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/793-v6.6-net-pcs-lynxi-implement-pcs_disable-op.patch using plaintext: 
patching file drivers/net/pcs/pcs-mtk-lynxi.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/794-v6.2-net-core-Allow-live-renaming-when-an-interface-is-up.patch using plaintext: 
patching file include/linux/netdevice.h
patching file net/core/dev.c
patching file net/core/failover.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/800-v6.3-leds-Move-led_init_default_state_get-to-the-global-h.patch using plaintext: 
patching file drivers/leds/leds.h
patching file include/linux/leds.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/801-v6.4-01-net-dsa-qca8k-move-qca8k_port_to_phy-to-header.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-8xxx.c
patching file drivers/net/dsa/qca/qca8k.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/801-v6.4-02-net-dsa-qca8k-add-LEDs-basic-support.patch using plaintext: 
patching file drivers/net/dsa/qca/Kconfig
patching file drivers/net/dsa/qca/Makefile
patching file drivers/net/dsa/qca/qca8k-8xxx.c
patching file drivers/net/dsa/qca/qca8k-leds.c
patching file drivers/net/dsa/qca/qca8k.h
patching file drivers/net/dsa/qca/qca8k_leds.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/801-v6.4-03-net-dsa-qca8k-add-LEDs-blink_set-support.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-leds.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/801-v6.4-04-leds-Provide-stubs-for-when-CLASS_LED-NEW_LEDS-are-d.patch using plaintext: 
patching file include/linux/leds.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/801-v6.4-05-net-phy-Add-a-binding-for-PHY-LEDs.patch using plaintext: 
patching file drivers/net/phy/Kconfig
patching file drivers/net/phy/phy_device.c
patching file include/linux/phy.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/801-v6.4-06-net-phy-phy_device-Call-into-the-PHY-driver-to-set-L.patch using plaintext: 
patching file drivers/net/phy/phy_device.c
patching file include/linux/phy.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/801-v6.4-07-net-phy-marvell-Add-software-control-of-the-LEDs.patch using plaintext: 
patching file drivers/net/phy/marvell.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/801-v6.4-08-net-phy-phy_device-Call-into-the-PHY-driver-to-set-L.patch using plaintext: 
patching file drivers/net/phy/phy_device.c
patching file include/linux/phy.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/801-v6.4-09-net-phy-marvell-Implement-led_blink_set.patch using plaintext: 
patching file drivers/net/phy/marvell.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/802-v6.4-net-phy-marvell-Fix-inconsistent-indenting-in-led_bl.patch using plaintext: 
patching file drivers/net/phy/marvell.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/803-v6.5-02-leds-trigger-netdev-Drop-NETDEV_LED_MODE_LINKUP-from.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/803-v6.5-03-leds-trigger-netdev-Rename-add-namespace-to-netdev-t.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/803-v6.5-04-leds-trigger-netdev-Convert-device-attr-to-macro.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/803-v6.5-05-leds-trigger-netdev-Use-mutex-instead-of-spinlocks.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/804-v6.5-01-leds-add-APIs-for-LEDs-hw-control.patch using plaintext: 
patching file include/linux/leds.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/804-v6.5-02-leds-add-API-to-get-attached-device-for-LED-hw-contr.patch using plaintext: 
patching file include/linux/leds.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/804-v6.5-03-Documentation-leds-leds-class-Document-new-Hardware-.patch using plaintext: 
patching file Documentation/leds/leds-class.rst

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/804-v6.5-04-leds-trigger-netdev-refactor-code-setting-device-nam.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/804-v6.5-05-leds-trigger-netdev-introduce-check-for-possible-hw-.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/804-v6.5-06-leds-trigger-netdev-add-basic-check-for-hw-control-s.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/804-v6.5-07-leds-trigger-netdev-reject-interval-store-for-hw_con.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/804-v6.5-08-leds-trigger-netdev-add-support-for-LED-hw-control.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/804-v6.5-09-leds-trigger-netdev-validate-configured-netdev.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/804-v6.5-10-leds-trigger-netdev-init-mode-if-hw-control-already-.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/804-v6.5-11-leds-trigger-netdev-expose-netdev-trigger-modes-in-l.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c
patching file include/linux/leds.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/804-v6.5-12-net-dsa-qca8k-implement-hw_control-ops.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-leds.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/804-v6.5-13-net-dsa-qca8k-add-op-to-get-ports-netdev.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-leds.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/805-v6.5-01-leds-trigger-netdev-add-additional-specific-link-spe.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c
patching file include/linux/leds.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/805-v6.5-02-leds-trigger-netdev-add-additional-specific-link-dup.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c
patching file include/linux/leds.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/805-v6.5-03-leds-trigger-netdev-expose-hw_control-status-via-sys.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/806-v6.5-net-dsa-qca8k-add-support-for-additional-modes-for-n.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-leds.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/807-v6.5-01-net-dsa-mv88e6xxx-pass-directly-chip-structure-to-mv.patch using plaintext: 
patching file drivers/net/dsa/mv88e6xxx/chip.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/807-v6.5-02-net-dsa-mv88e6xxx-use-mv88e6xxx_phy_is_internal-in-m.patch using plaintext: 
patching file drivers/net/dsa/mv88e6xxx/chip.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/807-v6.5-03-net-dsa-mv88e6xxx-add-field-to-specify-internal-phys.patch using plaintext: 
patching file drivers/net/dsa/mv88e6xxx/chip.c
patching file drivers/net/dsa/mv88e6xxx/chip.h
patching file drivers/net/dsa/mv88e6xxx/global2.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/807-v6.5-04-net-dsa-mv88e6xxx-fix-88E6393X-family-internal-phys-.patch using plaintext: 
patching file drivers/net/dsa/mv88e6xxx/chip.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/807-v6.5-05-net-dsa-mv88e6xxx-pass-mv88e6xxx_chip-structure-to-p.patch using plaintext: 
patching file drivers/net/dsa/mv88e6xxx/chip.c
patching file drivers/net/dsa/mv88e6xxx/chip.h
patching file drivers/net/dsa/mv88e6xxx/port.c
patching file drivers/net/dsa/mv88e6xxx/port.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/807-v6.5-06-net-dsa-mv88e6xxx-enable-support-for-88E6361-switch.patch using plaintext: 
patching file drivers/net/dsa/mv88e6xxx/chip.c
patching file drivers/net/dsa/mv88e6xxx/chip.h
patching file drivers/net/dsa/mv88e6xxx/port.c
patching file drivers/net/dsa/mv88e6xxx/port.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/808-v6.2-0001-nvmem-stm32-move-STM32MP15_BSEC_NUM_LOWER-in-config.patch using plaintext: 
patching file drivers/nvmem/stm32-romem.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/808-v6.2-0002-nvmem-stm32-add-warning-when-upper-OTPs-are-updated.patch using plaintext: 
patching file drivers/nvmem/stm32-romem.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/808-v6.2-0003-nvmem-stm32-add-nvmem-type-attribute.patch using plaintext: 
patching file drivers/nvmem/stm32-romem.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/808-v6.2-0004-nvmem-stm32-fix-spelling-typo-in-comment.patch using plaintext: 
patching file drivers/nvmem/stm32-romem.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/808-v6.2-0005-nvmem-Kconfig-Fix-spelling-mistake-controlls-control.patch using plaintext: 
patching file drivers/nvmem/Kconfig

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/808-v6.2-0006-nvmem-u-boot-env-add-Broadcom-format-support.patch using plaintext: 
patching file drivers/nvmem/u-boot-env.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/809-v6.3-0001-nvmem-core-remove-spurious-white-space.patch using plaintext: 
patching file drivers/nvmem/core.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/809-v6.3-0002-nvmem-core-add-an-index-parameter-to-the-cell.patch using plaintext: 
patching file drivers/nvmem/core.c
patching file drivers/nvmem/imx-ocotp.c
patching file include/linux/nvmem-provider.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/809-v6.3-0003-nvmem-core-move-struct-nvmem_cell_info-to-nvmem-prov.patch using plaintext: 
patching file include/linux/nvmem-consumer.h
patching file include/linux/nvmem-provider.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/809-v6.3-0004-nvmem-core-drop-the-removal-of-the-cells-in-nvmem_ad.patch using plaintext: 
patching file drivers/nvmem/core.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/809-v6.3-0005-nvmem-core-add-nvmem_add_one_cell.patch using plaintext: 
patching file drivers/nvmem/core.c
patching file include/linux/nvmem-provider.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/809-v6.3-0006-nvmem-core-use-nvmem_add_one_cell-in-nvmem_add_cells.patch using plaintext: 
patching file drivers/nvmem/core.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/809-v6.3-0007-nvmem-stm32-add-OP-TEE-support-for-STM32MP13x.patch using plaintext: 
patching file drivers/nvmem/Kconfig
patching file drivers/nvmem/Makefile
patching file drivers/nvmem/stm32-bsec-optee-ta.c
patching file drivers/nvmem/stm32-bsec-optee-ta.h
patching file drivers/nvmem/stm32-romem.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/809-v6.3-0008-nvmem-stm32-detect-bsec-pta-presence-for-STM32MP15x.patch using plaintext: 
patching file drivers/nvmem/stm32-romem.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/809-v6.3-0009-nvmem-rave-sp-eeprm-fix-kernel-doc-bad-line-warning.patch using plaintext: 
patching file drivers/nvmem/rave-sp-eeprom.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/809-v6.3-0010-nvmem-qcom-spmi-sdam-register-at-device-init-time.patch using plaintext: 
patching file drivers/nvmem/qcom-spmi-sdam.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/809-v6.3-0011-nvmem-stm32-fix-OPTEE-dependency.patch using plaintext: 
patching file drivers/nvmem/Kconfig

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0001-nvmem-xilinx-zynqmp-make-modular.patch using plaintext: 
patching file drivers/nvmem/Kconfig

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0002-nvmem-core-introduce-NVMEM-layouts.patch using plaintext: 
patching file Documentation/driver-api/nvmem.rst
patching file drivers/nvmem/Kconfig
patching file drivers/nvmem/Makefile
patching file drivers/nvmem/core.c
patching file drivers/nvmem/layouts/Kconfig
patching file drivers/nvmem/layouts/Makefile
patching file include/linux/nvmem-consumer.h
patching file include/linux/nvmem-provider.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0003-nvmem-core-handle-the-absence-of-expected-layouts.patch using plaintext: 
patching file drivers/nvmem/core.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0004-nvmem-core-request-layout-modules-loading.patch using plaintext: 
patching file drivers/nvmem/core.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0005-nvmem-core-add-per-cell-post-processing.patch using plaintext: 
patching file drivers/nvmem/core.c
patching file include/linux/nvmem-provider.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0006-nvmem-core-allow-to-modify-a-cell-before-adding-it.patch using plaintext: 
patching file drivers/nvmem/core.c
patching file include/linux/nvmem-provider.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0007-nvmem-imx-ocotp-replace-global-post-processing-with-.patch using plaintext: 
patching file drivers/nvmem/imx-ocotp.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0008-nvmem-cell-drop-global-cell_post_process.patch using plaintext: 
patching file drivers/nvmem/core.c
patching file include/linux/nvmem-provider.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0009-nvmem-core-provide-own-priv-pointer-in-post-process-.patch using plaintext: 
patching file drivers/nvmem/core.c
patching file include/linux/nvmem-provider.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0010-nvmem-layouts-sl28vpd-Add-new-layout-driver.patch using plaintext: 
patching file drivers/nvmem/layouts/Kconfig
patching file drivers/nvmem/layouts/Makefile
patching file drivers/nvmem/layouts/sl28vpd.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0011-nvmem-layouts-onie-tlv-Add-new-layout-driver.patch using plaintext: 
patching file drivers/nvmem/layouts/Kconfig
patching file drivers/nvmem/layouts/Makefile
patching file drivers/nvmem/layouts/onie-tlv.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0012-nvmem-stm32-romem-mark-OF-related-data-as-maybe-unus.patch using plaintext: 
patching file drivers/nvmem/stm32-romem.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0013-nvmem-mtk-efuse-Support-postprocessing-for-GPU-speed.patch using plaintext: 
patching file drivers/nvmem/mtk-efuse.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0014-nvmem-bcm-ocotp-Use-devm_platform_ioremap_resource.patch using plaintext: 
patching file drivers/nvmem/bcm-ocotp.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0015-nvmem-nintendo-otp-Use-devm_platform_ioremap_resourc.patch using plaintext: 
patching file drivers/nvmem/nintendo-otp.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0016-nvmem-vf610-ocotp-Use-devm_platform_get_and_ioremap_.patch using plaintext: 
patching file drivers/nvmem/vf610-ocotp.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0017-nvmem-core-support-specifying-both-cell-raw-data-pos.patch using plaintext: 
patching file drivers/nvmem/core.c
patching file include/linux/nvmem-provider.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0018-nvmem-u-boot-env-post-process-ethaddr-env-variable.patch using plaintext: 
patching file drivers/nvmem/Kconfig
patching file drivers/nvmem/u-boot-env.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0019-nvmem-Add-macro-to-register-nvmem-layout-drivers.patch using plaintext: 
patching file include/linux/nvmem-provider.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0020-nvmem-layouts-sl28vpd-Use-module_nvmem_layout_driver.patch using plaintext: 
patching file drivers/nvmem/layouts/sl28vpd.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0021-nvmem-layouts-onie-tlv-Use-module_nvmem_layout_drive.patch using plaintext: 
patching file drivers/nvmem/layouts/onie-tlv.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0022-nvmem-layouts-onie-tlv-Drop-wrong-module-alias.patch using plaintext: 
patching file drivers/nvmem/layouts/onie-tlv.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/811-v6.4-0023-nvmem-layouts-sl28vpd-set-varaiable-sl28vpd_layout-s.patch using plaintext: 
patching file drivers/nvmem/layouts/sl28vpd.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/812-v6.2-firmware-nvram-bcm47xx-support-init-from-IO-memory.patch using plaintext: 
patching file drivers/firmware/broadcom/bcm47xx_nvram.c
patching file drivers/nvmem/brcm_nvram.c
patching file include/linux/bcm47xx_nvram.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/813-v6.5-0001-nvmem-imx-ocotp-set-varaiable-imx_ocotp_layout-stora.patch using plaintext: 
patching file drivers/nvmem/imx-ocotp.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/813-v6.5-0002-nvmem-imx-ocotp-Reverse-MAC-addresses-on-all-i.MX-de.patch using plaintext: 
patching file drivers/nvmem/imx-ocotp.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/813-v6.5-0003-nvmem-brcm_nvram-add-.read_post_process-for-MACs.patch using plaintext: 
patching file drivers/nvmem/Kconfig
patching file drivers/nvmem/brcm_nvram.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/813-v6.5-0004-nvmem-rockchip-otp-Add-clks-and-reg_read-to-rockchip.patch using plaintext: 
patching file drivers/nvmem/rockchip-otp.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/813-v6.5-0005-nvmem-rockchip-otp-Generalize-rockchip_otp_wait_stat.patch using plaintext: 
patching file drivers/nvmem/rockchip-otp.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/813-v6.5-0006-nvmem-rockchip-otp-Use-devm_reset_control_array_get_.patch using plaintext: 
patching file drivers/nvmem/rockchip-otp.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/813-v6.5-0007-nvmem-rockchip-otp-Improve-probe-error-handling.patch using plaintext: 
patching file drivers/nvmem/rockchip-otp.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/813-v6.5-0008-nvmem-rockchip-otp-Add-support-for-RK3588.patch using plaintext: 
patching file drivers/nvmem/rockchip-otp.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/813-v6.5-0009-nvmem-zynqmp-Switch-xilinx.com-emails-to-amd.com.patch using plaintext: 
patching file drivers/nvmem/zynqmp_nvmem.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/813-v6.5-0010-nvmem-imx-support-i.MX93-OCOTP.patch using plaintext: 
patching file drivers/nvmem/Kconfig
patching file drivers/nvmem/Makefile
patching file drivers/nvmem/imx-ocotp-ele.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/813-v6.5-0011-nvmem-core-add-support-for-fixed-cells-layout.patch using plaintext: 
patching file drivers/nvmem/core.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/814-v6.6-0001-nvmem-sunxi_sid-Convert-to-devm_platform_ioremap_res.patch using plaintext: 
patching file drivers/nvmem/sunxi_sid.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/814-v6.6-0002-nvmem-brcm_nvram-Use-devm_platform_get_and_ioremap_r.patch using plaintext: 
patching file drivers/nvmem/brcm_nvram.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/814-v6.6-0003-nvmem-lpc18xx_otp-Convert-to-devm_platform_ioremap_r.patch using plaintext: 
patching file drivers/nvmem/lpc18xx_otp.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/814-v6.6-0004-nvmem-meson-mx-efuse-Convert-to-devm_platform_iorema.patch using plaintext: 
patching file drivers/nvmem/meson-mx-efuse.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/814-v6.6-0005-nvmem-rockchip-efuse-Use-devm_platform_get_and_iorem.patch using plaintext: 
patching file drivers/nvmem/rockchip-efuse.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/814-v6.6-0006-nvmem-stm32-romem-Use-devm_platform_get_and_ioremap_.patch using plaintext: 
patching file drivers/nvmem/stm32-romem.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/814-v6.6-0007-nvmem-qfprom-do-some-cleanup.patch using plaintext: 
patching file drivers/nvmem/qfprom.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/814-v6.6-0008-nvmem-uniphier-Use-devm_platform_get_and_ioremap_res.patch using plaintext: 
patching file drivers/nvmem/uniphier-efuse.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/814-v6.6-0009-nvmem-add-new-NXP-QorIQ-eFuse-driver.patch using plaintext: 
patching file drivers/nvmem/Kconfig
patching file drivers/nvmem/Makefile
patching file drivers/nvmem/qoriq-efuse.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/814-v6.6-0011-nvmem-Kconfig-Fix-typo-drive-driver.patch using plaintext: 
patching file drivers/nvmem/Kconfig

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/814-v6.6-0012-nvmem-sec-qfprom-Add-Qualcomm-secure-QFPROM-support.patch using plaintext: 
patching file drivers/nvmem/Kconfig
patching file drivers/nvmem/Makefile
patching file drivers/nvmem/sec-qfprom.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/814-v6.6-0013-nvmem-u-boot-env-Replace-zero-length-array-with-DECL.patch using plaintext: 
patching file drivers/nvmem/u-boot-env.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/814-v6.6-0014-nvmem-core-Create-all-cells-before-adding-the-nvmem-.patch using plaintext: 
patching file drivers/nvmem/core.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/814-v6.6-0015-nvmem-core-Return-NULL-when-no-nvmem-layout-is-found.patch using plaintext: 
patching file include/linux/nvmem-consumer.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/814-v6.6-0016-nvmem-core-Do-not-open-code-existing-functions.patch using plaintext: 
patching file drivers/nvmem/core.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/814-v6.6-0017-nvmem-core-Notify-when-a-new-layout-is-registered.patch using plaintext: 
patching file drivers/nvmem/core.c
patching file include/linux/nvmem-consumer.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/815-v6.6-1-leds-turris-omnia-Use-sysfs_emit-instead-of-sprintf.patch using plaintext: 
patching file drivers/leds/leds-turris-omnia.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/815-v6.7-2-leds-turris-omnia-Make-set_brightness-more-efficient.patch using plaintext: 
patching file drivers/leds/leds-turris-omnia.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/815-v6.7-3-leds-turris-omnia-Support-HW-controlled-mode-via-pri.patch using plaintext: 
patching file drivers/leds/Kconfig
patching file drivers/leds/leds-turris-omnia.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/815-v6.7-4-leds-turris-omnia-Add-support-for-enabling-disabling.patch using plaintext: 
patching file Documentation/ABI/testing/sysfs-class-led-driver-turris-omnia
patching file drivers/leds/leds-turris-omnia.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/815-v6.7-5-leds-turris-omnia-Fix-brightness-setting-and-trigger.patch using plaintext: 
patching file drivers/leds/leds-turris-omnia.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/816-v6.7-0001-nvmem-qfprom-Mark-core-clk-as-optional.patch using plaintext: 
patching file drivers/nvmem/qfprom.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/816-v6.7-0002-nvmem-add-explicit-config-option-to-read-old-syntax-.patch using plaintext: 
patching file drivers/mtd/mtdcore.c
patching file drivers/nvmem/apple-efuses.c
patching file drivers/nvmem/core.c
patching file drivers/nvmem/imx-ocotp-scu.c
patching file drivers/nvmem/imx-ocotp.c
patching file drivers/nvmem/meson-efuse.c
patching file drivers/nvmem/meson-mx-efuse.c
patching file drivers/nvmem/microchip-otpc.c
patching file drivers/nvmem/mtk-efuse.c
patching file drivers/nvmem/qcom-spmi-sdam.c
patching file drivers/nvmem/qfprom.c
patching file drivers/nvmem/rave-sp-eeprom.c
patching file drivers/nvmem/rockchip-efuse.c
patching file drivers/nvmem/sc27xx-efuse.c
patching file drivers/nvmem/sec-qfprom.c
patching file drivers/nvmem/sprd-efuse.c
patching file drivers/nvmem/stm32-romem.c
patching file drivers/nvmem/sunplus-ocotp.c
patching file drivers/nvmem/sunxi_sid.c
patching file drivers/nvmem/uniphier-efuse.c
patching file drivers/nvmem/zynqmp_nvmem.c
patching file drivers/rtc/nvmem.c
patching file drivers/w1/slaves/w1_ds250x.c
patching file include/linux/nvmem-provider.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/816-v6.7-0003-nvmem-Use-device_get_match_data.patch using plaintext: 
patching file drivers/nvmem/mxs-ocotp.c
patching file drivers/nvmem/stm32-romem.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/816-v6.7-0004-Revert-nvmem-add-new-config-option.patch using plaintext: 
patching file drivers/mtd/mtdcore.c
patching file drivers/nvmem/core.c
patching file include/linux/nvmem-provider.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/820-v6.4-net-phy-fix-circular-LEDS_CLASS-dependencies.patch using plaintext: 
patching file drivers/net/phy/Kconfig
patching file drivers/net/phy/phy_device.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/821-v6.4-net-phy-Fix-reading-LED-reg-property.patch using plaintext: 
patching file drivers/net/phy/phy_device.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/822-v6.4-net-phy-Manual-remove-LEDs-to-ensure-correct-orderin.patch using plaintext: 
patching file drivers/net/phy/phy_device.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/824-v6.5-leds-trigger-netdev-Remove-NULL-check-before-dev_-pu.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/825-v6.5-leds-trigger-netdev-uninitialized-variable-in-netdev.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/826-v6.6-01-led-trig-netdev-Fix-requesting-offload-device.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/826-v6.6-02-net-phy-phy_device-Call-into-the-PHY-driver-to-set-L.patch using plaintext: 
patching file drivers/net/phy/phy_device.c
patching file include/linux/phy.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/826-v6.6-03-net-phy-marvell-Add-support-for-offloading-LED-blink.patch using plaintext: 
patching file drivers/net/phy/marvell.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/826-v6.6-04-leds-trig-netdev-Disable-offload-on-deactivation-of-.patch using plaintext: 
patching file drivers/leds/trigger/ledtrig-netdev.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/827-v6.3-0001-of-base-add-of_parse_phandle_with_optional_args.patch using plaintext: 
patching file include/linux/of.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/827-v6.3-0002-of-property-make-.-cells-optional-for-simple-props.patch using plaintext: 
patching file drivers/of/property.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/827-v6.3-0003-of-property-add-nvmem-cell-cells-property.patch using plaintext: 
patching file drivers/of/property.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/827-v6.3-0004-of-device-Ignore-modalias-of-reused-nodes.patch using plaintext: 
patching file drivers/of/device.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/827-v6.3-0005-of-device-Do-not-ignore-error-code-in-of_device_ueve.patch using plaintext: 
patching file drivers/of/device.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/828-v6.4-0002-of-Update-of_device_get_modalias.patch using plaintext: 
patching file drivers/of/device.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/828-v6.4-0003-of-Rename-of_modalias_node.patch using plaintext: 
patching file drivers/acpi/bus.c
patching file drivers/gpu/drm/drm_mipi_dsi.c
patching file drivers/hsi/hsi_core.c
patching file drivers/i2c/busses/i2c-powermac.c
patching file drivers/i2c/i2c-core-of.c
patching file drivers/of/base.c
patching file drivers/spi/spi.c
patching file include/linux/of.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/828-v6.4-0004-of-Move-of_modalias-to-module.c.patch using plaintext: 
patching file drivers/of/Makefile
patching file drivers/of/device.c
patching file drivers/of/module.c
patching file include/linux/of.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/828-v6.4-0005-of-Move-the-request-module-helper-logic-to-module.c.patch using plaintext: 
patching file drivers/of/device.c
patching file drivers/of/module.c
patching file include/linux/of.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/830-00-v6.2-dt-bindings-arm-qcom-document-qcom-msm-id-and-qcom-b.patch using plaintext: 
patching file include/dt-bindings/arm/qcom,ids.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/830-01-v6.5-soc-qcom-socinfo-move-SMEM-item-struct-and-defines-t.patch using plaintext: 
patching file drivers/soc/qcom/socinfo.c
patching file include/linux/soc/qcom/socinfo.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/830-02-v6.5-soc-qcom-smem-Switch-to-EXPORT_SYMBOL_GPL.patch using plaintext: 
patching file drivers/soc/qcom/smem.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/830-03-v6.5-soc-qcom-smem-introduce-qcom_smem_get_soc_id.patch using plaintext: 
patching file drivers/soc/qcom/smem.c
patching file include/linux/soc/qcom/smem.h

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/830-04-v6.5-cpufreq-qcom-nvmem-use-SoC-ID-s-from-bindings.patch using plaintext: 
patching file drivers/cpufreq/qcom-cpufreq-nvmem.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/830-05-v6.5-cpufreq-qcom-nvmem-use-helper-to-get-SMEM-SoC-ID.patch using plaintext: 
patching file drivers/cpufreq/qcom-cpufreq-nvmem.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/831-v6.7-rtc-rtc7301-Support-byte-addressed-IO.patch using plaintext: 
patching file drivers/rtc/rtc-r7301.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/832-v6.7-net-phy-amd-Support-the-Altima-AMI101L.patch using plaintext: 
patching file drivers/net/phy/Kconfig
patching file drivers/net/phy/amd.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/890-v6.2-mtd-spinand-winbond-fix-flash-detection.patch using plaintext: 
patching file drivers/mtd/nand/spi/winbond.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/891-v6.2-mtd-spinand-winbond-add-W25N02KV.patch using plaintext: 
patching file drivers/mtd/nand/spi/winbond.c

Applying /tmpram/openwrt/target/linux/generic/backport-6.1/892-v6.5-mtd-spinand-winbond-Fix-ecc_get_status.patch using plaintext: 
patching file drivers/mtd/nand/spi/winbond.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/100-compiler.h-only-include-asm-rwonce.h-for-kernel-code.patch using plaintext: 
patching file include/linux/compiler.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/102-MIPS-only-process-negative-stack-offsets-on-stack-tr.patch using plaintext: 
patching file arch/mips/kernel/process.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/103-kbuild-export-SUBARCH.patch using plaintext: 
patching file Makefile

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/110-v6.3-0001-spidev-Add-Silicon-Labs-EM3581-device-compatible.patch using plaintext: 
patching file drivers/spi/spidev.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/110-v6.3-0002-spidev-Add-Silicon-Labs-SI3210-device-compatible.patch using plaintext: 
patching file drivers/spi/spidev.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/111-watchdog-max63xx_wdt-Add-support-for-specifying-WDI-.patch using plaintext: 
patching file drivers/watchdog/max63xx_wdt.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/120-Fix-alloc_node_mem_map-with-ARCH_PFN_OFFSET-calcu.patch using plaintext: 
patching file mm/page_alloc.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/140-jffs2-use-.rename2-and-add-RENAME_WHITEOUT-support.patch using plaintext: 
patching file fs/jffs2/dir.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/141-jffs2-add-RENAME_EXCHANGE-support.patch using plaintext: 
patching file fs/jffs2/dir.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/142-jffs2-add-splice-ops.patch using plaintext: 
patching file fs/jffs2/file.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/150-bridge_allow_receiption_on_disabled_port.patch using plaintext: 
patching file net/bridge/br_input.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/190-rtc-rs5c372-support_alarms_up_to_1_week.patch using plaintext: 
patching file drivers/rtc/rtc-rs5c372.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/191-rtc-rs5c372-let_the_alarm_to_be_used_as_wakeup_source.patch using plaintext: 
patching file drivers/rtc/rtc-rs5c372.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/203-kallsyms_uncompressed.patch using plaintext: 
patching file init/Kconfig
patching file kernel/kallsyms.c
patching file scripts/kallsyms.c
patching file scripts/link-vmlinux.sh

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/205-backtrace_module_info.patch using plaintext: 
patching file lib/vsprintf.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/240-remove-unsane-filenames-from-deps_initramfs-list.patch using plaintext: 
patching file usr/Makefile

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/261-enable_wilink_platform_without_drivers.patch using plaintext: 
patching file drivers/net/wireless/ti/Kconfig

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/270-platform-mikrotik-build-bits.patch using plaintext: 
patching file drivers/platform/Kconfig
patching file drivers/platform/Makefile

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/300-mips_expose_boot_raw.patch using plaintext: 
patching file arch/mips/Kconfig

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/301-MIPS-Add-barriers-between-dcache-icache-flushes.patch using plaintext: 
patching file arch/mips/mm/c-r4k.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/302-mips_no_branch_likely.patch using plaintext: 
patching file arch/mips/Makefile

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/305-mips_module_reloc.patch using plaintext: 
patching file arch/mips/Makefile
patching file arch/mips/include/asm/module.h
patching file arch/mips/kernel/module.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/308-mips32r2_tune.patch using plaintext: 
patching file arch/mips/Makefile

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/310-arm_module_unresolved_weak_sym.patch using plaintext: 
patching file arch/arm/kernel/module.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/330-MIPS-kexec-Accept-command-line-parameters-from-users.patch using plaintext: 
patching file arch/mips/kernel/machine_kexec.c
patching file arch/mips/kernel/machine_kexec.h
patching file arch/mips/kernel/relocate_kernel.S

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/332-arc-add-OWRTDTB-section.patch using plaintext: 
patching file arch/arc/kernel/head.S
patching file arch/arc/kernel/setup.c
patching file arch/arc/kernel/vmlinux.lds.S

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/333-arc-enable-unaligned-access-in-kernel-mode.patch using plaintext: 
patching file arch/arc/kernel/unaligned.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/342-powerpc-Enable-kernel-XZ-compression-option-on-PPC_8.patch using plaintext: 
patching file arch/powerpc/Kconfig

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/351-irqchip-bcm-6345-l1-request-memory-region.patch using plaintext: 
patching file drivers/irqchip/irq-bcm6345-l1.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/400-mtd-mtdsplit-support.patch using plaintext: 
patching file drivers/mtd/Kconfig
patching file drivers/mtd/Makefile
patching file drivers/mtd/mtdpart.c
patching file include/linux/mtd/mtd.h
patching file include/linux/mtd/partitions.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/401-mtd-don-t-register-NVMEM-devices-for-partitions-with.patch using plaintext: 
patching file drivers/mtd/mtdcore.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/402-mtd-spi-nor-write-support-for-minor-aligned-partitions.patch using plaintext: 
patching file drivers/mtd/mtdcore.c
patching file drivers/mtd/mtdpart.c
patching file drivers/mtd/spi-nor/Kconfig
patching file drivers/mtd/spi-nor/core.c
patching file include/linux/mtd/mtd.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/420-mtd-redboot_space.patch using plaintext: 
patching file drivers/mtd/parsers/redboot.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/430-mtd-add-myloader-partition-parser.patch using plaintext: 
patching file drivers/mtd/parsers/Kconfig
patching file drivers/mtd/parsers/Makefile
patching file drivers/mtd/parsers/myloader.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/431-mtd-bcm47xxpart-check-for-bad-blocks-when-calculatin.patch using plaintext: 
patching file drivers/mtd/parsers/parser_trx.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/432-mtd-bcm47xxpart-detect-T_Meter-partition.patch using plaintext: 
patching file drivers/mtd/parsers/bcm47xxpart.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/435-mtd-add-routerbootpart-parser-config.patch using plaintext: 
patching file drivers/mtd/parsers/Kconfig
patching file drivers/mtd/parsers/Makefile

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/460-mtd-cfi_cmdset_0002-no-erase_suspend.patch using plaintext: 
patching file drivers/mtd/chips/cfi_cmdset_0002.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/461-mtd-cfi_cmdset_0002-add-buffer-write-cmd-timeout.patch using plaintext: 
patching file drivers/mtd/chips/cfi_cmdset_0002.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/465-m25p80-mx-disable-software-protection.patch using plaintext: 
patching file drivers/mtd/spi-nor/macronix.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/476-mtd-spi-nor-add-eon-en25q128.patch using plaintext: 
patching file drivers/mtd/spi-nor/eon.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/477-mtd-spi-nor-add-eon-en25qx128a.patch using plaintext: 
patching file drivers/mtd/spi-nor/eon.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/479-mtd-spi-nor-add-xtx-xt25f128b.patch using plaintext: 
patching file drivers/mtd/spi-nor/Makefile
patching file drivers/mtd/spi-nor/xtx.c
patching file drivers/mtd/spi-nor/core.c
patching file drivers/mtd/spi-nor/core.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/481-mtd-spi-nor-add-support-for-Gigadevice-GD25D05.patch using plaintext: 
patching file drivers/mtd/spi-nor/gigadevice.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/482-mtd-spi-nor-add-gd25q512.patch using plaintext: 
patching file drivers/mtd/spi-nor/gigadevice.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/484-mtd-spi-nor-add-esmt-f25l16pa.patch using plaintext: 
patching file drivers/mtd/spi-nor/esmt.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/485-mtd-spi-nor-add-xmc-xm25qh128c.patch using plaintext: 
patching file drivers/mtd/spi-nor/xmc.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/486-01-mtd-spinand-add-support-for-ESMT-F50x1G41LB.patch using plaintext: 
patching file drivers/mtd/nand/spi/Makefile
patching file drivers/mtd/nand/spi/core.c
patching file drivers/mtd/nand/spi/esmt.c
patching file include/linux/mtd/spinand.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/487-mtd-spinand-Add-support-for-Etron-EM73D044VCx.patch using plaintext: 
patching file drivers/mtd/nand/spi/Makefile
patching file drivers/mtd/nand/spi/core.c
patching file drivers/mtd/nand/spi/etron.c
patching file include/linux/mtd/spinand.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/488-mtd-spi-nor-add-xmc-xm25qh64c.patch using plaintext: 
patching file drivers/mtd/spi-nor/xmc.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/490-ubi-auto-attach-mtd-device-named-ubi-or-data-on-boot.patch using plaintext: 
patching file drivers/mtd/ubi/build.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/491-ubi-auto-create-ubiblock-device-for-rootfs.patch using plaintext: 
patching file drivers/mtd/ubi/block.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/492-try-auto-mounting-ubi0-rootfs-in-init-do_mounts.c.patch using plaintext: 
patching file init/do_mounts.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/493-ubi-set-ROOT_DEV-to-ubiblock-rootfs-if-unset.patch using plaintext: 
patching file drivers/mtd/ubi/block.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/494-mtd-ubi-add-EOF-marker-support.patch using plaintext: 
patching file drivers/mtd/ubi/attach.c
patching file drivers/mtd/ubi/ubi.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/496-dt-bindings-add-bindings-for-mtd-concat-devices.patch using plaintext: 
patching file Documentation/devicetree/bindings/mtd/mtd-concat.txt

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/497-mtd-mtdconcat-add-dt-driver-for-concat-devices.patch using plaintext: 
patching file drivers/mtd/Kconfig
patching file drivers/mtd/Makefile
patching file drivers/mtd/composite/Kconfig
patching file drivers/mtd/composite/Makefile
patching file drivers/mtd/composite/virt_concat.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/498-mtd-spi-nor-locking-support-for-MX25L6405D.patch using plaintext: 
patching file drivers/mtd/spi-nor/macronix.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/499-mtd-spi-nor-disable-16-bit-sr-for-macronix.patch using plaintext: 
patching file drivers/mtd/spi-nor/macronix.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/500-fs_cdrom_dependencies.patch using plaintext: 
patching file fs/hfs/Kconfig
patching file fs/hfsplus/Kconfig
patching file fs/isofs/Kconfig
patching file fs/udf/Kconfig

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/530-jffs2_make_lzma_available.patch using plaintext: 
patching file fs/jffs2/Kconfig
patching file fs/jffs2/Makefile
patching file fs/jffs2/compr.c
patching file fs/jffs2/compr.h
patching file fs/jffs2/compr_lzma.c
patching file fs/jffs2/super.c
patching file include/linux/lzma.h
patching file include/linux/lzma/LzFind.h
patching file include/linux/lzma/LzHash.h
patching file include/linux/lzma/LzmaDec.h
patching file include/linux/lzma/LzmaEnc.h
patching file include/linux/lzma/Types.h
patching file include/uapi/linux/jffs2.h
patching file lib/Kconfig
patching file lib/Makefile
patching file lib/lzma/LzFind.c
patching file lib/lzma/LzmaDec.c
patching file lib/lzma/LzmaEnc.c
patching file lib/lzma/Makefile

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/532-jffs2_eofdetect.patch using plaintext: 
patching file fs/jffs2/build.c
patching file fs/jffs2/scan.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/600-netfilter_conntrack_flush.patch using plaintext: 
patching file net/netfilter/nf_conntrack_standalone.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/610-netfilter_match_bypass_default_checks.patch using plaintext: 
patching file include/uapi/linux/netfilter_ipv4/ip_tables.h
patching file net/ipv4/netfilter/ip_tables.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/611-netfilter_match_bypass_default_table.patch using plaintext: 
patching file net/ipv4/netfilter/ip_tables.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/612-netfilter_match_reduce_memory_access.patch using plaintext: 
patching file net/ipv4/netfilter/ip_tables.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/620-net_sched-codel-do-not-defer-queue-length-update.patch using plaintext: 
patching file net/sched/sch_codel.c
patching file net/sched/sch_fq_codel.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/630-packet_socket_type.patch using plaintext: 
patching file include/uapi/linux/if_packet.h
patching file net/packet/af_packet.c
patching file net/packet/internal.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/655-increase_skb_pad.patch using plaintext: 
patching file include/linux/skbuff.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/666-Add-support-for-MAP-E-FMRs-mesh-mode.patch using plaintext: 
patching file include/net/ip6_tunnel.h
patching file include/uapi/linux/if_tunnel.h
patching file net/ipv6/ip6_tunnel.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/670-ipv6-allow-rejecting-with-source-address-failed-policy.patch using plaintext: 
patching file include/net/netns/ipv6.h
patching file include/uapi/linux/fib_rules.h
patching file include/uapi/linux/rtnetlink.h
patching file net/ipv4/fib_semantics.c
patching file net/ipv4/fib_trie.c
patching file net/ipv4/ipmr.c
patching file net/ipv6/fib6_rules.c
patching file net/ipv6/ip6mr.c
patching file net/ipv6/route.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/671-net-provide-defines-for-_POLICY_FAILED-until-all-cod.patch using plaintext: 
patching file include/uapi/linux/fib_rules.h
patching file include/uapi/linux/icmpv6.h
patching file include/uapi/linux/rtnetlink.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/680-NET-skip-GRO-for-foreign-MAC-addresses.patch using plaintext: 
patching file include/linux/netdevice.h
patching file include/linux/skbuff.h
patching file net/core/gro.c
patching file net/core/dev.c
patching file net/ethernet/eth.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/682-of_net-add-mac-address-increment-support.patch using plaintext: 
patching file net/core/of_net.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/683-of_net-add-mac-address-to-of-tree.patch using plaintext: 
patching file net/core/of_net.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/684-of_net-do-mac-address-increment-only-once.patch using plaintext: 
patching file net/core/of_net.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/700-netfilter-nft_flow_offload-handle-netdevice-events-f.patch using plaintext: 
patching file net/netfilter/nf_flow_table_core.c
patching file net/netfilter/nft_flow_offload.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/701-netfilter-nf_tables-ignore-EOPNOTSUPP-on-flowtable-d.patch using plaintext: 
patching file net/netfilter/nf_tables_api.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/702-net-ethernet-mtk_eth_soc-enable-threaded-NAPI.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/703-phy-add-detach-callback-to-struct-phy_driver.patch using plaintext: 
patching file drivers/net/phy/phy_device.c
patching file include/linux/phy.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/705-net-dsa-tag_mtk-add-padding-for-tx-packets.patch using plaintext: 
patching file net/dsa/tag_mtk.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/710-bridge-add-knob-for-filtering-rx-tx-BPDU-pack.patch using plaintext: 
patching file include/linux/if_bridge.h
patching file net/bridge/br_forward.c
patching file net/bridge/br_input.c
patching file net/bridge/br_sysfs_if.c
patching file net/bridge/br_stp_bpdu.c
patching file include/uapi/linux/if_link.h
patching file net/bridge/br_netlink.c
patching file net/core/rtnetlink.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/711-01-net-dsa-qca8k-implement-lag_fdb_add-del-ops.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-8xxx.c
patching file drivers/net/dsa/qca/qca8k-common.c
patching file drivers/net/dsa/qca/qca8k.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/711-02-net-dsa-qca8k-enable-flooding-to-both-CPU-port.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-8xxx.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/711-03-net-dsa-qca8k-add-support-for-port_change_master.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-8xxx.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/712-net-dsa-qca8k-enable-assisted-learning-on-CPU-port.patch using plaintext: 
patching file drivers/net/dsa/qca/qca8k-8xxx.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/721-net-phy-realtek-rtl8221-allow-to-configure-SERDES-mo.patch using plaintext: 
patching file drivers/net/phy/realtek.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/722-net-phy-realtek-support-switching-between-SGMII-and-.patch using plaintext: 
patching file drivers/net/phy/realtek.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/723-net-mt7531-ensure-all-MACs-are-powered-down-before-r.patch using plaintext: 
patching file drivers/net/dsa/mt7530.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/724-net-phy-realtek-use-genphy_soft_reset-for-2.5G-PHYs.patch using plaintext: 
patching file drivers/net/phy/realtek.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/725-net-phy-realtek-disable-SGMII-in-band-AN-for-2-5G-PHYs.patch using plaintext: 
patching file drivers/net/phy/realtek.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/726-net-phy-realtek-make-sure-paged-read-is-protected-by.patch using plaintext: 
patching file drivers/net/phy/realtek.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/727-net-phy-realtek-use-inline-functions-for-10GbE-adver.patch using plaintext: 
patching file drivers/net/phy/realtek.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/728-net-phy-realtek-check-validity-of-10GbE-link-partner.patch using plaintext: 
patching file drivers/net/phy/realtek.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/729-net-phy-realtek-introduce-rtl822x_probe.patch using plaintext: 
patching file drivers/net/phy/realtek.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/730-net-phy-realtek-detect-early-version-of-RTL8221B.patch using plaintext: 
patching file drivers/net/phy/realtek.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/731-net-permit-ieee80211_ptr-even-with-no-CFG82111-suppo.patch using plaintext: 
patching file include/linux/netdevice.h
patching file net/batman-adv/hard-interface.c
patching file net/wireless/Kconfig

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/732-00-net-ethernet-mtk_eth_soc-compile-out-netsys-v2-code-.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/732-01-net-ethernet-mtk_eth_soc-work-around-issue-with-send.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/732-02-net-ethernet-mtk_eth_soc-set-NETIF_F_ALL_TSO.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/732-03-net-ethernet-mtk_eth_soc-fix-remaining-throughput-re.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/734-net-ethernet-mtk_eth_soc-ppe-fix-L2-offloading-with-.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_ppe.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/736-01-net-ethernet-mtk_eth_soc-add-code-for-offloading-flo.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h
patching file drivers/net/ethernet/mediatek/mtk_ppe_offload.c
patching file drivers/net/ethernet/mediatek/mtk_wed.c
patching file include/linux/soc/mediatek/mtk_wed.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/736-02-net-ethernet-mediatek-mtk_ppe-prefer-newly-added-l2-.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_ppe.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/736-03-net-ethernet-mtk_eth_soc-improve-keeping-track-of-of.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_ppe.c
patching file drivers/net/ethernet/mediatek/mtk_ppe.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/736-04-net-ethernet-mediatek-fix-ppe-flow-accounting-for-L2.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/mtk_ppe.c
patching file drivers/net/ethernet/mediatek/mtk_ppe.h
patching file drivers/net/ethernet/mediatek/mtk_ppe_debugfs.c
patching file drivers/net/ethernet/mediatek/mtk_ppe_offload.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/737-net-ethernet-mtk_eth_soc-add-paths-and-SerDes-modes-.patch using plaintext: 
patching file drivers/net/ethernet/mediatek/Kconfig
patching file drivers/net/ethernet/mediatek/Makefile
patching file drivers/net/ethernet/mediatek/mtk_eth_path.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.c
patching file drivers/net/ethernet/mediatek/mtk_eth_soc.h
patching file drivers/net/ethernet/mediatek/mtk_usxgmii.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/740-net-phy-motorcomm-Add-missing-include.patch using plaintext: 
patching file drivers/net/phy/motorcomm.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/741-net-phy-realtek-support-interrupt-of-RTL8221B.patch using plaintext: 
patching file drivers/net/phy/realtek.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/760-net-core-add-optional-threading-for-backlog-processi.patch using plaintext: 
patching file include/linux/netdevice.h
patching file net/core/dev.c
patching file net/core/sysctl_net_core.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/768-net-dsa-mv88e6xxx-Request-assisted-learning-on-CPU-port.patch using plaintext: 
patching file drivers/net/dsa/mv88e6xxx/chip.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/772-net-dsa-b53-add-support-for-BCM63xx-RGMIIs.patch using plaintext: 
patching file drivers/net/dsa/b53/b53_common.c
patching file drivers/net/dsa/b53/b53_priv.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/773-net-dsa-b53-mmap-add-more-63xx-SoCs.patch using plaintext: 
patching file drivers/net/dsa/b53/b53_mmap.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/774-net-dsa-b53-mmap-allow-passing-a-chip-ID.patch using plaintext: 
patching file drivers/net/dsa/b53/b53_common.c
patching file drivers/net/dsa/b53/b53_mmap.c
patching file drivers/net/dsa/b53/b53_priv.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/775-net-dsa-b53-add-BCM63268-RGMII-configuration.patch using plaintext: 
patching file drivers/net/dsa/b53/b53_common.c
patching file drivers/net/dsa/b53/b53_regs.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/777-net-dsa-b53-mdio-add-support-for-BCM53134.patch using plaintext: 
patching file drivers/net/dsa/b53/b53_common.c
patching file drivers/net/dsa/b53/b53_mdio.c
patching file drivers/net/dsa/b53/b53_priv.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/780-ARM-kirkwood-add-missing-linux-if_ether.h-for-ETH_AL.patch using plaintext: 
patching file arch/arm/mach-mvebu/kirkwood.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/790-bus-mhi-core-add-SBL-state-callback.patch using plaintext: 
patching file drivers/bus/mhi/host/main.c
patching file include/linux/mhi.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/795-mt7530-register-OF-node-for-internal-MDIO-bus.patch using plaintext: 
patching file drivers/net/dsa/mt7530.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/800-bcma-get-SoC-device-struct-copy-its-DMA-params-to-th.patch using plaintext: 
patching file drivers/bcma/host_soc.c
patching file drivers/bcma/main.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/801-gpio-gpio-cascade-add-generic-GPIO-cascade.patch using plaintext: 
patching file drivers/gpio/Kconfig
patching file drivers/gpio/Makefile
patching file drivers/gpio/gpio-cascade.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/802-OPP-Provide-old-opp-to-config_clks-on-_set_opp.patch using plaintext: 
patching file drivers/devfreq/tegra30-devfreq.c
patching file drivers/opp/core.c
patching file include/linux/pm_opp.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/802-nvmem-u-boot-env-align-endianness-of-crc32-values.patch using plaintext: 
patching file drivers/nvmem/u-boot-env.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/803-nvmem-core-fix-support-for-fixed-cells-NVMEM-layout.patch using plaintext: 
patching file drivers/nvmem/core.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/804-nvmem-core-support-mac-base-fixed-layout-cells.patch using plaintext: 
patching file drivers/nvmem/Kconfig
patching file drivers/nvmem/core.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/810-pci_disable_common_quirks.patch using plaintext: 
patching file drivers/pci/Kconfig
patching file drivers/pci/quirks.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/811-pci_disable_usb_common_quirks.patch using plaintext: 
patching file drivers/usb/host/pci-quirks.c
patching file drivers/usb/host/pci-quirks.h
patching file include/linux/usb/hcd.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/820-w1-gpio-fix-problem-with-platfom-data-in-w1-gpio.patch using plaintext: 
patching file drivers/w1/masters/w1-gpio.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/834-ledtrig-libata.patch using plaintext: 
patching file drivers/ata/Kconfig
patching file drivers/ata/libata-core.c
patching file include/linux/libata.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/840-hwrng-bcm2835-set-quality-to-1000.patch using plaintext: 
patching file drivers/char/hw_random/bcm2835-rng.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/850-0023-PCI-aardvark-Make-main-irq_chip-structure-a-static-d.patch using plaintext: 
patching file drivers/pci/controller/pci-aardvark.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/850-dt-bindings-clk-add-BCM63268-timer-clock-definitions.patch using plaintext: 
patching file include/dt-bindings/clock/bcm63268-clock.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/851-dt-bindings-reset-add-BCM63268-timer-reset-definitions.patch using plaintext: 
patching file include/dt-bindings/reset/bcm63268-reset.h

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/852-clk-bcm-Add-BCM63268-timer-clock-and-reset-driver.patch using plaintext: 
patching file drivers/clk/bcm/Kconfig
patching file drivers/clk/bcm/Makefile
patching file drivers/clk/bcm/clk-bcm63268-timer.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/860-serial-8250_mtk-track-busclk-state-to-avoid-bus-error.patch using plaintext: 
patching file drivers/tty/serial/8250/8250_mtk.c

Applying /tmpram/openwrt/target/linux/generic/pending-6.1/920-mangle_bootargs.patch using plaintext: 
patching file init/Kconfig
patching file init/main.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/204-module_strip.patch using plaintext: 
patching file include/linux/module.h
patching file include/linux/moduleparam.h
patching file kernel/module/Kconfig
patching file kernel/module/main.c
patching file scripts/mod/modpost.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/205-kconfig-abort-configuration-on-unset-symbol.patch using plaintext: 
patching file scripts/kconfig/conf.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/210-darwin_scripts_include.patch using plaintext: 
patching file scripts/mod/elf.h
patching file scripts/mod/mk_elfconfig.c
patching file scripts/mod/modpost.h

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/211-darwin-uuid-typedef-clash.patch using plaintext: 
patching file scripts/mod/file2alias.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/212-tools_portability.patch using plaintext: 
patching file tools/include/tools/be_byteshift.h
patching file tools/include/tools/le_byteshift.h
patching file tools/include/tools/linux_types.h
patching file tools/include/linux/types.h
patching file tools/perf/pmu-events/jevents.py
patching file tools/arch/x86/include/asm/insn.h
patching file tools/arch/x86/include/asm/orc_types.h
patching file tools/arch/x86/lib/insn.c
patching file tools/include/asm-generic/bitops/fls.h
patching file tools/include/asm-generic/bitsperlong.h
patching file tools/include/linux/rbtree.h
patching file tools/objtool/Makefile
patching file tools/objtool/check.c
patching file tools/objtool/include/objtool/objtool.h
patching file tools/objtool/orc_dump.c
patching file tools/objtool/orc_gen.c
patching file tools/objtool/special.c
patching file tools/objtool/weak.c
patching file tools/scripts/Makefile.include

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/214-spidev_h_portability.patch using plaintext: 
patching file include/uapi/linux/spi/spidev.h

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/220-arm-gc_sections.patch using plaintext: 
patching file arch/arm/Kconfig
patching file arch/arm/boot/compressed/Makefile
patching file arch/arm/kernel/vmlinux.lds.S
patching file arch/arm/include/asm/vmlinux.lds.h

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/221-module_exports.patch using plaintext: 
patching file include/asm-generic/vmlinux.lds.h
patching file include/linux/export.h
patching file include/asm-generic/export.h
patching file scripts/Makefile.build

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/230-openwrt_lzma_options.patch using plaintext: 
patching file lib/decompress.c
patching file scripts/Makefile.lib

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/250-netfilter_depends.patch using plaintext: 
patching file net/netfilter/Kconfig

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/251-kconfig.patch using plaintext: 
patching file crypto/Kconfig
patching file drivers/bcma/Kconfig
patching file drivers/ssb/Kconfig
patching file lib/Kconfig
patching file net/netfilter/Kconfig
patching file net/wireless/Kconfig
patching file sound/core/Kconfig
patching file net/Kconfig

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/253-ksmbd-config.patch using plaintext: 
patching file init/Kconfig
patching file lib/Kconfig

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/259-regmap_dynamic.patch using plaintext: 
patching file drivers/base/regmap/Kconfig
patching file drivers/base/regmap/Makefile
patching file drivers/base/regmap/regmap.c
patching file include/linux/regmap.h

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/260-crypto_test_dependencies.patch using plaintext: 
patching file crypto/Kconfig
patching file crypto/algboss.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/261-lib-arc4-unhide.patch using plaintext: 
patching file lib/crypto/Kconfig

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/280-rfkill-stubs.patch using plaintext: 
patching file include/linux/rfkill.h
patching file net/Makefile
patching file net/rfkill/Kconfig
patching file net/rfkill/Makefile

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/300-MIPS-r4k_cache-use-more-efficient-cache-blast.patch using plaintext: 
patching file arch/mips/include/asm/r4kcache.h

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/321-powerpc_crtsavres_prereq.patch using plaintext: 
patching file arch/powerpc/Makefile

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/402-mtd-blktrans-call-add-disks-after-mtd-device.patch using plaintext: 
patching file drivers/mtd/mtd_blkdevs.c
patching file drivers/mtd/mtdcore.c
patching file include/linux/mtd/blktrans.h

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/410-block-fit-partition-parser.patch using plaintext: 
patching file block/blk.h
patching file block/partitions/Kconfig
patching file block/partitions/Makefile
patching file block/partitions/check.h
patching file block/partitions/core.c
patching file block/partitions/efi.c
patching file block/partitions/efi.h
patching file block/partitions/msdos.c
patching file drivers/mtd/mtd_blkdevs.c
patching file drivers/mtd/ubi/block.c
patching file include/linux/msdos_partition.h

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/420-mtd-support-OpenWrt-s-MTD_ROOTFS_ROOT_DEV.patch using plaintext: 
patching file drivers/mtd/mtdcore.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/421-drivers-mtd-parsers-add-nvmem-support-to-cmdlinepart.patch using plaintext: 
patching file drivers/mtd/parsers/cmdlinepart.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/430-mtk-bmt-support.patch using plaintext: 
patching file drivers/mtd/nand/Kconfig
patching file drivers/mtd/nand/Makefile

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/601-of_net-add-mac-address-ascii-support.patch using plaintext: 
patching file net/core/of_net.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/645-netfilter-connmark-introduce-set-dscpmark.patch using plaintext: 
patching file include/uapi/linux/netfilter/xt_connmark.h
patching file net/netfilter/xt_connmark.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/650-netfilter-add-xt_FLOWOFFLOAD-target.patch using plaintext: 
patching file net/netfilter/Kconfig
patching file net/netfilter/Makefile
patching file net/netfilter/xt_FLOWOFFLOAD.c
patching file net/netfilter/nf_flow_table_core.c
patching file include/uapi/linux/netfilter/xt_FLOWOFFLOAD.h
patching file include/net/netfilter/nf_flow_table.h

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/651-wireless_mesh_header.patch using plaintext: 
patching file include/linux/netdevice.h

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/660-fq_codel_defaults.patch using plaintext: 
patching file net/sched/sch_fq_codel.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/661-kernel-ct-size-the-hashtable-more-adequately.patch using plaintext: 
patching file net/netfilter/nf_conntrack_core.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/700-swconfig_switch_drivers.patch using plaintext: 
patching file drivers/net/phy/Kconfig
patching file drivers/net/phy/Makefile
patching file include/linux/platform_data/b53.h

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/711-net-dsa-mv88e6xxx-disable-ATU-violation.patch using plaintext: 
patching file drivers/net/dsa/mv88e6xxx/chip.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/720-net-phy-add-aqr-phys.patch using plaintext: 
patching file drivers/net/phy/aquantia_main.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/721-net-add-packet-mangeling.patch using plaintext: 
patching file include/linux/netdevice.h
patching file include/linux/skbuff.h
patching file net/Kconfig
patching file net/core/dev.c
patching file net/core/skbuff.c
patching file net/ethernet/eth.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/722-net-phy-aquantia-enable-AQR112-and-AQR412.patch using plaintext: 
patching file drivers/net/phy/aquantia_main.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/723-net-phy-aquantia-fix-system-side-protocol-mi.patch using plaintext: 
patching file drivers/net/phy/aquantia_main.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/724-net-phy-aquantia-Add-AQR113-driver-support.patch using plaintext: 
patching file drivers/net/phy/aquantia_main.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/725-net-phy-aquantia-add-PHY_IDs-for-AQR112-variants.patch using plaintext: 
patching file drivers/net/phy/aquantia_main.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/726-net-phy-aquantia-enable-AQR111-and-AQR111B0.patch using plaintext: 
patching file drivers/net/phy/aquantia_main.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/750-net-pcs-mtk-lynxi-workaround-2500BaseX-no-an.patch using plaintext: 
patching file drivers/net/pcs/pcs-mtk-lynxi.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/760-net-usb-r8152-add-LED-configuration-from-OF.patch using plaintext: 
patching file drivers/net/usb/r8152.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/761-dt-bindings-net-add-RTL8152-binding-documentation.patch using plaintext: 
patching file Documentation/devicetree/bindings/net/realtek,rtl8152.yaml

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/765-mxl-gpy-control-LED-reg-from-DT.patch using plaintext: 
patching file drivers/net/phy/mxl-gpy.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/766-net-phy-mediatek-ge-add-LED-configuration-interface.patch using plaintext: 
patching file drivers/net/phy/mediatek-ge.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/773-bgmac-add-srab-switch.patch using plaintext: 
patching file drivers/net/ethernet/broadcom/bgmac-bcma.c
patching file drivers/net/ethernet/broadcom/bgmac.c
patching file drivers/net/ethernet/broadcom/bgmac.h

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/780-usb-net-MeigLink_modem_support.patch using plaintext: 
patching file drivers/net/usb/qmi_wwan.c
patching file drivers/usb/serial/option.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/781-usb-net-rndis-support-asr.patch using plaintext: 
patching file drivers/net/usb/rndis_host.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/790-SFP-GE-T-ignore-TX_FAULT.patch using plaintext: 
patching file drivers/net/phy/sfp.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/800-GPIO-add-named-gpio-exports.patch using plaintext: 
patching file drivers/gpio/gpiolib-of.c
patching file include/asm-generic/gpio.h
patching file include/linux/gpio/consumer.h
patching file drivers/gpio/gpiolib-sysfs.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/810-bcma-ssb-fallback-sprom.patch using plaintext: 
patching file drivers/bcma/Kconfig
patching file drivers/bcma/Makefile
patching file drivers/bcma/bcma_private.h
patching file drivers/bcma/main.c
patching file drivers/bcma/sprom.c
patching file drivers/ssb/Kconfig
patching file drivers/ssb/Makefile
patching file drivers/ssb/main.c
patching file drivers/ssb/sprom.c
patching file drivers/ssb/ssb_private.h

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/901-debloat_sock_diag.patch using plaintext: 
patching file net/Kconfig
patching file net/core/Makefile
patching file net/core/sock.c
patching file net/core/sock_diag.c
patching file net/ipv4/Kconfig
patching file net/netlink/Kconfig
patching file net/packet/Kconfig
patching file net/unix/Kconfig
patching file net/xdp/Kconfig

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/902-debloat_proc.patch using plaintext: 
patching file fs/locks.c
patching file fs/proc/Kconfig
patching file fs/proc/consoles.c
patching file fs/proc/proc_tty.c
patching file include/net/snmp.h
patching file ipc/msg.c
patching file ipc/sem.c
patching file ipc/shm.c
patching file ipc/util.c
patching file kernel/exec_domain.c
patching file kernel/irq/proc.c
patching file kernel/time/timer_list.c
patching file mm/vmalloc.c
patching file mm/vmstat.c
patching file net/8021q/vlanproc.c
patching file net/core/net-procfs.c
patching file net/core/sock.c
patching file net/ipv4/fib_trie.c
patching file net/ipv4/proc.c
patching file net/ipv4/route.c
patching file net/ipv4/inet_timewait_sock.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/904-debloat_dma_buf.patch using plaintext: 
patching file drivers/base/Kconfig
patching file drivers/dma-buf/heaps/Makefile
patching file drivers/dma-buf/Makefile
patching file drivers/dma-buf/dma-buf.c
patching file kernel/sched/core.c
patching file fs/d_path.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/910-kobject_uevent.patch using plaintext: 
patching file lib/kobject_uevent.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/911-kobject_add_broadcast_uevent.patch using plaintext: 
patching file include/linux/kobject.h
patching file lib/kobject_uevent.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/920-device_tree_cmdline.patch using plaintext: 
patching file drivers/of/fdt.c

Applying /tmpram/openwrt/target/linux/generic/hack-6.1/930-Revert-Revert-Revert-driver-core-Set-fw_devlink-on-b.patch using plaintext: 
patching file drivers/base/core.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0001-v6.2-arm64-dts-qcom-ipq8074-add-A53-PLL-node.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0002-v6.2-thermal-drivers-tsens-Add-support-for-combined-inter.patch using plaintext: 
patching file drivers/thermal/qcom/tsens-8960.c
patching file drivers/thermal/qcom/tsens-v0_1.c
patching file drivers/thermal/qcom/tsens-v1.c
patching file drivers/thermal/qcom/tsens-v2.c
patching file drivers/thermal/qcom/tsens.c
patching file drivers/thermal/qcom/tsens.h

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0003-v6.2-thermal-drivers-tsens-Allow-configuring-min-and-max-.patch using plaintext: 
patching file drivers/thermal/qcom/tsens-8960.c
patching file drivers/thermal/qcom/tsens-v0_1.c
patching file drivers/thermal/qcom/tsens-v1.c
patching file drivers/thermal/qcom/tsens-v2.c
patching file drivers/thermal/qcom/tsens.c
patching file drivers/thermal/qcom/tsens.h

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0004-v6.2-thermal-drivers-tsens-Add-IPQ8074-support.patch using plaintext: 
patching file drivers/thermal/qcom/tsens-v2.c
patching file drivers/thermal/qcom/tsens.c
patching file drivers/thermal/qcom/tsens.h

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0005-v6.2-arm64-dts-qcom-ipq8074-add-thermal-nodes.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0006-v6.2-arm64-dts-qcom-ipq8074-add-clocks-to-APCS.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0007-v6.2-clk-qcom-ipq8074-convert-to-parent-data.patch using plaintext: 
patching file drivers/clk/qcom/gcc-ipq8074.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0009-v6.2-dt-bindings-clock-qcom-ipq8074-add-missing-networkin.patch using plaintext: 
patching file include/dt-bindings/clock/qcom,gcc-ipq8074.h

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0010-v6.2-clk-qcom-ipq8074-add-missing-networking-resets.patch using plaintext: 
patching file drivers/clk/qcom/gcc-ipq8074.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0011-v6.2-clk-qcom-ipq8074-populate-fw_name-for-all-parents.patch using plaintext: 
patching file drivers/clk/qcom/gcc-ipq8074.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0012-v6.2-arm64-dts-qcom-ipq8074-pass-XO-and-sleep-clocks-to-G.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0013-v6.2-arm64-dts-qcom-add-PMP8074-DTSI.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/pmp8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0014-v6.2-arm64-dts-qcom-ipq8074-hk01-add-VQMMC-supply.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074-hk01.dts

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0015-v6.2-arm64-dts-qcom-hk01-use-GPIO-flags-for-tlmm.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074-hk01.dts

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0016-v6.2-arm64-dts-qcom-ipq8074-Fix-up-comments.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074-hk01.dts
patching file arch/arm64/boot/dts/qcom/ipq8074-hk10-c1.dts
patching file arch/arm64/boot/dts/qcom/ipq8074-hk10-c2.dts
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0017-v6.2-arm64-dts-qcom-ipq8074-align-TLMM-pin-configuration-.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0019-v6.3-arm64-dts-qcom-ipq8074-set-Gen2-PCIe-pcie-max-link-s.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0020-v6.3-PCI-qcom-Add-support-for-IPQ8074-Gen3-port.patch using plaintext: 
patching file drivers/pci/controller/dwc/pcie-qcom.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0021-v6.3-clk-qcom-ipq8074-populate-fw_name-for-usb3phy-s.patch using plaintext: 
patching file drivers/clk/qcom/gcc-ipq8074.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0023-v6.5-arm64-dts-qcom-ipq8074-add-critical-thermal-trips.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0024-v6.7-dt-bindings-arm-qcom-ids-Add-IDs-for-IPQ8174-family.patch using plaintext: 
patching file include/dt-bindings/arm/qcom,ids.h

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0025-v6.7-cpufreq-qcom-nvmem-add-support-for-IPQ8074.patch using plaintext: 
patching file drivers/cpufreq/cpufreq-dt-platdev.c
patching file drivers/cpufreq/qcom-cpufreq-nvmem.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0026-v6.5-clk-qcom-gcc-ipq6018-drop-redundant-F-define.patch using plaintext: 
patching file drivers/clk/qcom/gcc-ipq6018.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0026-v6.7-clk-qcom-ipq8074-drop-the-CLK_SET_RATE_PARENT-flag-f.patch using plaintext: 
patching file drivers/clk/qcom/gcc-ipq8074.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0027-v6.5-clk-qcom-gcc-ipq6018-update-UBI32-PLL.patch using plaintext: 
patching file drivers/clk/qcom/gcc-ipq6018.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0027-v6.7-clk-qcom-apss-ipq6018-add-the-GPLL0-clock-also-as-cl.patch using plaintext: 
patching file drivers/clk/qcom/apss-ipq6018.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0028-v6.5-clk-qcom-gcc-ipq6018-remove-duplicate-initializers.patch using plaintext: 
patching file drivers/clk/qcom/gcc-ipq6018.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0028-v6.7-arm64-dts-qcom-ipq8074-include-the-GPLL0-as-clock-pr.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0029-v6.3-dt-bindings-arm-qcom-ids-Add-IDs-for-IPQ5332-and-its.patch using plaintext: 
patching file include/dt-bindings/arm/qcom,ids.h

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0030-v6.4-dt-bindings-arm-qcom-ids-Add-IDs-for-IPQ9574-and-its.patch using plaintext: 
patching file include/dt-bindings/arm/qcom,ids.h

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0031-v6.5-dt-bindings-arm-qcom-ids-add-SoC-ID-for-IPQ5312-and-.patch using plaintext: 
patching file include/dt-bindings/arm/qcom,ids.h

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0032-v6.5-dt-bindings-arm-qcom-ids-add-SoC-ID-for-IPQ5300.patch using plaintext: 
patching file include/dt-bindings/arm/qcom,ids.h

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0100-clk-qcom-clk-rcg2-introduce-support-for-multiple-con.patch using plaintext: 
patching file drivers/clk/qcom/clk-rcg.h
patching file drivers/clk/qcom/clk-rcg2.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0101-clk-qcom-gcc-ipq8074-rework-nss_port5-6-clock-to-mul.patch using plaintext: 
patching file drivers/clk/qcom/gcc-ipq8074.c
Hunk #1 succeeded at 1676 (offset -6 lines).
Hunk #2 succeeded at 1746 (offset -6 lines).
Hunk #3 succeeded at 1816 (offset -6 lines).
Hunk #4 succeeded at 1881 (offset -6 lines).

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0102-arm64-dts-ipq8074-add-reserved-memory-nodes.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0110-arm64-dts-qcom-ipq8074-pass-QMP-PCI-PHY-PIPE-clocks-.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0111-arm64-dts-qcom-ipq8074-use-msi-parent-for-PCIe.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0112-remoteproc-qcom-Add-PRNG-proxy-clock.patch using plaintext: 
patching file drivers/remoteproc/qcom_q6v5_wcss.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0113-remoteproc-qcom-Add-secure-PIL-support.patch using plaintext: 
patching file drivers/remoteproc/qcom_q6v5_wcss.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0114-remoteproc-qcom-Add-support-for-split-q6-m3-wlan-fir.patch using plaintext: 
patching file drivers/remoteproc/qcom_q6v5_wcss.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0115-remoteproc-qcom-Add-ssr-subdevice-identifier.patch using plaintext: 
patching file drivers/remoteproc/qcom_q6v5_wcss.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0116-remoteproc-qcom-Update-regmap-offsets-for-halt-regis.patch using plaintext: 
patching file drivers/remoteproc/qcom_q6v5_wcss.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0117-dt-bindings-clock-qcom-Add-reset-for-WCSSAON.patch using plaintext: 
patching file include/dt-bindings/clock/qcom,gcc-ipq8074.h

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0118-clk-qcom-Add-WCSSAON-reset.patch using plaintext: 
patching file drivers/clk/qcom/gcc-ipq8074.c
Hunk #1 succeeded at 4711 (offset -6 lines).

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0119-remoteproc-wcss-disable-auto-boot-for-IPQ8074.patch using plaintext: 
patching file drivers/remoteproc/qcom_q6v5_wcss.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0120-arm64-dts-qcom-Enable-Q6v5-WCSS-for-ipq8074-SoC.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0121-arm64-dts-ipq8074-Add-WLAN-node.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0122-arm64-dts-ipq8074-add-CPU-clock.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0123-arm64-dts-ipq8074-add-cooling-cells-to-CPU-nodes.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0129-arm64-dts-qcom-ipq8074-add-QFPROM-fuses.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0130-arm64-dts-qcom-ipq8074-add-CPU-OPP-table.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0134-clk-qcom-ipq6018-drop-the-CLK_SET_RATE_PARENT-flag-f.patch using plaintext: 
patching file drivers/clk/qcom/gcc-ipq6018.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0135-arm64-dts-qcom-ipq6018-include-the-GPLL0-as-clock-pr.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq6018.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0900-power-Add-Qualcomm-APM.patch using plaintext: 
patching file drivers/power/Kconfig
patching file drivers/power/Makefile
patching file drivers/power/qcom/Kconfig
patching file drivers/power/qcom/Makefile
patching file drivers/power/qcom/apm.c
patching file include/linux/power/qcom/apm.h

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0901-regulator-add-Qualcomm-CPR-regulators.patch using plaintext: 
patching file drivers/regulator/Kconfig
patching file drivers/regulator/Makefile
patching file drivers/regulator/cpr3-npu-regulator.c
patching file drivers/regulator/cpr3-regulator.c
patching file drivers/regulator/cpr3-regulator.h
patching file drivers/regulator/cpr3-util.c
patching file drivers/regulator/cpr4-apss-regulator.c
patching file include/soc/qcom/socinfo.h

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0902-arm64-dts-ipq8074-add-label-to-clocks.patch using plaintext: 
patching file arch/arm64/boot/dts/qcom/ipq8074.dtsi

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0903-psci-dont-advertise-OSI-support-for-IPQ6018.patch using plaintext: 
patching file drivers/firmware/psci/psci.c

Applying /tmpram/openwrt/target/linux/qualcommax/patches-6.1/0904-clk-qcom-ipq6018-workaround-networking-clock-parenti.patch using plaintext: 
patching file drivers/clk/qcom/gcc-ipq6018.c
touch /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.prepared_b3c302f292e13393ea9c066f9ba8c6ee
rm -f /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/localversion
/tmpram/openwrt/scripts/kconfig.pl  + + /tmpram/openwrt/target/linux/generic/config-6.1 /tmpram/openwrt/target/linux/qualcommax/config-6.1 /tmpram/openwrt/target/linux/qualcommax/ipq60xx/config-default > /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.target
awk '/^(#[[:space:]]+)?CONFIG_KERNEL/{sub("CONFIG_KERNEL_","CONFIG_");print}' /tmpram/openwrt/.config >> /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.target
echo "# CONFIG_KALLSYMS_EXTRA_PASS is not set" >> /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.target
echo "# CONFIG_KALLSYMS_ALL is not set" >> /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.target
echo "CONFIG_KALLSYMS_UNCOMPRESSED=y" >> /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.target
/tmpram/openwrt/scripts/package-metadata.pl kconfig /tmpram/openwrt/tmp/.packageinfo /tmpram/openwrt/.config 6.1 > /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.override
/tmpram/openwrt/scripts/kconfig.pl 'm+' '+' /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.target /dev/null /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.override > /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.set
mv /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.set /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.old
grep -v INITRAMFS /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.old > /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.set
echo 'CONFIG_INITRAMFS_SOURCE=""' >> /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.set
echo '# CONFIG_INITRAMFS_FORCE is not set' >> /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.set
echo "# CONFIG_INITRAMFS_PRESERVE_MTIME is not set" >> /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.set
rm -rf /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/modules
cmp -s /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.set /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.prev || { cp /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.set /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config; cp /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.set /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.prev; }
export MAKEFLAGS= ; [ -d /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/user_headers ] || make -C /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63 KCFLAGS="-fmacro-prefix-map=/tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl=target-aarch64_cortex-a53_musl -fno-caller-saves " HOSTCFLAGS="-O2 -I/tmpram/openwrt/staging_dir/host/include  -Wall -Wmissing-prototypes -Wstrict-prototypes" CROSS_COMPILE="aarch64-openwrt-linux-musl-" ARCH="arm64" KBUILD_HAVE_NLS=no KBUILD_BUILD_USER="" KBUILD_BUILD_HOST="" KBUILD_BUILD_TIMESTAMP="Sat Nov 25 11:20:09 2023" KBUILD_BUILD_VERSION="0" KBUILD_HOSTLDFLAGS="-L/tmpram/openwrt/staging_dir/host/lib" CONFIG_SHELL="bash" V=''  cmd_syscalls=  CC="aarch64-openwrt-linux-musl-gcc" KERNELRELEASE=6.1.63  INSTALL_HDR_PATH=/tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/user_headers headers_install
make[4]: Entering directory '/tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63'
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/unifdef
  WRAP    arch/arm64/include/generated/uapi/asm/kvm_para.h
  WRAP    arch/arm64/include/generated/uapi/asm/errno.h
  WRAP    arch/arm64/include/generated/uapi/asm/ioctl.h
  WRAP    arch/arm64/include/generated/uapi/asm/ioctls.h
  WRAP    arch/arm64/include/generated/uapi/asm/ipcbuf.h
  WRAP    arch/arm64/include/generated/uapi/asm/msgbuf.h
  WRAP    arch/arm64/include/generated/uapi/asm/poll.h
  WRAP    arch/arm64/include/generated/uapi/asm/resource.h
  WRAP    arch/arm64/include/generated/uapi/asm/sembuf.h
  WRAP    arch/arm64/include/generated/uapi/asm/shmbuf.h
  WRAP    arch/arm64/include/generated/uapi/asm/siginfo.h
  WRAP    arch/arm64/include/generated/uapi/asm/socket.h
  WRAP    arch/arm64/include/generated/uapi/asm/sockios.h
  WRAP    arch/arm64/include/generated/uapi/asm/stat.h
  WRAP    arch/arm64/include/generated/uapi/asm/swab.h
  WRAP    arch/arm64/include/generated/uapi/asm/termbits.h
  WRAP    arch/arm64/include/generated/uapi/asm/termios.h
  WRAP    arch/arm64/include/generated/uapi/asm/types.h
  UPD     include/generated/uapi/linux/version.h
  HDRINST usr/include/asm-generic/unistd.h
  HDRINST usr/include/asm-generic/ucontext.h
  HDRINST usr/include/asm-generic/types.h
  HDRINST usr/include/asm-generic/termios.h
  HDRINST usr/include/asm-generic/termbits.h
  HDRINST usr/include/asm-generic/termbits-common.h
  HDRINST usr/include/asm-generic/swab.h
  HDRINST usr/include/asm-generic/statfs.h
  HDRINST usr/include/asm-generic/stat.h
  HDRINST usr/include/asm-generic/sockios.h
  HDRINST usr/include/asm-generic/socket.h
  HDRINST usr/include/asm-generic/signal.h
  HDRINST usr/include/asm-generic/signal-defs.h
  HDRINST usr/include/asm-generic/siginfo.h
  HDRINST usr/include/asm-generic/shmbuf.h
  HDRINST usr/include/asm-generic/setup.h
  HDRINST usr/include/asm-generic/sembuf.h
  HDRINST usr/include/asm-generic/resource.h
  HDRINST usr/include/asm-generic/posix_types.h
  HDRINST usr/include/asm-generic/poll.h
  HDRINST usr/include/asm-generic/param.h
  HDRINST usr/include/asm-generic/msgbuf.h
  HDRINST usr/include/asm-generic/mman.h
  HDRINST usr/include/asm-generic/mman-common.h
  HDRINST usr/include/asm-generic/kvm_para.h
  HDRINST usr/include/asm-generic/ipcbuf.h
  HDRINST usr/include/asm-generic/ioctls.h
  HDRINST usr/include/asm-generic/ioctl.h
  HDRINST usr/include/asm-generic/int-ll64.h
  HDRINST usr/include/asm-generic/int-l64.h
  HDRINST usr/include/asm-generic/hugetlb_encode.h
  HDRINST usr/include/asm-generic/fcntl.h
  HDRINST usr/include/asm-generic/errno.h
  HDRINST usr/include/asm-generic/errno-base.h
  HDRINST usr/include/asm-generic/bpf_perf_event.h
  HDRINST usr/include/asm-generic/bitsperlong.h
  HDRINST usr/include/asm-generic/auxvec.h
  HDRINST usr/include/drm/vmwgfx_drm.h
  HDRINST usr/include/drm/virtgpu_drm.h
  HDRINST usr/include/drm/via_drm.h
  HDRINST usr/include/drm/vgem_drm.h
  HDRINST usr/include/drm/vc4_drm.h
  HDRINST usr/include/drm/v3d_drm.h
  HDRINST usr/include/drm/tegra_drm.h
  HDRINST usr/include/drm/sis_drm.h
  HDRINST usr/include/drm/savage_drm.h
  HDRINST usr/include/drm/radeon_drm.h
  HDRINST usr/include/drm/r128_drm.h
  HDRINST usr/include/drm/qxl_drm.h
  HDRINST usr/include/drm/panfrost_drm.h
  HDRINST usr/include/drm/omap_drm.h
  HDRINST usr/include/drm/nouveau_drm.h
  HDRINST usr/include/drm/msm_drm.h
  HDRINST usr/include/drm/mga_drm.h
  HDRINST usr/include/drm/lima_drm.h
  HDRINST usr/include/drm/i915_drm.h
  HDRINST usr/include/drm/i810_drm.h
  HDRINST usr/include/drm/exynos_drm.h
  HDRINST usr/include/drm/etnaviv_drm.h
  HDRINST usr/include/drm/drm_sarea.h
  HDRINST usr/include/drm/drm_mode.h
  HDRINST usr/include/drm/drm_fourcc.h
  HDRINST usr/include/drm/drm.h
  HDRINST usr/include/drm/armada_drm.h
  HDRINST usr/include/drm/amdgpu_drm.h
  HDRINST usr/include/linux/if_link.h
  HDRINST usr/include/linux/rtnetlink.h
  HDRINST usr/include/linux/icmpv6.h
  HDRINST usr/include/linux/fib_rules.h
  HDRINST usr/include/linux/if_tunnel.h
  HDRINST usr/include/linux/if_packet.h
  HDRINST usr/include/linux/jffs2.h
  HDRINST usr/include/linux/switch.h
  HDRINST usr/include/linux/zorro_ids.h
  HDRINST usr/include/linux/zorro.h
  HDRINST usr/include/linux/xilinx-v4l2-controls.h
  HDRINST usr/include/linux/xfrm.h
  HDRINST usr/include/linux/xdp_diag.h
  HDRINST usr/include/linux/xattr.h
  HDRINST usr/include/linux/x25.h
  HDRINST usr/include/linux/wwan.h
  HDRINST usr/include/linux/wmi.h
  HDRINST usr/include/linux/wireless.h
  HDRINST usr/include/linux/wireguard.h
  HDRINST usr/include/linux/watchdog.h
  HDRINST usr/include/linux/watch_queue.h
  HDRINST usr/include/linux/wait.h
  HDRINST usr/include/linux/vtpm_proxy.h
  HDRINST usr/include/linux/vt.h
  HDRINST usr/include/linux/vsockmon.h
  HDRINST usr/include/linux/vmcore.h
  HDRINST usr/include/linux/vm_sockets_diag.h
  HDRINST usr/include/linux/vm_sockets.h
  HDRINST usr/include/linux/virtio_vsock.h
  HDRINST usr/include/linux/virtio_types.h
  HDRINST usr/include/linux/virtio_snd.h
  HDRINST usr/include/linux/virtio_scsi.h
  HDRINST usr/include/linux/virtio_scmi.h
  HDRINST usr/include/linux/virtio_rng.h
  HDRINST usr/include/linux/virtio_ring.h
  HDRINST usr/include/linux/virtio_pmem.h
  HDRINST usr/include/linux/virtio_pcidev.h
  HDRINST usr/include/linux/virtio_pci.h
  HDRINST usr/include/linux/virtio_net.h
  HDRINST usr/include/linux/virtio_mmio.h
  HDRINST usr/include/linux/virtio_mem.h
  HDRINST usr/include/linux/virtio_iommu.h
  HDRINST usr/include/linux/virtio_input.h
  HDRINST usr/include/linux/virtio_ids.h
  HDRINST usr/include/linux/virtio_i2c.h
  HDRINST usr/include/linux/virtio_gpu.h
  HDRINST usr/include/linux/virtio_gpio.h
  HDRINST usr/include/linux/virtio_fs.h
  HDRINST usr/include/linux/virtio_crypto.h
  HDRINST usr/include/linux/virtio_console.h
  HDRINST usr/include/linux/virtio_config.h
  HDRINST usr/include/linux/virtio_bt.h
  HDRINST usr/include/linux/virtio_blk.h
  HDRINST usr/include/linux/virtio_balloon.h
  HDRINST usr/include/linux/virtio_9p.h
  HDRINST usr/include/linux/videodev2.h
  HDRINST usr/include/linux/vhost_types.h
  HDRINST usr/include/linux/vhost.h
  HDRINST usr/include/linux/vfio_zdev.h
  HDRINST usr/include/linux/vfio_ccw.h
  HDRINST usr/include/linux/vfio.h
  HDRINST usr/include/linux/veth.h
  HDRINST usr/include/linux/vduse.h
  HDRINST usr/include/linux/vdpa.h
  HDRINST usr/include/linux/vboxguest.h
  HDRINST usr/include/linux/vbox_vmmdev_types.h
  HDRINST usr/include/linux/vbox_err.h
  HDRINST usr/include/linux/v4l2-subdev.h
  HDRINST usr/include/linux/v4l2-mediabus.h
  HDRINST usr/include/linux/v4l2-dv-timings.h
  HDRINST usr/include/linux/v4l2-controls.h
  HDRINST usr/include/linux/v4l2-common.h
  HDRINST usr/include/linux/uvcvideo.h
  HDRINST usr/include/linux/uuid.h
  HDRINST usr/include/linux/utsname.h
  HDRINST usr/include/linux/utime.h
  HDRINST usr/include/linux/userio.h
  HDRINST usr/include/linux/userfaultfd.h
  HDRINST usr/include/linux/usbip.h
  HDRINST usr/include/linux/usbdevice_fs.h
  HDRINST usr/include/linux/usb/video.h
  HDRINST usr/include/linux/usb/tmc.h
  HDRINST usr/include/linux/usb/raw_gadget.h
  HDRINST usr/include/linux/usb/midi.h
  HDRINST usr/include/linux/usb/gadgetfs.h
  HDRINST usr/include/linux/usb/g_uvc.h
  HDRINST usr/include/linux/usb/g_printer.h
  HDRINST usr/include/linux/usb/functionfs.h
  HDRINST usr/include/linux/usb/charger.h
  HDRINST usr/include/linux/usb/ch9.h
  HDRINST usr/include/linux/usb/ch11.h
  HDRINST usr/include/linux/usb/cdc.h
  HDRINST usr/include/linux/usb/cdc-wdm.h
  HDRINST usr/include/linux/usb/audio.h
  HDRINST usr/include/linux/unix_diag.h
  HDRINST usr/include/linux/unistd.h
  HDRINST usr/include/linux/un.h
  HDRINST usr/include/linux/um_timetravel.h
  HDRINST usr/include/linux/ultrasound.h
  HDRINST usr/include/linux/uleds.h
  HDRINST usr/include/linux/uio.h
  HDRINST usr/include/linux/uinput.h
  HDRINST usr/include/linux/uhid.h
  HDRINST usr/include/linux/udp.h
  HDRINST usr/include/linux/udmabuf.h
  HDRINST usr/include/linux/udf_fs_i.h
  HDRINST usr/include/linux/ublk_cmd.h
  HDRINST usr/include/linux/types.h
  HDRINST usr/include/linux/tty_flags.h
  HDRINST usr/include/linux/tty.h
  HDRINST usr/include/linux/toshiba.h
  HDRINST usr/include/linux/tls.h
  HDRINST usr/include/linux/tipc_sockets_diag.h
  HDRINST usr/include/linux/tipc_netlink.h
  HDRINST usr/include/linux/tipc_config.h
  HDRINST usr/include/linux/tipc.h
  HDRINST usr/include/linux/tiocl.h
  HDRINST usr/include/linux/timex.h
  HDRINST usr/include/linux/times.h
  HDRINST usr/include/linux/timerfd.h
  HDRINST usr/include/linux/time_types.h
  HDRINST usr/include/linux/time.h
  HDRINST usr/include/linux/thermal.h
  HDRINST usr/include/linux/termios.h
  HDRINST usr/include/linux/tee.h
  HDRINST usr/include/linux/tcp_metrics.h
  HDRINST usr/include/linux/tcp.h
  HDRINST usr/include/linux/tc_ematch/tc_em_text.h
  HDRINST usr/include/linux/tc_ematch/tc_em_nbyte.h
  HDRINST usr/include/linux/tc_ematch/tc_em_meta.h
  HDRINST usr/include/linux/tc_ematch/tc_em_ipt.h
  HDRINST usr/include/linux/tc_ematch/tc_em_cmp.h
  HDRINST usr/include/linux/tc_act/tc_vlan.h
  HDRINST usr/include/linux/tc_act/tc_tunnel_key.h
  HDRINST usr/include/linux/tc_act/tc_skbmod.h
  HDRINST usr/include/linux/tc_act/tc_skbedit.h
  HDRINST usr/include/linux/tc_act/tc_sample.h
  HDRINST usr/include/linux/tc_act/tc_pedit.h
  HDRINST usr/include/linux/tc_act/tc_nat.h
  HDRINST usr/include/linux/tc_act/tc_mpls.h
  HDRINST usr/include/linux/tc_act/tc_mirred.h
  HDRINST usr/include/linux/tc_act/tc_ipt.h
  HDRINST usr/include/linux/tc_act/tc_ife.h
  HDRINST usr/include/linux/tc_act/tc_gate.h
  HDRINST usr/include/linux/tc_act/tc_gact.h
  HDRINST usr/include/linux/tc_act/tc_defact.h
  HDRINST usr/include/linux/tc_act/tc_ctinfo.h
  HDRINST usr/include/linux/tc_act/tc_ct.h
  HDRINST usr/include/linux/tc_act/tc_csum.h
  HDRINST usr/include/linux/tc_act/tc_connmark.h
  HDRINST usr/include/linux/tc_act/tc_bpf.h
  HDRINST usr/include/linux/taskstats.h
  HDRINST usr/include/linux/target_core_user.h
  HDRINST usr/include/linux/sysinfo.h
  HDRINST usr/include/linux/sysctl.h
  HDRINST usr/include/linux/synclink.h
  HDRINST usr/include/linux/sync_file.h
  HDRINST usr/include/linux/switchtec_ioctl.h
  HDRINST usr/include/linux/swab.h
  HDRINST usr/include/linux/suspend_ioctls.h
  HDRINST usr/include/linux/surface_aggregator/dtx.h
  HDRINST usr/include/linux/surface_aggregator/cdev.h
  HDRINST usr/include/linux/sunrpc/debug.h
  HDRINST usr/include/linux/string.h
  HDRINST usr/include/linux/stm.h
  HDRINST usr/include/linux/stddef.h
  HDRINST usr/include/linux/stat.h
  HDRINST usr/include/linux/spi/spidev.h
  HDRINST usr/include/linux/spi/spi.h
  HDRINST usr/include/linux/soundcard.h
  HDRINST usr/include/linux/sound.h
  HDRINST usr/include/linux/sonypi.h
  HDRINST usr/include/linux/sonet.h
  HDRINST usr/include/linux/sockios.h
  HDRINST usr/include/linux/socket.h
  HDRINST usr/include/linux/sock_diag.h
  HDRINST usr/include/linux/snmp.h
  HDRINST usr/include/linux/smiapp.h
  HDRINST usr/include/linux/smc_diag.h
  HDRINST usr/include/linux/smc.h
  HDRINST usr/include/linux/signalfd.h
  HDRINST usr/include/linux/signal.h
  HDRINST usr/include/linux/shm.h
  HDRINST usr/include/linux/sev-guest.h
  HDRINST usr/include/linux/serio.h
  HDRINST usr/include/linux/serial_reg.h
  HDRINST usr/include/linux/serial_core.h
  HDRINST usr/include/linux/serial.h
  HDRINST usr/include/linux/sem.h
  HDRINST usr/include/linux/selinux_netlink.h
  HDRINST usr/include/linux/seg6_local.h
  HDRINST usr/include/linux/seg6_iptunnel.h
  HDRINST usr/include/linux/seg6_hmac.h
  HDRINST usr/include/linux/seg6_genl.h
  HDRINST usr/include/linux/seg6.h
  HDRINST usr/include/linux/sed-opal.h
  HDRINST usr/include/linux/securebits.h
  HDRINST usr/include/linux/seccomp.h
  HDRINST usr/include/linux/sctp.h
  HDRINST usr/include/linux/screen_info.h
  HDRINST usr/include/linux/scif_ioctl.h
  HDRINST usr/include/linux/sched/types.h
  HDRINST usr/include/linux/sched.h
  HDRINST usr/include/linux/scc.h
  HDRINST usr/include/linux/rxrpc.h
  HDRINST usr/include/linux/rtc.h
  HDRINST usr/include/linux/rseq.h
  HDRINST usr/include/linux/rpmsg_types.h
  HDRINST usr/include/linux/rpmsg.h
  HDRINST usr/include/linux/rpl_iptunnel.h
  HDRINST usr/include/linux/rpl.h
  HDRINST usr/include/linux/route.h
  HDRINST usr/include/linux/rose.h
  HDRINST usr/include/linux/romfs_fs.h
  HDRINST usr/include/linux/rkisp1-config.h
  HDRINST usr/include/linux/rio_mport_cdev.h
  HDRINST usr/include/linux/rio_cm_cdev.h
  HDRINST usr/include/linux/rfkill.h
  HDRINST usr/include/linux/resource.h
  HDRINST usr/include/linux/remoteproc_cdev.h
  HDRINST usr/include/linux/reiserfs_xattr.h
  HDRINST usr/include/linux/reiserfs_fs.h
  HDRINST usr/include/linux/reboot.h
  HDRINST usr/include/linux/rds.h
  HDRINST usr/include/linux/random.h
  HDRINST usr/include/linux/raid/md_u.h
  HDRINST usr/include/linux/raid/md_p.h
  HDRINST usr/include/linux/radeonfb.h
  HDRINST usr/include/linux/quota.h
  HDRINST usr/include/linux/qrtr.h
  HDRINST usr/include/linux/qnxtypes.h
  HDRINST usr/include/linux/qnx4_fs.h
  HDRINST usr/include/linux/qemu_fw_cfg.h
  HDRINST usr/include/linux/ptrace.h
  HDRINST usr/include/linux/ptp_clock.h
  HDRINST usr/include/linux/psp-sev.h
  HDRINST usr/include/linux/psci.h
  HDRINST usr/include/linux/psample.h
  HDRINST usr/include/linux/prctl.h
  HDRINST usr/include/linux/pr.h
  HDRINST usr/include/linux/pps.h
  HDRINST usr/include/linux/ppp_defs.h
  HDRINST usr/include/linux/ppp-ioctl.h
  HDRINST usr/include/linux/ppp-comp.h
  HDRINST usr/include/linux/ppdev.h
  HDRINST usr/include/linux/posix_types.h
  HDRINST usr/include/linux/posix_acl_xattr.h
  HDRINST usr/include/linux/posix_acl.h
  HDRINST usr/include/linux/poll.h
  HDRINST usr/include/linux/pmu.h
  HDRINST usr/include/linux/pktcdvd.h
  HDRINST usr/include/linux/pkt_sched.h
  HDRINST usr/include/linux/pkt_cls.h
  HDRINST usr/include/linux/pidfd.h
  HDRINST usr/include/linux/phonet.h
  HDRINST usr/include/linux/phantom.h
  HDRINST usr/include/linux/pg.h
  HDRINST usr/include/linux/pfrut.h
  HDRINST usr/include/linux/pfkeyv2.h
  HDRINST usr/include/linux/personality.h
  HDRINST usr/include/linux/perf_event.h
  HDRINST usr/include/linux/pcitest.h
  HDRINST usr/include/linux/pci_regs.h
  HDRINST usr/include/linux/pci.h
  HDRINST usr/include/linux/patchkey.h
  HDRINST usr/include/linux/parport.h
  HDRINST usr/include/linux/param.h
  HDRINST usr/include/linux/packet_diag.h
  HDRINST usr/include/linux/openvswitch.h
  HDRINST usr/include/linux/openat2.h
  HDRINST usr/include/linux/oom.h
  HDRINST usr/include/linux/omapfb.h
  HDRINST usr/include/linux/omap3isp.h
  HDRINST usr/include/linux/nvram.h
  HDRINST usr/include/linux/nvme_ioctl.h
  HDRINST usr/include/linux/nubus.h
  HDRINST usr/include/linux/nsfs.h
  HDRINST usr/include/linux/nl80211.h
  HDRINST usr/include/linux/nl80211-vnd-intel.h
  HDRINST usr/include/linux/nitro_enclaves.h
  HDRINST usr/include/linux/nilfs2_ondisk.h
  HDRINST usr/include/linux/nilfs2_api.h
  HDRINST usr/include/linux/nfsd/stats.h
  HDRINST usr/include/linux/nfsd/export.h
  HDRINST usr/include/linux/nfsd/debug.h
  HDRINST usr/include/linux/nfsd/cld.h
  HDRINST usr/include/linux/nfsacl.h
  HDRINST usr/include/linux/nfs_mount.h
  HDRINST usr/include/linux/nfs_idmap.h
  HDRINST usr/include/linux/nfs_fs.h
  HDRINST usr/include/linux/nfs4_mount.h
  HDRINST usr/include/linux/nfs4.h
  HDRINST usr/include/linux/nfs3.h
  HDRINST usr/include/linux/nfs2.h
  HDRINST usr/include/linux/nfs.h
  HDRINST usr/include/linux/nfc.h
  HDRINST usr/include/linux/nexthop.h
  HDRINST usr/include/linux/netrom.h
  HDRINST usr/include/linux/netlink_diag.h
  HDRINST usr/include/linux/netlink.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_srh.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_rt.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_opts.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_mh.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_ipv6header.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_hl.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_frag.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_ah.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_REJECT.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_NPT.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_LOG.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6t_HL.h
  HDRINST usr/include/linux/netfilter_ipv6/ip6_tables.h
  HDRINST usr/include/linux/netfilter_ipv6.h
  HDRINST usr/include/linux/netfilter_ipv4/ip_tables.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ttl.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ecn.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ah.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_TTL.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_REJECT.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_LOG.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_ECN.h
  HDRINST usr/include/linux/netfilter_ipv4/ipt_CLUSTERIP.h
  HDRINST usr/include/linux/netfilter_ipv4.h
  HDRINST usr/include/linux/netfilter_bridge/ebtables.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_vlan.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_stp.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_redirect.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_pkttype.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_nflog.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_nat.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_mark_t.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_mark_m.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_log.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_limit.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_ip6.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_ip.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_arpreply.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_arp.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_among.h
  HDRINST usr/include/linux/netfilter_bridge/ebt_802_3.h
  HDRINST usr/include/linux/netfilter_bridge.h
  HDRINST usr/include/linux/netfilter_arp/arpt_mangle.h
  HDRINST usr/include/linux/netfilter_arp/arp_tables.h
  HDRINST usr/include/linux/netfilter_arp.h
  HDRINST usr/include/linux/netfilter/xt_FLOWOFFLOAD.h
  HDRINST usr/include/linux/netfilter/xt_connmark.h
  HDRINST usr/include/linux/netfilter/xt_u32.h
  HDRINST usr/include/linux/netfilter/xt_time.h
  HDRINST usr/include/linux/netfilter/xt_tcpudp.h
  HDRINST usr/include/linux/netfilter/xt_tcpmss.h
  HDRINST usr/include/linux/netfilter/xt_string.h
  HDRINST usr/include/linux/netfilter/xt_statistic.h
  HDRINST usr/include/linux/netfilter/xt_state.h
  HDRINST usr/include/linux/netfilter/xt_socket.h
  HDRINST usr/include/linux/netfilter/xt_set.h
  HDRINST usr/include/linux/netfilter/xt_sctp.h
  HDRINST usr/include/linux/netfilter/xt_rpfilter.h
  HDRINST usr/include/linux/netfilter/xt_recent.h
  HDRINST usr/include/linux/netfilter/xt_realm.h
  HDRINST usr/include/linux/netfilter/xt_rateest.h
  HDRINST usr/include/linux/netfilter/xt_quota.h
  HDRINST usr/include/linux/netfilter/xt_policy.h
  HDRINST usr/include/linux/netfilter/xt_pkttype.h
  HDRINST usr/include/linux/netfilter/xt_physdev.h
  HDRINST usr/include/linux/netfilter/xt_owner.h
  HDRINST usr/include/linux/netfilter/xt_osf.h
  HDRINST usr/include/linux/netfilter/xt_nfacct.h
  HDRINST usr/include/linux/netfilter/xt_multiport.h
  HDRINST usr/include/linux/netfilter/xt_mark.h
  HDRINST usr/include/linux/netfilter/xt_mac.h
  HDRINST usr/include/linux/netfilter/xt_limit.h
  HDRINST usr/include/linux/netfilter/xt_length.h
  HDRINST usr/include/linux/netfilter/xt_l2tp.h
  HDRINST usr/include/linux/netfilter/xt_ipvs.h
  HDRINST usr/include/linux/netfilter/xt_iprange.h
  HDRINST usr/include/linux/netfilter/xt_ipcomp.h
  HDRINST usr/include/linux/netfilter/xt_helper.h
  HDRINST usr/include/linux/netfilter/xt_hashlimit.h
  HDRINST usr/include/linux/netfilter/xt_esp.h
  HDRINST usr/include/linux/netfilter/xt_ecn.h
  HDRINST usr/include/linux/netfilter/xt_dscp.h
  HDRINST usr/include/linux/netfilter/xt_devgroup.h
  HDRINST usr/include/linux/netfilter/xt_dccp.h
  HDRINST usr/include/linux/netfilter/xt_cpu.h
  HDRINST usr/include/linux/netfilter/xt_conntrack.h
  HDRINST usr/include/linux/netfilter/xt_connlimit.h
  HDRINST usr/include/linux/netfilter/xt_connlabel.h
  HDRINST usr/include/linux/netfilter/xt_connbytes.h
  HDRINST usr/include/linux/netfilter/xt_comment.h
  HDRINST usr/include/linux/netfilter/xt_cluster.h
  HDRINST usr/include/linux/netfilter/xt_cgroup.h
  HDRINST usr/include/linux/netfilter/xt_bpf.h
  HDRINST usr/include/linux/netfilter/xt_addrtype.h
  HDRINST usr/include/linux/netfilter/xt_TPROXY.h
  HDRINST usr/include/linux/netfilter/xt_TEE.h
  HDRINST usr/include/linux/netfilter/xt_TCPOPTSTRIP.h
  HDRINST usr/include/linux/netfilter/xt_TCPMSS.h
  HDRINST usr/include/linux/netfilter/xt_SYNPROXY.h
  HDRINST usr/include/linux/netfilter/xt_SECMARK.h
  HDRINST usr/include/linux/netfilter/xt_RATEEST.h
  HDRINST usr/include/linux/netfilter/xt_NFQUEUE.h
  HDRINST usr/include/linux/netfilter/xt_NFLOG.h
  HDRINST usr/include/linux/netfilter/xt_MARK.h
  HDRINST usr/include/linux/netfilter/xt_LOG.h
  HDRINST usr/include/linux/netfilter/xt_LED.h
  HDRINST usr/include/linux/netfilter/xt_IDLETIMER.h
  HDRINST usr/include/linux/netfilter/xt_HMARK.h
  HDRINST usr/include/linux/netfilter/xt_DSCP.h
  HDRINST usr/include/linux/netfilter/xt_CT.h
  HDRINST usr/include/linux/netfilter/xt_CONNSECMARK.h
  HDRINST usr/include/linux/netfilter/xt_CONNMARK.h
  HDRINST usr/include/linux/netfilter/xt_CLASSIFY.h
  HDRINST usr/include/linux/netfilter/xt_CHECKSUM.h
  HDRINST usr/include/linux/netfilter/xt_AUDIT.h
  HDRINST usr/include/linux/netfilter/x_tables.h
  HDRINST usr/include/linux/netfilter/nfnetlink_queue.h
  HDRINST usr/include/linux/netfilter/nfnetlink_osf.h
  HDRINST usr/include/linux/netfilter/nfnetlink_log.h
  HDRINST usr/include/linux/netfilter/nfnetlink_hook.h
  HDRINST usr/include/linux/netfilter/nfnetlink_cttimeout.h
  HDRINST usr/include/linux/netfilter/nfnetlink_cthelper.h
  HDRINST usr/include/linux/netfilter/nfnetlink_conntrack.h
  HDRINST usr/include/linux/netfilter/nfnetlink_compat.h
  HDRINST usr/include/linux/netfilter/nfnetlink_acct.h
  HDRINST usr/include/linux/netfilter/nfnetlink.h
  HDRINST usr/include/linux/netfilter/nf_tables_compat.h
  HDRINST usr/include/linux/netfilter/nf_tables.h
  HDRINST usr/include/linux/netfilter/nf_synproxy.h
  HDRINST usr/include/linux/netfilter/nf_nat.h
  HDRINST usr/include/linux/netfilter/nf_log.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_tuple_common.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_tcp.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_sctp.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_ftp.h
  HDRINST usr/include/linux/netfilter/nf_conntrack_common.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set_list.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set_hash.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set_bitmap.h
  HDRINST usr/include/linux/netfilter/ipset/ip_set.h
  HDRINST usr/include/linux/netfilter.h
  HDRINST usr/include/linux/netdevice.h
  HDRINST usr/include/linux/netconf.h
  HDRINST usr/include/linux/net_tstamp.h
  HDRINST usr/include/linux/net_namespace.h
  HDRINST usr/include/linux/net_dropmon.h
  HDRINST usr/include/linux/net.h
  HDRINST usr/include/linux/neighbour.h
  HDRINST usr/include/linux/ndctl.h
  HDRINST usr/include/linux/ncsi.h
  HDRINST usr/include/linux/nbd.h
  HDRINST usr/include/linux/nbd-netlink.h
  HDRINST usr/include/linux/mtio.h
  HDRINST usr/include/linux/msg.h
  HDRINST usr/include/linux/msdos_fs.h
  HDRINST usr/include/linux/mrp_bridge.h
  HDRINST usr/include/linux/mroute6.h
  HDRINST usr/include/linux/mroute.h
  HDRINST usr/include/linux/mqueue.h
  HDRINST usr/include/linux/mptcp.h
  HDRINST usr/include/linux/mpls_iptunnel.h
  HDRINST usr/include/linux/mpls.h
  HDRINST usr/include/linux/mount.h
  HDRINST usr/include/linux/module.h
  HDRINST usr/include/linux/mmtimer.h
  HDRINST usr/include/linux/mmc/ioctl.h
  HDRINST usr/include/linux/mman.h
  HDRINST usr/include/linux/misc/bcm_vk.h
  HDRINST usr/include/linux/minix_fs.h
  HDRINST usr/include/linux/mii.h
  HDRINST usr/include/linux/meye.h
  HDRINST usr/include/linux/mempolicy.h
  HDRINST usr/include/linux/memfd.h
  HDRINST usr/include/linux/membarrier.h
  HDRINST usr/include/linux/mei.h
  HDRINST usr/include/linux/media.h
  HDRINST usr/include/linux/media-bus-format.h
  HDRINST usr/include/linux/mdio.h
  HDRINST usr/include/linux/mctp.h
  HDRINST usr/include/linux/max2175.h
  HDRINST usr/include/linux/matroxfb.h
  HDRINST usr/include/linux/map_to_7segment.h
  HDRINST usr/include/linux/map_to_14segment.h
  HDRINST usr/include/linux/major.h
  HDRINST usr/include/linux/magic.h
  HDRINST usr/include/linux/lwtunnel.h
  HDRINST usr/include/linux/lp.h
  HDRINST usr/include/linux/loop.h
  HDRINST usr/include/linux/loadpin.h
  HDRINST usr/include/linux/llc.h
  HDRINST usr/include/linux/lirc.h
  HDRINST usr/include/linux/limits.h
  HDRINST usr/include/linux/libc-compat.h
  HDRINST usr/include/linux/landlock.h
  HDRINST usr/include/linux/l2tp.h
  HDRINST usr/include/linux/kvm_para.h
  HDRINST usr/include/linux/kvm.h
  HDRINST usr/include/linux/kfd_sysfs.h
  HDRINST usr/include/linux/kfd_ioctl.h
  HDRINST usr/include/linux/keyctl.h
  HDRINST usr/include/linux/keyboard.h
  HDRINST usr/include/linux/kexec.h
  HDRINST usr/include/linux/kernelcapi.h
  HDRINST usr/include/linux/kernel.h
  HDRINST usr/include/linux/kernel-page-flags.h
  HDRINST usr/include/linux/kdev_t.h
  HDRINST usr/include/linux/kd.h
  HDRINST usr/include/linux/kcov.h
  HDRINST usr/include/linux/kcmp.h
  HDRINST usr/include/linux/kcm.h
  HDRINST usr/include/linux/joystick.h
  HDRINST usr/include/linux/ivtvfb.h
  HDRINST usr/include/linux/ivtv.h
  HDRINST usr/include/linux/isst_if.h
  HDRINST usr/include/linux/iso_fs.h
  HDRINST usr/include/linux/isdn/capicmd.h
  HDRINST usr/include/linux/irqnr.h
  HDRINST usr/include/linux/ipv6_route.h
  HDRINST usr/include/linux/ipv6.h
  HDRINST usr/include/linux/ipsec.h
  HDRINST usr/include/linux/ipmi_msgdefs.h
  HDRINST usr/include/linux/ipmi_bmc.h
  HDRINST usr/include/linux/ipmi.h
  HDRINST usr/include/linux/ipc.h
  HDRINST usr/include/linux/ip_vs.h
  HDRINST usr/include/linux/ip6_tunnel.h
  HDRINST usr/include/linux/ip.h
  HDRINST usr/include/linux/ioprio.h
  HDRINST usr/include/linux/iommu.h
  HDRINST usr/include/linux/ioctl.h
  HDRINST usr/include/linux/ioam6_iptunnel.h
  HDRINST usr/include/linux/ioam6_genl.h
  HDRINST usr/include/linux/ioam6.h
  HDRINST usr/include/linux/io_uring.h
  HDRINST usr/include/linux/input.h
  HDRINST usr/include/linux/input-event-codes.h
  HDRINST usr/include/linux/inotify.h
  HDRINST usr/include/linux/inet_diag.h
  HDRINST usr/include/linux/in_route.h
  HDRINST usr/include/linux/in6.h
  HDRINST usr/include/linux/in.h
  HDRINST usr/include/linux/ila.h
  HDRINST usr/include/linux/iio/types.h
  HDRINST usr/include/linux/iio/events.h
  HDRINST usr/include/linux/iio/buffer.h
  HDRINST usr/include/linux/igmp.h
  HDRINST usr/include/linux/ife.h
  HDRINST usr/include/linux/if_xdp.h
  HDRINST usr/include/linux/if_x25.h
  HDRINST usr/include/linux/if_vlan.h
  HDRINST usr/include/linux/if_tun.h
  HDRINST usr/include/linux/if_team.h
  HDRINST usr/include/linux/if_slip.h
  HDRINST usr/include/linux/if_pppox.h
  HDRINST usr/include/linux/if_pppol2tp.h
  HDRINST usr/include/linux/if_ppp.h
  HDRINST usr/include/linux/if_plip.h
  HDRINST usr/include/linux/if_phonet.h
  HDRINST usr/include/linux/if_macsec.h
  HDRINST usr/include/linux/if_ltalk.h
  HDRINST usr/include/linux/if_infiniband.h
  HDRINST usr/include/linux/if_hippi.h
  HDRINST usr/include/linux/if_fddi.h
  HDRINST usr/include/linux/if_fc.h
  HDRINST usr/include/linux/if_ether.h
  HDRINST usr/include/linux/if_eql.h
  HDRINST usr/include/linux/if_cablemodem.h
  HDRINST usr/include/linux/if_bridge.h
  HDRINST usr/include/linux/if_bonding.h
  HDRINST usr/include/linux/if_arp.h
  HDRINST usr/include/linux/if_arcnet.h
  HDRINST usr/include/linux/if_alg.h
  HDRINST usr/include/linux/if_addrlabel.h
  HDRINST usr/include/linux/if_addr.h
  HDRINST usr/include/linux/if.h
  HDRINST usr/include/linux/idxd.h
  HDRINST usr/include/linux/icmp.h
  HDRINST usr/include/linux/i8k.h
  HDRINST usr/include/linux/i2o-dev.h
  HDRINST usr/include/linux/i2c.h
  HDRINST usr/include/linux/i2c-dev.h
  HDRINST usr/include/linux/hyperv.h
  HDRINST usr/include/linux/hw_breakpoint.h
  HDRINST usr/include/linux/hsr_netlink.h
  HDRINST usr/include/linux/hsi/hsi_char.h
  HDRINST usr/include/linux/hsi/cs-protocol.h
  HDRINST usr/include/linux/hpet.h
  HDRINST usr/include/linux/hidraw.h
  HDRINST usr/include/linux/hiddev.h
  HDRINST usr/include/linux/hid.h
  HDRINST usr/include/linux/hdreg.h
  HDRINST usr/include/linux/hdlcdrv.h
  HDRINST usr/include/linux/hdlc/ioctl.h
  HDRINST usr/include/linux/hdlc.h
  HDRINST usr/include/linux/hash_info.h
  HDRINST usr/include/linux/gtp.h
  HDRINST usr/include/linux/gsmmux.h
  HDRINST usr/include/linux/gpio.h
  HDRINST usr/include/linux/gfs2_ondisk.h
  HDRINST usr/include/linux/genwqe/genwqe_card.h
  HDRINST usr/include/linux/genetlink.h
  HDRINST usr/include/linux/gen_stats.h
  HDRINST usr/include/linux/gameport.h
  HDRINST usr/include/linux/futex.h
  HDRINST usr/include/linux/fuse.h
  HDRINST usr/include/linux/fsverity.h
  HDRINST usr/include/linux/fsmap.h
  HDRINST usr/include/linux/fsl_mc.h
  HDRINST usr/include/linux/fsl_hypervisor.h
  HDRINST usr/include/linux/fsi.h
  HDRINST usr/include/linux/fscrypt.h
  HDRINST usr/include/linux/fs.h
  HDRINST usr/include/linux/fpga-dfl.h
  HDRINST usr/include/linux/fou.h
  HDRINST usr/include/linux/firewire-constants.h
  HDRINST usr/include/linux/firewire-cdev.h
  HDRINST usr/include/linux/filter.h
  HDRINST usr/include/linux/fiemap.h
  HDRINST usr/include/linux/fdreg.h
  HDRINST usr/include/linux/fd.h
  HDRINST usr/include/linux/fcntl.h
  HDRINST usr/include/linux/fb.h
  HDRINST usr/include/linux/fanotify.h
  HDRINST usr/include/linux/falloc.h
  HDRINST usr/include/linux/fadvise.h
  HDRINST usr/include/linux/f2fs.h
  HDRINST usr/include/linux/eventpoll.h
  HDRINST usr/include/linux/ethtool_netlink.h
  HDRINST usr/include/linux/ethtool.h
  HDRINST usr/include/linux/erspan.h
  HDRINST usr/include/linux/errqueue.h
  HDRINST usr/include/linux/errno.h
  HDRINST usr/include/linux/elf.h
  HDRINST usr/include/linux/elf-fdpic.h
  HDRINST usr/include/linux/elf-em.h
  HDRINST usr/include/linux/efs_fs_sb.h
  HDRINST usr/include/linux/edd.h
  HDRINST usr/include/linux/dw100.h
  HDRINST usr/include/linux/dvb/video.h
  HDRINST usr/include/linux/dvb/version.h
  HDRINST usr/include/linux/dvb/osd.h
  HDRINST usr/include/linux/dvb/net.h
  HDRINST usr/include/linux/dvb/frontend.h
  HDRINST usr/include/linux/dvb/dmx.h
  HDRINST usr/include/linux/dvb/ca.h
  HDRINST usr/include/linux/dvb/audio.h
  HDRINST usr/include/linux/dqblk_xfs.h
  HDRINST usr/include/linux/dns_resolver.h
  HDRINST usr/include/linux/dma-heap.h
  HDRINST usr/include/linux/dma-buf.h
  HDRINST usr/include/linux/dm-log-userspace.h
  HDRINST usr/include/linux/dm-ioctl.h
  HDRINST usr/include/linux/dlmconstants.h
  HDRINST usr/include/linux/dlm_plock.h
  HDRINST usr/include/linux/dlm_netlink.h
  HDRINST usr/include/linux/dlm_device.h
  HDRINST usr/include/linux/dlm.h
  HDRINST usr/include/linux/devlink.h
  HDRINST usr/include/linux/dccp.h
  HDRINST usr/include/linux/dcbnl.h
  HDRINST usr/include/linux/cycx_cfm.h
  HDRINST usr/include/linux/cyclades.h
  HDRINST usr/include/linux/cxl_mem.h
  HDRINST usr/include/linux/cuda.h
  HDRINST usr/include/linux/cryptouser.h
  HDRINST usr/include/linux/cramfs_fs.h
  HDRINST usr/include/linux/counter.h
  HDRINST usr/include/linux/coresight-stm.h
  HDRINST usr/include/linux/const.h
  HDRINST usr/include/linux/connector.h
  HDRINST usr/include/linux/comedi.h
  HDRINST usr/include/linux/coff.h
  HDRINST usr/include/linux/coda.h
  HDRINST usr/include/linux/cn_proc.h
  HDRINST usr/include/linux/cm4000_cs.h
  HDRINST usr/include/linux/close_range.h
  HDRINST usr/include/linux/cifs/cifs_netlink.h
  HDRINST usr/include/linux/cifs/cifs_mount.h
  HDRINST usr/include/linux/chio.h
  HDRINST usr/include/linux/cgroupstats.h
  HDRINST usr/include/linux/cfm_bridge.h
  HDRINST usr/include/linux/cec.h
  HDRINST usr/include/linux/cec-funcs.h
  HDRINST usr/include/linux/cdrom.h
  HDRINST usr/include/linux/ccs.h
  HDRINST usr/include/linux/cciss_ioctl.h
  HDRINST usr/include/linux/cciss_defs.h
  HDRINST usr/include/linux/capi.h
  HDRINST usr/include/linux/capability.h
  HDRINST usr/include/linux/can/vxcan.h
  HDRINST usr/include/linux/can/raw.h
  HDRINST usr/include/linux/can/netlink.h
  HDRINST usr/include/linux/can/j1939.h
  HDRINST usr/include/linux/can/isotp.h
  HDRINST usr/include/linux/can/gw.h
  HDRINST usr/include/linux/can/error.h
  HDRINST usr/include/linux/can/bcm.h
  HDRINST usr/include/linux/can.h
  HDRINST usr/include/linux/caif/if_caif.h
  HDRINST usr/include/linux/caif/caif_socket.h
  HDRINST usr/include/linux/cachefiles.h
  HDRINST usr/include/linux/byteorder/little_endian.h
  HDRINST usr/include/linux/byteorder/big_endian.h
  HDRINST usr/include/linux/btrfs_tree.h
  HDRINST usr/include/linux/btrfs.h
  HDRINST usr/include/linux/btf.h
  HDRINST usr/include/linux/bt-bmc.h
  HDRINST usr/include/linux/bsg.h
  HDRINST usr/include/linux/bpqether.h
  HDRINST usr/include/linux/bpfilter.h
  HDRINST usr/include/linux/bpf_perf_event.h
  HDRINST usr/include/linux/bpf_common.h
  HDRINST usr/include/linux/bpf.h
  HDRINST usr/include/linux/blkzoned.h
  HDRINST usr/include/linux/blktrace_api.h
  HDRINST usr/include/linux/blkpg.h
  HDRINST usr/include/linux/binfmts.h
  HDRINST usr/include/linux/bfs_fs.h
  HDRINST usr/include/linux/bcm933xx_hcs.h
  HDRINST usr/include/linux/baycom.h
  HDRINST usr/include/linux/batman_adv.h
  HDRINST usr/include/linux/batadv_packet.h
  HDRINST usr/include/linux/ax25.h
  HDRINST usr/include/linux/auxvec.h
  HDRINST usr/include/linux/auto_fs4.h
  HDRINST usr/include/linux/auto_fs.h
  HDRINST usr/include/linux/auto_dev-ioctl.h
  HDRINST usr/include/linux/audit.h
  HDRINST usr/include/linux/atmsvc.h
  HDRINST usr/include/linux/atmsap.h
  HDRINST usr/include/linux/atmppp.h
  HDRINST usr/include/linux/atmmpc.h
  HDRINST usr/include/linux/atmlec.h
  HDRINST usr/include/linux/atmioc.h
  HDRINST usr/include/linux/atmdev.h
  HDRINST usr/include/linux/atmclip.h
  HDRINST usr/include/linux/atmbr2684.h
  HDRINST usr/include/linux/atmarp.h
  HDRINST usr/include/linux/atmapi.h
  HDRINST usr/include/linux/atm_zatm.h
  HDRINST usr/include/linux/atm_tcp.h
  HDRINST usr/include/linux/atm_nicstar.h
  HDRINST usr/include/linux/atm_idt77105.h
  HDRINST usr/include/linux/atm_he.h
  HDRINST usr/include/linux/atm_eni.h
  HDRINST usr/include/linux/atm.h
  HDRINST usr/include/linux/atalk.h
  HDRINST usr/include/linux/aspeed-p2a-ctrl.h
  HDRINST usr/include/linux/aspeed-lpc-ctrl.h
  HDRINST usr/include/linux/arm_sdei.h
  HDRINST usr/include/linux/arcfb.h
  HDRINST usr/include/linux/apm_bios.h
  HDRINST usr/include/linux/android/binderfs.h
  HDRINST usr/include/linux/android/binder.h
  HDRINST usr/include/linux/amt.h
  HDRINST usr/include/linux/am437x-vpfe.h
  HDRINST usr/include/linux/aio_abi.h
  HDRINST usr/include/linux/agpgart.h
  HDRINST usr/include/linux/affs_hardblocks.h
  HDRINST usr/include/linux/adfs_fs.h
  HDRINST usr/include/linux/adb.h
  HDRINST usr/include/linux/acrn.h
  HDRINST usr/include/linux/acct.h
  HDRINST usr/include/misc/xilinx_sdfec.h
  HDRINST usr/include/misc/uacce/uacce.h
  HDRINST usr/include/misc/uacce/hisi_qm.h
  HDRINST usr/include/misc/pvpanic.h
  HDRINST usr/include/misc/ocxl.h
  HDRINST usr/include/misc/habanalabs.h
  HDRINST usr/include/misc/fastrpc.h
  HDRINST usr/include/misc/cxl.h
  HDRINST usr/include/mtd/ubi-user.h
  HDRINST usr/include/mtd/nftl-user.h
  HDRINST usr/include/mtd/mtd-user.h
  HDRINST usr/include/mtd/mtd-abi.h
  HDRINST usr/include/mtd/inftl-user.h
  HDRINST usr/include/rdma/vmw_pvrdma-abi.h
  HDRINST usr/include/rdma/siw-abi.h
  HDRINST usr/include/rdma/rvt-abi.h
  HDRINST usr/include/rdma/rdma_user_rxe.h
  HDRINST usr/include/rdma/rdma_user_ioctl_cmds.h
  HDRINST usr/include/rdma/rdma_user_ioctl.h
  HDRINST usr/include/rdma/rdma_user_cm.h
  HDRINST usr/include/rdma/rdma_netlink.h
  HDRINST usr/include/rdma/qedr-abi.h
  HDRINST usr/include/rdma/ocrdma-abi.h
  HDRINST usr/include/rdma/mthca-abi.h
  HDRINST usr/include/rdma/mlx5_user_ioctl_verbs.h
  HDRINST usr/include/rdma/mlx5_user_ioctl_cmds.h
  HDRINST usr/include/rdma/mlx5-abi.h
  HDRINST usr/include/rdma/mlx4-abi.h
  HDRINST usr/include/rdma/irdma-abi.h
  HDRINST usr/include/rdma/ib_user_verbs.h
  HDRINST usr/include/rdma/ib_user_sa.h
  HDRINST usr/include/rdma/ib_user_mad.h
  HDRINST usr/include/rdma/ib_user_ioctl_verbs.h
  HDRINST usr/include/rdma/ib_user_ioctl_cmds.h
  HDRINST usr/include/rdma/hns-abi.h
  HDRINST usr/include/rdma/hfi/hfi1_user.h
  HDRINST usr/include/rdma/hfi/hfi1_ioctl.h
  HDRINST usr/include/rdma/erdma-abi.h
  HDRINST usr/include/rdma/efa-abi.h
  HDRINST usr/include/rdma/cxgb4-abi.h
  HDRINST usr/include/rdma/bnxt_re-abi.h
  HDRINST usr/include/scsi/scsi_netlink_fc.h
  HDRINST usr/include/scsi/scsi_netlink.h
  HDRINST usr/include/scsi/scsi_bsg_ufs.h
  HDRINST usr/include/scsi/scsi_bsg_mpi3mr.h
  HDRINST usr/include/scsi/scsi_bsg_fc.h
  HDRINST usr/include/scsi/fc/fc_ns.h
  HDRINST usr/include/scsi/fc/fc_gs.h
  HDRINST usr/include/scsi/fc/fc_fs.h
  HDRINST usr/include/scsi/fc/fc_els.h
  HDRINST usr/include/scsi/cxlflash_ioctl.h
  HDRINST usr/include/sound/usb_stream.h
  HDRINST usr/include/sound/tlv.h
  HDRINST usr/include/sound/sof/tokens.h
  HDRINST usr/include/sound/sof/header.h
  HDRINST usr/include/sound/sof/fw.h
  HDRINST usr/include/sound/sof/abi.h
  HDRINST usr/include/sound/snd_sst_tokens.h
  HDRINST usr/include/sound/snd_ar_tokens.h
  HDRINST usr/include/sound/skl-tplg-interface.h
  HDRINST usr/include/sound/sfnt_info.h
  HDRINST usr/include/sound/sb16_csp.h
  HDRINST usr/include/sound/intel/avs/tokens.h
  HDRINST usr/include/sound/hdspm.h
  HDRINST usr/include/sound/hdsp.h
  HDRINST usr/include/sound/firewire.h
  HDRINST usr/include/sound/emu10k1.h
  HDRINST usr/include/sound/compress_params.h
  HDRINST usr/include/sound/compress_offload.h
  HDRINST usr/include/sound/asound_fm.h
  HDRINST usr/include/sound/asound.h
  HDRINST usr/include/sound/asoc.h
  HDRINST usr/include/sound/asequencer.h
  HDRINST usr/include/video/uvesafb.h
  HDRINST usr/include/video/sisfb.h
  HDRINST usr/include/video/edid.h
  HDRINST usr/include/xen/privcmd.h
  HDRINST usr/include/xen/gntdev.h
  HDRINST usr/include/xen/gntalloc.h
  HDRINST usr/include/xen/evtchn.h
  HDRINST usr/include/linux/version.h
  HDRINST usr/include/asm/unistd.h
  HDRINST usr/include/asm/ucontext.h
  HDRINST usr/include/asm/sve_context.h
  HDRINST usr/include/asm/statfs.h
  HDRINST usr/include/asm/signal.h
  HDRINST usr/include/asm/sigcontext.h
  HDRINST usr/include/asm/setup.h
  HDRINST usr/include/asm/ptrace.h
  HDRINST usr/include/asm/posix_types.h
  HDRINST usr/include/asm/perf_regs.h
  HDRINST usr/include/asm/param.h
  HDRINST usr/include/asm/mman.h
  HDRINST usr/include/asm/kvm.h
  HDRINST usr/include/asm/hwcap.h
  HDRINST usr/include/asm/fcntl.h
  HDRINST usr/include/asm/byteorder.h
  HDRINST usr/include/asm/bpf_perf_event.h
  HDRINST usr/include/asm/bitsperlong.h
  HDRINST usr/include/asm/auxvec.h
  HDRINST usr/include/asm/types.h
  HDRINST usr/include/asm/termios.h
  HDRINST usr/include/asm/termbits.h
  HDRINST usr/include/asm/swab.h
  HDRINST usr/include/asm/stat.h
  HDRINST usr/include/asm/sockios.h
  HDRINST usr/include/asm/socket.h
  HDRINST usr/include/asm/siginfo.h
  HDRINST usr/include/asm/shmbuf.h
  HDRINST usr/include/asm/sembuf.h
  HDRINST usr/include/asm/resource.h
  HDRINST usr/include/asm/poll.h
  HDRINST usr/include/asm/msgbuf.h
  HDRINST usr/include/asm/ipcbuf.h
  HDRINST usr/include/asm/ioctls.h
  HDRINST usr/include/asm/ioctl.h
  HDRINST usr/include/asm/errno.h
  HDRINST usr/include/asm/kvm_para.h
  INSTALL /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/user_headers/include
make[4]: Leaving directory '/tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63'
grep '=[ym]' /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.config.set | LC_ALL=C sort | /tmpram/openwrt/staging_dir/host/bin/mkhash md5 > /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.vermagic
touch /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.configured
rm -f /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/vmlinux /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/System.map
make -C /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63 KCFLAGS="-fmacro-prefix-map=/tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl=target-aarch64_cortex-a53_musl -fno-caller-saves " HOSTCFLAGS="-O2 -I/tmpram/openwrt/staging_dir/host/include  -Wall -Wmissing-prototypes -Wstrict-prototypes" CROSS_COMPILE="aarch64-openwrt-linux-musl-" ARCH="arm64" KBUILD_HAVE_NLS=no KBUILD_BUILD_USER="" KBUILD_BUILD_HOST="" KBUILD_BUILD_TIMESTAMP="Sat Nov 25 11:20:09 2023" KBUILD_BUILD_VERSION="0" KBUILD_HOSTLDFLAGS="-L/tmpram/openwrt/staging_dir/host/lib" CONFIG_SHELL="bash" V=''  cmd_syscalls=  CC="aarch64-openwrt-linux-musl-gcc" KERNELRELEASE=6.1.63 Image dtbs modules
make[4]: Entering directory '/tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63'
  SYNC    include/config/auto.conf.cmd
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/confdata.o
  HOSTCC  scripts/kconfig/expr.o
  LEX     scripts/kconfig/lexer.lex.c
  YACC    scripts/kconfig/parser.tab.[ch]
  HOSTCC  scripts/kconfig/lexer.lex.o
  HOSTCC  scripts/kconfig/menu.o
  HOSTCC  scripts/kconfig/parser.tab.o
  HOSTCC  scripts/kconfig/preprocess.o
  HOSTCC  scripts/kconfig/symbol.o
  HOSTCC  scripts/kconfig/util.o
  HOSTLD  scripts/kconfig/conf
  HOSTCC  scripts/dtc/dtc.o
  HOSTCC  scripts/dtc/flattree.o
  HOSTCC  scripts/dtc/fstree.o
  HOSTCC  scripts/dtc/data.o
  HOSTCC  scripts/dtc/livetree.o
  HOSTCC  scripts/dtc/treesource.o
  HOSTCC  scripts/dtc/srcpos.o
  HOSTCC  scripts/dtc/checks.o
  HOSTCC  scripts/dtc/util.o
  LEX     scripts/dtc/dtc-lexer.lex.c
  YACC    scripts/dtc/dtc-parser.tab.[ch]
  HOSTCC  scripts/dtc/dtc-lexer.lex.o
  HOSTCC  scripts/dtc/dtc-parser.tab.o
  HOSTLD  scripts/dtc/dtc
  HOSTCC  scripts/dtc/libfdt/fdt.o
  HOSTCC  scripts/dtc/libfdt/fdt_ro.o
  HOSTCC  scripts/dtc/libfdt/fdt_wip.o
  HOSTCC  scripts/dtc/libfdt/fdt_sw.o
  HOSTCC  scripts/dtc/libfdt/fdt_rw.o
  HOSTCC  scripts/dtc/libfdt/fdt_strerror.o
  HOSTCC  scripts/dtc/libfdt/fdt_empty_tree.o
  HOSTCC  scripts/dtc/libfdt/fdt_addresses.o
  HOSTCC  scripts/dtc/libfdt/fdt_overlay.o
  HOSTCC  scripts/dtc/fdtoverlay.o
  HOSTLD  scripts/dtc/fdtoverlay
  HOSTCC  scripts/kallsyms
  HOSTCC  scripts/sorttable
  WRAP    arch/arm64/include/generated/asm/early_ioremap.h
  WRAP    arch/arm64/include/generated/asm/mcs_spinlock.h
  WRAP    arch/arm64/include/generated/asm/qrwlock.h
  WRAP    arch/arm64/include/generated/asm/qspinlock.h
  WRAP    arch/arm64/include/generated/asm/parport.h
  WRAP    arch/arm64/include/generated/asm/user.h
  WRAP    arch/arm64/include/generated/asm/bugs.h
  WRAP    arch/arm64/include/generated/asm/delay.h
  WRAP    arch/arm64/include/generated/asm/div64.h
  WRAP    arch/arm64/include/generated/asm/dma-mapping.h
  WRAP    arch/arm64/include/generated/asm/dma.h
  WRAP    arch/arm64/include/generated/asm/emergency-restart.h
  WRAP    arch/arm64/include/generated/asm/hw_irq.h
  WRAP    arch/arm64/include/generated/asm/irq_regs.h
  WRAP    arch/arm64/include/generated/asm/kdebug.h
  WRAP    arch/arm64/include/generated/asm/kmap_size.h
  WRAP    arch/arm64/include/generated/asm/local.h
  WRAP    arch/arm64/include/generated/asm/local64.h
  WRAP    arch/arm64/include/generated/asm/mmiowb.h
  WRAP    arch/arm64/include/generated/asm/msi.h
  WRAP    arch/arm64/include/generated/asm/serial.h
  WRAP    arch/arm64/include/generated/asm/softirq_stack.h
  WRAP    arch/arm64/include/generated/asm/switch_to.h
  WRAP    arch/arm64/include/generated/asm/trace_clock.h
  WRAP    arch/arm64/include/generated/asm/unaligned.h
  WRAP    arch/arm64/include/generated/asm/vga.h
  UPD     include/config/kernel.release
  UPD     include/generated/utsrelease.h
  UPD     include/generated/compile.h
  GEN     arch/arm64/include/generated/asm/cpucaps.h
  GEN     arch/arm64/include/generated/asm/sysreg-defs.h
  CC      scripts/mod/empty.o
  HOSTCC  scripts/mod/mk_elfconfig
  MKELF   scripts/mod/elfconfig.h
  HOSTCC  scripts/mod/modpost.o
  CC      scripts/mod/devicetable-offsets.s
  UPD     scripts/mod/devicetable-offsets.h
  HOSTCC  scripts/mod/file2alias.o
  HOSTCC  scripts/mod/sumversion.o
  HOSTLD  scripts/mod/modpost
  UPD     include/generated/timeconst.h
  CC      kernel/bounds.s
  UPD     include/generated/bounds.h
  CC      arch/arm64/kernel/asm-offsets.s
  UPD     include/generated/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CHKSHA1 include/linux/atomic/atomic-arch-fallback.h
  CHKSHA1 include/linux/atomic/atomic-instrumented.h
  CHKSHA1 include/linux/atomic/atomic-long.h
  LDS     arch/arm64/kernel/vdso/vdso.lds
  CC      arch/arm64/kernel/vdso/vgettimeofday.o
  AS      arch/arm64/kernel/vdso/note.o
  AS      arch/arm64/kernel/vdso/sigreturn.o
  LD      arch/arm64/kernel/vdso/vdso.so.dbg
  VDSOSYM include/generated/vdso-offsets.h
  OBJCOPY arch/arm64/kernel/vdso/vdso.so
  CC      init/main.o
  UPD     init/utsversion-tmp.h
  CC      init/version.o
  CC      init/do_mounts.o
  CC      init/do_mounts_initrd.o
  CC      init/initramfs.o
  CC      init/calibrate.o
  CC      init/init_task.o
  AR      init/built-in.a
  HOSTCC  usr/gen_init_cpio
  GEN     usr/initramfs_data.cpio
  COPY    usr/initramfs_inc_data
  AS      usr/initramfs_data.o
  AR      usr/built-in.a
  AR      arch/arm64/kernel/probes/built-in.a
  LDS     arch/arm64/kernel/vmlinux.lds
  CC      arch/arm64/kernel/debug-monitors.o
  AS      arch/arm64/kernel/entry.o
  CC      arch/arm64/kernel/irq.o
  CC      arch/arm64/kernel/fpsimd.o
  CC      arch/arm64/kernel/entry-common.o
  AS      arch/arm64/kernel/entry-fpsimd.o
  CC      arch/arm64/kernel/process.o
  CC      arch/arm64/kernel/ptrace.o
  CC      arch/arm64/kernel/setup.o
  CC      arch/arm64/kernel/signal.o
  CC      arch/arm64/kernel/sys.o
  CC      arch/arm64/kernel/stacktrace.o
  CC      arch/arm64/kernel/time.o
  CC      arch/arm64/kernel/traps.o
  CC      arch/arm64/kernel/io.o
make[7]: *** [scripts/Makefile.build:250: arch/arm64/kernel/io.o] Interrupt
make[6]: *** [scripts/Makefile.build:500: arch/arm64/kernel] Interrupt
make[5]: *** [scripts/Makefile.build:500: arch/arm64] Interrupt
make[4]: *** [Makefile:2014: .] Interrupt
make[3]: *** [Makefile:22: /tmpram/openwrt/build_dir/target-aarch64_cortex-a53_musl/linux-qualcommax_ipq60xx/linux-6.1.63/.modules] Interrupt
make[2]: *** [Makefile:11: compile] Interrupt
time: target/linux/compile#52.95#13.15#61.20
make: *** [/tmpram/openwrt/include/toplevel.mk:232: target/compile] Interrupt
```
