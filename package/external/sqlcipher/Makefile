include $(TOPDIR)/rules.mk

PKG_NAME:=sqlcipher
PKG_VERSION:=4.6.1
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/sqlcipher/sqlcipher/
PKG_HASH:=5afd4a5d1355fdcf1795d0d9d0cd9f23057f311c1031384d62138fd3406c1018

PKG_LICENSE:=PUBLICDOMAIN
PKG_LICENSE_FILES:=
PKG_MAINTAINER:=

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_BUILD_PARALLEL:=1
PKG_FIXUP:=autoreconf
# PKG_INSTALL:=1

PKG_CONFIG_DEPENDS := \
	CONFIG_PACKAGE_libopenssl

include $(INCLUDE_DIR)/package.mk

CONFIGURE_ARGS += \
	--disable-debug \
	--disable-static-shell \
	--enable-shared \
	--enable-static \
	--enable-threadsafe \
	--disable-tcl \
	$(if $(CONFIG_SQLITE3_DYNAMIC_EXTENSIONS),--enable-dynamic-extensions,--disable-dynamic-extensions) \
	$(if $(CONFIG_SQLITE3_FTS3),--enable-fts3,--disable-fts3) \
	$(if $(CONFIG_SQLITE3_FTS4),--enable-fts4,--disable-fts4) \
	$(if $(CONFIG_SQLITE3_FTS5),--enable-fts5,--disable-fts5) \
	$(if $(CONFIG_SQLITE3_RTREE),--enable-rtree,--disable-rtree) \
	$(if $(CONFIG_SQLITE3_SESSION),--enable-session,--disable-session)

ifeq ($(CONFIG_SQLITE3_LIBEDIT),y)
CONFIGURE_ARGS+=--disable-readline
else ifeq ($(CONFIG_SQLITE3_READLINE),y)
CONFIGURE_ARGS+=--disable-editline
else
CONFIGURE_ARGS+=--disable-editline --disable-readline
endif

#   ABI_VERSION:=0

define Package/sqlcipher
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+libpthread +zlib
  SUBMENU:=Database
  TITLE:=sqlcipher 

  URL:=https://github.com/sqlcipher/sqlcipher/
endef

define Package/sqlcipher/description
 This package contains the sqlcipher shared library, used by other
 programs.
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	# $(CP) $(PKG_INSTALL_DIR)/usr/lib/libsqlcipher.{a,so*} $(1)/usr/lib
	# $(INSTALL_DATA) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/sqlcipher.pc $(1)/usr/lib/pkgconfig
endef

define Package/sqlcipher/install
	$(INSTALL_DIR) $(1)/usr/lib
	# $(CP) $(PKG_INSTALL_DIR)/usr/lib/libsqlcipher.so.* $(1)/usr/lib
	# $(INSTALL_DIR) $(1)/usr/bin
	# $(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/sqlcipher $(1)/usr/bin
endef

$(eval $(call BuildPackage,sqlcipher))
