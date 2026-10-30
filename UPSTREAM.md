# Upstream

| Item | Value |
| --- | --- |
| Project | v2rayA |
| URL | https://github.com/v2rayA/v2rayA |
| Version | v2.5.10 |
| Commit | 7609aed42cc6d2eb9db607c0d3a5d2e4e35ecf5e |
| Source tarball | https://codeload.github.com/v2rayA/v2rayA/tar.gz/v2.5.10 |
| Source SHA256 | 046ff46ca35b102334c0a74c303867d1724d628ca45c258816b1bcaa9dfc6971 |
| Web asset | https://github.com/v2rayA/v2rayA/releases/download/v2.5.10/web.tar.gz |
| Web SHA256 | c25071a27f7b98eebb1a80d44b8d6a65d7533cf4cdff475ec86343d7deca5c86 |

## LuCI application

The `packages/luci-app-v2raya` directory is a snapshot of the ImmortalWrt
LuCI application:

- URL: https://github.com/immortalwrt/luci
- Path: `applications/luci-app-v2raya`
- License: Apache-2.0
- Local changes are recorded in `packages/luci-app-v2raya/UPSTREAM.md`.

## Licenses

- `service/` and the repository root: AGPL-3.0-only
- `core/`: MPL-2.0
- `luci-app-v2raya`: Apache-2.0

The adapter repository itself is MIT-licensed. The built binaries, the
embedded web UI, and the LuCI application remain under their upstream
licenses.

## Local changes

No upstream source changes. This repository only adds OpenWrt 25.12 packaging
files, init/config files, a local build script, and GitHub Actions workflows.

## Updating

1. Change `PKG_VERSION` and both source references in
   `packages/v2raya/Makefile` and `packages/v2raya-core/Makefile`.
2. Update `PKG_HASH`, the web `HASH`, and this file.
3. Increment `PKG_RELEASE` for packaging-only changes.
4. Build locally and verify the service and core versions match.
