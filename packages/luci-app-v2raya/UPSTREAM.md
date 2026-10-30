# Upstream

| Item | Value |
| --- | --- |
| Project | v2rayA/v2raya-openwrt |
| URL | https://github.com/v2rayA/v2raya-openwrt |
| Path | luci-app-v2raya |
| Ref | d288e54992b03365a2f6cf2e8932b5031dc2cf70 |
| Snapshot | 2026-10-30 |
| License | Apache-2.0 |

The package's copyright and original LuCI application are from
ImmortalWrt.org; `v2rayA/v2raya-openwrt` is the canonical v2rayA OpenWrt
packaging repository and the source used here.

`diff -r` against `v2rayA/v2raya-openwrt@d288e54` (excluding this file and
`Makefile`) shows no differences. The Makefile is the only changed file.

## Local changes

- Set `PKG_RELEASE:=2` and `PKG_PO_VERSION:=12-r2`; upstream uses the
  git-derived `PKG_SRC_VERSION` and leaves `PKG_PO_VERSION` at `12`.
- Add `+luci-base` to `LUCI_DEPENDS`. `luci.mk` does not add it implicitly;
  the views require the LuCI runtime and its rpcd/ucode dependencies.

No changes to the JavaScript views, menu, ACL, or translation files.
