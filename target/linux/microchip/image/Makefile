include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

define Build/boot-scr
	rm -f $@-boot.scr
	mkimage -A arm64 -O linux -T script -C none -a 0 -e 0 \
		-d bootscript-$(BOOT_SCRIPT) $@-boot.scr
endef

define Build/boot-img-ext4
	rm -fR $@.boot
	mkdir -p $@.boot
	$(foreach dts,$(DEVICE_DTS), $(CP) $(KDIR)/image-$(dts).dtb $@.boot/$(dts).dtb;)
	$(CP) $(IMAGE_KERNEL) $@.boot/$(KERNEL_NAME)
	-$(CP) $@-boot.scr $@.boot/boot.scr
	make_ext4fs -J -L kernel -l $(CONFIG_TARGET_KERNEL_PARTSIZE)M \
		$(if $(SOURCE_DATE_EPOCH),-T $(SOURCE_DATE_EPOCH)) \
		$@.bootimg $@.boot
endef

define Build/sdcard-img-ext4
	SIGNATURE="$(IMG_PART_SIGNATURE)" \
	PARTOFFSET="$(PARTITION_OFFSET)" PADDING=1 \
		$(if $(filter $(1),efi),GUID="$(IMG_PART_DISKGUID)") $(SCRIPT_DIR)/gen_image_generic.sh \
		$@ \
		$(CONFIG_TARGET_KERNEL_PARTSIZE) $@.boot \
		$(CONFIG_TARGET_ROOTFS_PARTSIZE) $(IMAGE_ROOTFS) \
		256
endef

define Image/Build
	$(call Image/Build/$(1))
	$(CP) $(KDIR)/Image.gz $(BIN_DIR)/Image.gz
	mkimage -A arm -O linux -T ramdisk -d $(BIN_DIR)/$(IMG_PREFIX)-rootfs.cpio.gz $(BIN_DIR)/uRamdisk
	$(CP) $(DTS_DIR)/microchip/lan969x_ev23x71a.dtb $(BIN_DIR)/lan969x_ev23x71a.dtb
	$(TOPDIR)/scripts/openwrt_make_fit.sh $(BIN_DIR)
endef

### Devices ###
define Device/Default
  DEVICE_VENDOR := Proxeet
  KERNEL := kernel-bin
  KERNEL_IMG := kernel.img
  IMAGES := factory.img.gz sysupgrade.img.gz
  IMAGE/sysupgrade.img.gz := append-rootfs | pad-rootfs | gzip
  IMAGE/factory.img.gz := append-rootfs | pad-rootfs | gzip
endef

define Device/pxrouter
  DEVICE_DTS := microchip/lan969x_ev23x71a
  SUPPORTED_DEVICES := microchip,lan969x
endef
ifeq ($(SUBTARGET),lan9694)
  TARGET_DEVICES += pxrouter
endif

$(eval $(call Image/gzip-ext4-padded-squashfs))

$(eval $(call BuildImage))
