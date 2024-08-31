#
# Copyright (C) 2016-2019 OpenWrt.org
# Copyright (C) 2017 LEDE project
#

ARCH:=aarch64
SUBTARGET:=lan9694
BOARDNAME:=lan9694 boards (64 bit)
CPU_TYPE:=cortex-a53
KERNELNAME:=vmlinux Image Image.gz dtbs

define Target/Description
	Build firmware image for lan9694 devices.
	This firmware features a 64 bit kernel.
endef
