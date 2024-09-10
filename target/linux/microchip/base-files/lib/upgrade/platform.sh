. /lib/functions.sh

REQUIRE_IMAGE_METADATA=1
RAMFS_COPY_BIN='fw_printenv fw_setenv'
RAMFS_COPY_DATA='/etc/fw_env.config /var/lock/fw_printenv.lock'

PROXEET_ACTIVE_PART=5

platform_check_image() {
	[ "$#" -gt 1 ] && return 1

	echo "platform_check_image"
	return 0;
}

platform_do_upgrade() {
	local diskdev boot_part

	echo "platform_do_upgrade"
	boot_part=`fw_printenv -n mmc_cur`
	[ "$boot_part" -eq "5" ] && PROXEET_ACTIVE_PART=6
	echo "Boot part: ""$boot_part"
	echo "Try to write part: ""$PROXEET_ACTIVE_PART"" with file: ""$1"
	diskdev="/dev/mmcblk0p""$PROXEET_ACTIVE_PART"
	echo "diskdev: ""$diskdev"

	get_image_dd "$1" of="$diskdev" bs=4096
	sync

	# change boot partition
	fw_setenv mmc_cur "$PROXEET_ACTIVE_PART"
	sync

	echo "platform_do_upgrade exit"

	return 0;
}

platform_copy_config() {
	local diskdev

	echo "platform_copy_config"

	diskdev="/dev/mmcblk0p""$PROXEET_ACTIVE_PART"
	echo "diskdev: ""$diskdev"

	mkdir -p /tmp/recovery
	mount $diskdev /tmp/recovery
	cp -af "$UPGRADE_BACKUP" "/tmp/recovery/$BACKUP_FILE"
	sync
	umount /tmp/recovery

	echo "platform_copy_config exit"

	return 0;
}

platform_restore_backup() {
	local TAR_V=$1

	echo "platform_restore_backup"

	return 0;
}
