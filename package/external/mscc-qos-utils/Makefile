################################################################################
#
# qos-utils
#
################################################################################
include $(TOPDIR)/rules.mk

PKG_NAME:=mscc-qos-utils
PKG_VERSION:=a5050640d36489f7126cef92f3529243295fa099
PKG_SOURCE_URL:=file://$(TOPDIR)/external
PKG_SOURCE:=mscc-qos-utils.tar.xz
PKG_HASH:=b23c1d7544e9e5eb873525254a6f22408c9a1052c6eeb3489a1c98b34d5f8ed0
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=E. Tsybra <zcjack81@gmail.com>
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/mscc-qos-utils
	SECTION:=net
	CATEGORY:=Network
	SUBMENU:=External
	TITLE:=Tool for configuring qos
	URL:=https://bitbucket.microchip.com
	DEPENDS:=+libnl
endef

define Package/mscc-qos-utils/description
	Tool for configuring qos
endef

define Package/mscc-qos-utils/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/qos $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/frer $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/psfp $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/fp $(1)/usr/sbin
endef

$(eval $(call BuildPackage,mscc-qos-utils))
