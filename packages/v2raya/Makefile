include $(TOPDIR)/rules.mk

PKG_NAME:=v2raya
PKG_VERSION:=2.5.10
PKG_RELEASE:=1

PKG_SOURCE:=v2rayA-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://codeload.github.com/v2rayA/v2rayA/tar.gz/v$(PKG_VERSION)?
PKG_HASH:=046ff46ca35b102334c0a74c303867d1724d628ca45c258816b1bcaa9dfc6971
PKG_BUILD_DIR:=$(BUILD_DIR)/v2raya-service-$(PKG_VERSION)/service

PKG_LICENSE:=AGPL-3.0-only
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=chenjun6pku <chenjun6pku@users.noreply.github.com>

PKG_BUILD_DEPENDS:=golang/host
PKG_BUILD_PARALLEL:=1
PKG_BUILD_FLAGS:=no-mips16

GO_PKG:=github.com/v2rayA/v2rayA
GO_PKG_LDFLAGS_X:=github.com/v2rayA/v2rayA/conf.Version=$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-package.mk

TAR_OPTIONS+= --strip-components 1

# The service uses modernc.org/sqlite on non-mips targets and
# mattn/go-sqlite3 on mips/loong64. The latter needs cgo, so keep the
# SDK's CGO_ENABLED=1 there and use a static pure-Go build elsewhere.
ifneq ($(filter mips mipsle mips64 mips64le loong64,$(GO_ARCH)),)
  GO_PKG_TARGET_VARS:=$(GO_PKG_TARGET_VARS)
else
  GO_PKG_TARGET_VARS:=$(filter-out CGO_ENABLED=%,$(GO_PKG_TARGET_VARS)) CGO_ENABLED=0
  GO_PKG_DEFAULT_LDFLAGS:=$(filter-out -linkmode external,$(GO_PKG_DEFAULT_LDFLAGS))
endif

WEB_FILE:=v2rayA-web-$(PKG_VERSION).tar.gz
define Download/v2raya-web
	URL:=https://github.com/v2rayA/v2rayA/releases/download/v$(PKG_VERSION)/
	URL_FILE:=web.tar.gz
	FILE:=$(WEB_FILE)
	HASH:=c25071a27f7b98eebb1a80d44b8d6a65d7533cf4cdff475ec86343d7deca5c86
endef

define Build/Prepare
	$(call Build/Prepare/Default)

	# The package license file is at the tarball root; copy it next to
	# the service sources so PKG_LICENSE_FILES resolves.
	$(CP) $(PKG_BUILD_DIR)/../LICENSE $(PKG_BUILD_DIR)/LICENSE

	mkdir -p $(PKG_BUILD_DIR)/server/router/web
	gzip -dc $(DL_DIR)/$(WEB_FILE) | $(HOST_TAR) -C $(PKG_BUILD_DIR)/server/router/web $(TAR_OPTIONS)
endef

define Package/v2raya
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Web Servers/Proxies
  TITLE:=v2rayA web GUI for transparent proxy
  URL:=https://github.com/v2rayA/v2rayA
  DEPENDS:=$(GO_ARCH_DEPENDS) +v2raya-core +ca-bundle +v2ray-geoip +v2ray-geosite +kmod-tun +kmod-nft-tproxy +ip-full
  EXTRA_DEPENDS:=v2raya-core (= $(PKG_VERSION)-r$(PKG_RELEASE))
endef

define Package/v2raya/description
  v2rayA is a web client for its own Xray-based core, with transparent
  proxy support on OpenWrt. This package contains the service, the web
  interface and the init/config files; the matching core binary is in
  v2raya-core.
endef

define Package/v2raya/conffiles
/etc/v2raya/
/etc/config/v2raya
endef

define Package/v2raya/install
	$(call GoPackage/Package/Install/Bin,$(PKG_INSTALL_DIR))
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/v2rayA $(1)/usr/bin/v2raya

	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/v2raya.config $(1)/etc/config/v2raya
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/v2raya.init $(1)/etc/init.d/v2raya
endef

$(eval $(call Download,v2raya-web))
$(eval $(call GoBinPackage,v2raya))
$(eval $(call BuildPackage,v2raya))
