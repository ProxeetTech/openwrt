. /lib/functions.sh

REQUIRE_IMAGE_METADATA=1
RAMFS_COPY_BIN='fw_printenv fw_setenv'
RAMFS_COPY_DATA='/etc/fw_env.config /var/lock/fw_printenv.lock'

platform_check_image() {
	local diskdev partdev diff

	[ "$#" -gt 1 ] && return 1

	export_bootdevice && export_partdevice diskdev 0 || {
		echo "Unable to determine upgrade device"
		return 1
	}

	echo "platform_check_image"

	return 0;
}

platform_do_upgrade() {
	local diskdev partdev diff

	export_bootdevice && export_partdevice diskdev 0 || {
		echo "Unable to determine upgrade device"
		return 1
	}

	boot_part=`fw_printenv -n mmc_cur`
	active_part=5
	[ "$boot_part" -eq "5" ] && active_part=6
	echo "Boot part: ""$boot_part"
	echo "Try to write part: ""$active_part"" with file: ""$1"
	diskdev="/dev/mmcblk0p""$active_part"
	echo "diskdev: ""$diskdev"

	get_image_dd "$1" of="$diskdev" bs=4096

	sync

	echo "platform_do_upgrade"

	return 0;
}

platform_copy_config() {
	local partdev

	if export_partdevice partdev 1; then
		mkdir -p /boot
	fi

	echo "platform_copy_config"

	boot_part=`fw_printenv -n mmc_cur`
	active_part=5
	[ "$boot_part" -eq "5" ] && active_part=6
	echo "Boot part: ""$boot_part"
	echo "Try to write part: ""$active_part"" with file: ""$1"
	diskdev="/dev/mmcblk0p""$active_part"
	echo "diskdev: ""$diskdev"

	mkdir -p /tmp/recovery
	mount $diskdev /tmp/recovery
	cp -af "$UPGRADE_BACKUP" "/tmp/recovery/$BACKUP_FILE"
	sync
	umount /tmp/recovery

	# change boot partition
	fw_setenv mmc_cur "$active_part"
	sync

	return 0;
}

platform_restore_backup() {
	local TAR_V=$1

	echo "platform_restore_backup"

	return 0;
}
