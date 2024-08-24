#
# Copyright (C) 2024
# Copyright (C) 2015-2019 OpenWrt.org
#

SUBTARGET:=lan9668
BOARDNAME:=lan9668 boards (32 bit)
CPU_TYPE:=cortex-a7
CPU_SUBTYPE:=vfpv4
FEATURES+=fpu
KERNELNAME:=zImage dtbs

define Target/Description
	Build firmware image for lan9668 devices.
	This firmware features a 32 bit kernel.
endef
