# 
# Copyright (C) 2024 Proxeet Ltd.
# Author: Aleksei Vasilenko <a.vasilenko@proxeet.com>
#

include $(TOPDIR)/rules.mk

PKG_NAME:=poed
PKG_VERSION:=1.0.0
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:ProxeetTech/poed.git
PKG_SOURCE_VERSION:=main

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/$(PKG_NAME)
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=PoE Daemon
	URL:=https://github.com/ProxeetTech/poed
	MAINTAINER:=Aleksei Vasilenko <a.vasilenko@proxeet.com>
	DEPENDS:=+libstdcpp +libuci
endef

define Package/$(PKG_NAME)/description
	The PoE Daemon (PoED) is a background service that monitors and manages 
	Power over Ethernet (PoE) ports on your system. It allows you to control budgets, 
	collect power usage data, and communicate with the daemon through a Unix socket.
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/poed $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/poed $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_BIN) ./files/etc/config/poed $(1)/etc/config/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))
