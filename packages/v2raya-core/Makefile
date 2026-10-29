include $(TOPDIR)/rules.mk

PKG_NAME:=v2raya-core
PKG_VERSION:=2.5.10
PKG_RELEASE:=1

PKG_SOURCE:=v2rayA-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/v2rayA/v2rayA/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=046ff46ca35b102334c0a74c303867d1724d628ca45c258816b1bcaa9dfc6971
PKG_BUILD_DIR:=$(BUILD_DIR)/v2raya-core-$(PKG_VERSION)/core

PKG_LICENSE:=MPL-2.0
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=chenjun6pku <chenjun6pku@users.noreply.github.com>

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/v2rayA/v2raya-core
GO_PKG_BUILD_PKG:=github.com/v2rayA/v2raya-core/main
GO_PKG_LDFLAGS_X:=main.Version=$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

TAR_OPTIONS+= --strip-components 1

# The core has no cgo dependency. Keep it static and free of libc.
GO_PKG_TARGET_VARS:=$(filter-out CGO_ENABLED=%,$(GO_PKG_TARGET_VARS)) CGO_ENABLED=0
GO_PKG_DEFAULT_LDFLAGS:=$(filter-out -linkmode external,$(GO_PKG_DEFAULT_LDFLAGS))

define Package/v2raya-core
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=v2rayA core (v2raya_core)
  URL:=https://github.com/v2rayA/v2rayA
  DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/v2raya-core/description
  The v2rayA-specific core binary built from the v2rayA core module.
  It contains the v2rayA DNS module, the in-core TUN inbound and
  multi-observer support.
endef

define Package/v2raya-core/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/main $(1)/usr/bin/v2raya_core
endef

$(eval $(call GoBinPackage,v2raya-core))
$(eval $(call BuildPackage,v2raya-core))
