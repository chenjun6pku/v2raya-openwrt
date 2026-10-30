# Upstream

| Item | Value |
| --- | --- |
| Project | ImmortalWrt LuCI |
| URL | https://github.com/immortalwrt/luci |
| Path | applications/luci-app-v2raya |
| Ref | df794c7f69361641195a4b336634d1b1c918099c |
| Snapshot | 2026-10-30 |
| License | Apache-2.0 |

## Local changes

- Set `PKG_VERSION:=12` and `PKG_RELEASE:=2`; upstream leaves the version to
  `luci.mk`'s git-derived `PKG_SRC_VERSION`.
- Set `PKG_PO_VERSION:=12-r2` so the translation packages carry the same
  release as the application package.
- Add `+luci-base` to `LUCI_DEPENDS`. `luci.mk` does not add it implicitly;
  the views require the LuCI runtime and its rpcd/ucode dependencies.

No changes to the JavaScript views, menu, ACL, or translation files.
