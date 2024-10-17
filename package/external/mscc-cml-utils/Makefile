################################################################################
#
# mscc-cml-utils
#
################################################################################
include $(TOPDIR)/rules.mk

PKG_NAME:=mscc-cml-utils
PKG_VERSION:=1
PKG_SOURCE_URL:=file://$(TOPDIR)/external
PKG_SOURCE:=mscc-cml-utils.tar.gz
PKG_HASH:=c79edf8193d9647edd213418bd1bffc88fb7338a6a27175ef106f200a2787fc1
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=E. Tsybra <zcjack81@gmail.com>
PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

CMAKE_HOST_OPTIONS += -DBUILD_MASERATI=OFF -DBUILD_LAGUNA=OFF -DBUILD_VCAP_API=ON -DBUILD_SPARX5=OFF
CMAKE_OPTIONS += -DBUILD_MASERATI=OFF -DBUILD_LAGUNA=OFF -DBUILD_VCAP_API=ON -DBUILD_SPARX5=OFF

define Package/mscc-cml-utils
	SECTION:=net
	CATEGORY:=Network
	SUBMENU:=External
	TITLE:=Tool for Symbolic Register Access
	URL:=https://bitbucket.microchip.com
	DEPENDS:=+libnl
endef

define Package/mscc-cml-utils/description
	Tool for Symbolic Register Access
endef

define Package/mscc-cml-utils/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/vcap $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/cml-dump $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/cml-symreg $(1)/usr/bin/
endef

$(eval $(call BuildPackage,mscc-cml-utils))