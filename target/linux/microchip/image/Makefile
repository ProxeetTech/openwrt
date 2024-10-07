include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

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
  IMAGE/sysupgrade.img.gz := append-rootfs | pad-rootfs | gzip | append-metadata
  IMAGE/factory.img.gz := append-rootfs | pad-rootfs | gzip
endef

define Device/pxrouter
  DEVICE_DTS := microchip/lan969x_ev23x71a
  SUPPORTED_DEVICES := microchip,lan969x
endef
ifeq ($(SUBTARGET),lan9694)
  TARGET_DEVICES += pxrouter
endif

define Image/Prepare
	mkdir -p $(TARGET_DIR)/lib/boot/
	$(CP) $(KDIR)/Image.gz $(TARGET_DIR)/lib/boot/
	$(CP) $(DTS_DIR)/microchip/lan969x_ev23x71a.dtb $(TARGET_DIR)/lib/boot/
endef

$(eval $(call Image/gzip-ext4-padded-squashfs))

$(eval $(call BuildImage))
