# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2019 OpenWrt.org

define KernelPackage/spi-lan96xx
  SUBMENU:=$(SPI_MENU)
  TITLE:=LAN96xx SPI controller driver
  KCONFIG:=\
    CONFIG_SPI=y \
    CONFIG_SPI_MASTER=y
endef

define KernelPackage/spi-lan96xx/description
  This package contains the LAN96xx SPI master controller driver
endef

$(eval $(call KernelPackage,spi-lan96xx))