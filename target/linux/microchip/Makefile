# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024
# Copyright (C) 2012-2020 OpenWrt.org
# Copyright (C) 2017 LEDE project

include $(TOPDIR)/rules.mk

ARCH:=arm
BOARD:=microchip
BOARDNAME:=Microchip lan96xx
FEATURES:=gpio rtc usb usbgadget squashfs targz nand ubifs boot-part rootfs-part ext4
SUBTARGETS:=lan9668 lan9694

KERNEL_PATCHVER:=6.1

KERNEL_TESTING_PATCHVER:=6.1

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES += kmod-usb-hid

$(eval $(call BuildTarget))
