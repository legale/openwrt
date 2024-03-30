PART_NAME=firmware
REQUIRE_IMAGE_METADATA=1

RAMFS_COPY_BIN='fw_printenv fw_setenv head'
RAMFS_COPY_DATA='/etc/fw_env.config /var/lock/fw_printenv.lock'

platform_check_image() {
	return 0;
}

platform_do_upgrade() {
	case "$(board_name)" in
	netgear,wax214)
		nand_do_upgrade "$1"
		;;
	yuncore,ax840-p2|\
	yuncore,fap650)
		[ "$(fw_printenv -n owrt_env_ver 2>/dev/null)" != "7" ] && yuncore_fap650_env_setup
		local active="$(fw_printenv -n owrt_slotactive 2>/dev/null)"
		if [ "$active" = "1" ]; then
			CI_UBIPART="rootfs"
		else
			CI_UBIPART="rootfs_1"
		fi
		fw_setenv owrt_bootcount 0
		fw_setenv owrt_slotactive $((1 - active))
		nand_do_upgrade "$1"
		;;
	*)
		default_do_upgrade "$1"
		;;
	esac
}
