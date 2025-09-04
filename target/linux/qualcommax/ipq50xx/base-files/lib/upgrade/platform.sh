PART_NAME=firmware
REQUIRE_IMAGE_METADATA=1

RAMFS_COPY_BIN='dumpimage fw_printenv fw_setenv head seq'
RAMFS_COPY_DATA='/etc/fw_env.config /var/lock/fw_printenv.lock'

xiaomi_initramfs_prepare() {
	# Wipe UBI if running initramfs
	[ "$(rootfs_type)" = "tmpfs" ] || return 0

	local rootfs_mtdnum="$( find_mtd_index rootfs )"
	if [ ! "$rootfs_mtdnum" ]; then
		echo "unable to find mtd partition rootfs"
		return 1
	fi

	local kern_mtdnum="$( find_mtd_index ubi_kernel )"
	if [ ! "$kern_mtdnum" ]; then
		echo "unable to find mtd partition ubi_kernel"
		return 1
	fi

	ubidetach -m "$rootfs_mtdnum"
	ubiformat /dev/mtd$rootfs_mtdnum -y

	ubidetach -m "$kern_mtdnum"
	ubiformat /dev/mtd$kern_mtdnum -y
}

remove_oem_ubi_volume() {
	local oem_volume_name="$1"
	local oem_ubivol
	local mtdnum
	local ubidev

	mtdnum=$(find_mtd_index "$CI_UBIPART")
	if [ ! "$mtdnum" ]; then
		return
	fi

	ubidev=$(nand_find_ubi "$CI_UBIPART")
	if [ ! "$ubidev" ]; then
		ubiattach --mtdn="$mtdnum"
		ubidev=$(nand_find_ubi "$CI_UBIPART")
	fi

	if [ "$ubidev" ]; then
		oem_ubivol=$(nand_find_volume "$ubidev" "$oem_volume_name")
		[ "$oem_ubivol" ] && ubirmvol "/dev/$ubidev" --name="$oem_volume_name"
	fi
}

linksys_mx_pre_upgrade() {
	local setenv_script="/tmp/fw_env_upgrade"

	CI_UBIPART="rootfs"
	boot_part="$(fw_printenv -n boot_part)"
	if [ -n "$UPGRADE_OPT_USE_CURR_PART" ]; then
		if [ "$boot_part" -eq "2" ]; then
			CI_KERNPART="alt_kernel"
			CI_UBIPART="alt_rootfs"
		fi
	else
		if [ "$boot_part" -eq "1" ]; then
			echo "boot_part 2" >> $setenv_script
			CI_KERNPART="alt_kernel"
			CI_UBIPART="alt_rootfs"
		else
			echo "boot_part 1" >> $setenv_script
		fi
	fi

	boot_part_ready="$(fw_printenv -n boot_part_ready)"
	if [ "$boot_part_ready" -ne "3" ]; then
		echo "boot_part_ready 3" >> $setenv_script
	fi

	auto_recovery="$(fw_printenv -n auto_recovery)"
	if [ "$auto_recovery" != "yes" ]; then
		echo "auto_recovery yes" >> $setenv_script
	fi

	if [ -f "$setenv_script" ]; then
		fw_setenv -s $setenv_script || {
			echo "failed to update U-Boot environment"
			return 1
		}
	fi
}

sw8v3_env_setup() {
	local ubifile=$(board_name)
	local active=$1
	cat > /tmp/env_tmp << EOF
owrt_slotactive=$active
owrt_bootcount=0
bootfile=${ubifile}.ubi
owrt_bootcountcheck=if test \$owrt_bootcount > 4; then run owrt_tftprecover; fi; if test \$owrt_bootcount = 3; then run owrt_slotswap; else echo bootcountcheck successfull; fi
owrt_bootinc=if test \$owrt_bootcount < 5; then echo save env part; setexpr owrt_bootcount \${owrt_bootcount} + 1 && saveenv; else echo save env skipped; fi; echo current bootcount: \$owrt_bootcount
bootcmd=run owrt_bootinc && run owrt_bootcountcheck && run owrt_slotselect && run owrt_bootlinux
owrt_bootlinux=echo booting linux... && ubi part fs && ubi read 0x44000000 kernel && bootm; reset
owrt_setslot0=setenv bootargs console=ttyMSM0,115200n8 ubi.mtd=rootfs   root=mtd:rootfs rootfstype=squashfs rootwait swiotlb=1 && setenv mtdparts mtdparts=nand0:0x3e00000@0x0080000(fs)
owrt_setslot1=setenv bootargs console=ttyMSM0,115200n8 ubi.mtd=rootfs_1 root=mtd:rootfs rootfstype=squashfs rootwait swiotlb=1 && setenv mtdparts mtdparts=nand0:0x3e00000@0x3e80000(fs)
owrt_slotswap=setexpr owrt_slotactive 1 - \${owrt_slotactive} && saveenv && echo slot swapped. new active slot: \$owrt_slotactive
owrt_slotselect=setenv mtdids nand0=nand0; if test \$owrt_slotactive = 0; then run owrt_setslot0; else run owrt_setslot1; fi
owrt_tftprecover=echo trying to recover firmware with tftp... && sleep 10 && dhcp && flash rootfs && flash rootfs_1 && setenv owrt_bootcount 0 && setenv owrt_slotactive 0 && saveenv && reset
owrt_env_ver=6
bootargs=""
EOF
	fw_setenv --script /tmp/env_tmp
}



