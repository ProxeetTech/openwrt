include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

define Image/Build
	$(call Image/Build/$(1))
	$(CP) $(KDIR)/Image.gz $(BIN_DIR)/Image.gz
	mkimage -A arm -O linux -T ramdisk -d $(BIN_DIR)/$(IMG_PREFIX)-rootfs.cpio.gz $(BIN_DIR)/uRamdisk
	$(CP) $(DTS_DIR)/microchip/lan969x_ev23x71a.dtb $(BIN_DIR)/lan969x_ev23x71a.dtb
	$(TOPDIR)/scripts/openwrt_make_fit.sh $(BIN_DIR)
endef

$(eval $(call Image/gzip-ext4-padded-squashfs))

$(eval $(call BuildImage))
