# SPDX-License-Identifier: Apache-2.0
#
# Copyright (C) 2024 ImmortalWrt.org

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for v2rayA
# luci.mk does not add luci-base implicitly; add it so a standalone
# install also pulls the LuCI runtime and its rpcd/ucode dependencies.
LUCI_DEPENDS:=+luci-base +v2raya

PKG_VERSION:=12
PKG_RELEASE:=2
PKG_PO_VERSION:=$(PKG_VERSION)-r$(PKG_RELEASE)

PKG_LICENSE:=Apache-2.0
PKG_MAINTAINER:=Tianling Shen <cnsztl@immortalwrt.org>

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