sw8v3_upgrade() {
	local ret val
	CI_ROOTPART="rootfs"

	#get active rootfs part offset	
	active_part_name=$(cat /proc/cmdline | grep -o 'ubi.mtd=[^ ]*' | tail -1 | cut -d'=' -f2)
	active_part_dev=$(cat /proc/mtd | grep \"${active_part_name}\" | grep 03e00000 -m 1 | cut -d":" -f 1)
	active_part_offset=$(printf "0x%x\n" $(cat /sys/class/mtd/${active_part_dev}/offset))
	local active=0
	#select partition to install based on active partition offset
	[ -z "$active_part_offset" ] && exit 1
	if [ "$active_part_offset" != "0x80000" ]; then
		active=1
	fi

	val=$(fw_printenv -n owrt_env_ver 2>/dev/null)
	ret=$?
	[ $ret != 0 ] && val=0
	[ $val -lt 5 ] && sw8v3_env_setup $active
	if [ "$active" = "1" ]; then
		CI_UBIPART="rootfs"
		fw_setenv owrt_slotactive 0
	else
		CI_UBIPART="rootfs_1"
		fw_setenv owrt_slotactive 1
	fi
	fw_setenv owrt_bootcount 0
}

platform_check_image() {
	return 0;
}

platform_pre_upgrade() {
	case "$(board_name)" in
	xiaomi,ax6000)
		xiaomi_initramfs_prepare
		;;
	esac
}

platform_do_upgrade() {
	case "$(board_name)" in
	elecom,wrc-x3000gs2|\
	iodata,wn-dax3000gr)
		local delay

		delay=$(fw_printenv bootdelay)
		[ -z "$delay" ] || [ "$delay" -eq "0" ] && \
			fw_setenv bootdelay 3

		elecom_upgrade_prepare

		remove_oem_ubi_volume bt_fw
		remove_oem_ubi_volume ubi_rootfs
		remove_oem_ubi_volume wifi_fw
		nand_do_upgrade "$1"
		;;
	glinet,gl-b3000)
		glinet_do_upgrade "$1"
		;;
	linksys,mr5500|\
	linksys,mx2000|\
	linksys,mx5500|\
	linksys,spnmx56)
		linksys_mx_pre_upgrade "$1"
		remove_oem_ubi_volume squashfs
		nand_do_upgrade "$1"
		;;
	xiaomi,ax6000)
		# Make sure that UART is enabled
		fw_setenv boot_wait on
		fw_setenv uart_en 1

		# Enforce single partition.
		fw_setenv flag_boot_rootfs 0
		fw_setenv flag_last_success 0
		fw_setenv flag_boot_success 1
		fw_setenv flag_try_sys1_failed 8
		fw_setenv flag_try_sys2_failed 8

		# Kernel and rootfs are placed in 2 different UBI
		CI_KERN_UBIPART="ubi_kernel"
		CI_ROOT_UBIPART="rootfs"
		nand_do_upgrade "$1"
		;;
	ikuai,sw8v3|\
	fplus,wf-ap-624m-iic-v1|\
	fplus,wf-ap-624m-iic-v3)
		remove_oem_ubi_volume ubi_rootfs
		remove_oem_ubi_volume bt_fw
		remove_oem_ubi_volume wifi_fw
		sw8v3_upgrade
		nand_do_upgrade "$1"
		;;
	yuncore,ax830)
		CI_UBIPART="rootfs"
		remove_oem_ubi_volume ubi_rootfs
		remove_oem_ubi_volume bt_fw
		remove_oem_ubi_volume wifi_fw
		nand_do_upgrade "$1"
		;;
	*)
		default_do_upgrade "$1"
		;;
	esac
}
