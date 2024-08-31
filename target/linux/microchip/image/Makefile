include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

define Image/Build
	$(call Image/Build/$(1))
	$(CP) $(KDIR)/Image.gz $(BIN_DIR)/Image.gz
	mkimage -A arm -O linux -T ramdisk -d $(BIN_DIR)/$(IMG_PREFIX)-rootfs.cpio.gz $(BIN_DIR)/uRamdisk
endef

DTS_DIR := $(DTS_DIR)/microchip
#dts/microchip/lan969x_ev23x71a.dtb

$(eval $(call Image/gzip-ext4-padded-squashfs))

$(eval $(call BuildImage))
