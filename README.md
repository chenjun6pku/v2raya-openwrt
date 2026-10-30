# v2raya-openwrt

为 **OpenWrt 25.12** 构建 v2rayA **2.5.10** 及其 LuCI 集成界面的 `.apk` 包。

本仓库是一个独立的编译适配项目，**不是 apk feed**：

- 不发布 `packages.adb`
- 不提供签名索引
- 不配置 `/etc/apk/repositories.d/`
- 用户从 GitHub Releases 下载 `.apk` 后手动安装

这样可以与 OpenWrt 官方源中的 `v2raya` 2.2.7.5 解耦，不使用第三方 feed，
也不依赖本仓库提供在线升级。

## 支持范围

| 项目 | 值 |
| --- | --- |
| OpenWrt | 25.12.x（使用 25.12.6 SDK 构建） |
| 包管理 | apk v3 |
| 架构 | `x86_64`、`aarch64_cortex-a53`、`mipsel_24kc` |
| 上游 | v2rayA v2.5.10 |

## 完整包组成

本仓库负责构建并发布：

| 包 | 架构 | 作用 |
| --- | --- | --- |
| `v2raya-core` | 每架构 | `/usr/bin/v2raya_core`（MPL-2.0） |
| `v2raya` | 每架构 | `/usr/bin/v2raya` + 内嵌 Web UI + init/config（AGPL-3.0-only） |
| `luci-app-v2raya` | `all` | LuCI 菜单、配置和日志页面（Apache-2.0） |
| `luci-i18n-v2raya-*` | `all` | LuCI 翻译包，按语言可选 |

OpenWrt 官方 feed 提供、由 `apk` 自动安装的依赖：

| 包 | 说明 |
| --- | --- |
| `luci-base`（及其 rpcd/ucode 依赖） | `luci-app-v2raya` 的 LuCI 运行时 |
| `ca-bundle` | TLS 根证书 |
| `v2ray-geoip`、`v2ray-geosite` | GeoIP/GeoSite 数据，安装到 `/usr/share/v2ray` |
| `ip-full` | 策略路由 |
| `kmod-tun`、`kmod-nft-tproxy` | TUN/TPROXY 内核模块 |
| `libc` | 基础 C 库 |

`kmod-*` 与设备内核版本绑定，不能由本仓库跨设备发布，必须从设备对应的官方 feed
安装。`v2ray-geoip`/`v2ray-geosite` 也由官方 feed 持续更新，因此不作为本仓库的
固定版本产物。

## 产物

每个架构发布两个 v2rayA 包（文件名带架构后缀，便于手动下载）：

```text
v2raya-core-2.5.10-r1-<arch>.apk   # /usr/bin/v2raya_core（MPL-2.0）
v2raya-2.5.10-r1-<arch>.apk        # /usr/bin/v2raya + Web UI + init/config（AGPL-3.0-only）
```

另发布与架构无关的 LuCI 包（由 x86_64 构建任务生成，所有架构通用）：

```text
luci-app-v2raya-12-r2.apk
luci-i18n-v2raya-<lang>-12-r2.apk  # 可选语言包
```

同时提供 `sha256sums-<arch>` 和 `sha256sums-all`。LuCI 应用沿用上游版本 `12`，
使用本仓库的 `-r2` release 表示本地适配（增加 `luci-base` 依赖）。

## 安装

在 GitHub Releases 下载对应架构的 `.apk`，然后在设备上安装完整组件：

```sh
ARCH="$(. /etc/openwrt_release; echo "$DISTRIB_ARCH")"
sha256sum -c "sha256sums-$ARCH"
sha256sum -c "sha256sums-all"
apk add --allow-untrusted \
  "./v2raya-core-2.5.10-r1-$ARCH.apk" \
  "./v2raya-2.5.10-r1-$ARCH.apk" \
  "./luci-app-v2raya-12-r2.apk"
```

如果只需要 v2rayA Web UI、不需要 LuCI 菜单，可以只安装前两个包。

可选语言包（以简体中文为例）：

```sh
apk add --allow-untrusted ./luci-i18n-v2raya-zh-cn-12-r2.apk
```

`--allow-untrusted` 是因为这些包不经过 apk feed 索引签名。请只从本仓库的
Releases 下载，并先校验 SHA256。`luci-app-v2raya` 依赖的 `luci-base`、geo 数据和
内核模块会从设备已配置的官方 feed 自动安装。

启用并启动服务：

```sh
/etc/init.d/v2raya enable
/etc/init.d/v2raya start
```

浏览器打开：

```text
http://<设备地址>:2017
```

首次访问时创建管理员账户。服务默认监听 `0.0.0.0:2017`；如需只允许本机访问，
修改 `/etc/config/v2raya` 中的 `address` 为 `127.0.0.1:2017`。

## 依赖

`v2raya` 的包依赖会由 `apk` 自动解析：

- `v2raya-core`（本仓库提供）
- `ca-bundle`
- `v2ray-geoip`、`v2ray-geosite`（由官方 feed 提供，安装到 `/usr/share/v2ray`）
- `kmod-tun`（TUN 模式）
- `kmod-nft-tproxy`（nftables TPROXY 模式）
- `ip-full`（策略路由）

`luci-app-v2raya` 额外依赖：

- `luci-base`（官方 feed，自动带 rpcd/ucode）
- `v2raya`（本仓库提供）

如果设备离线，需要提前准备这些依赖包。透明代理模式还需要设备具备对应的
内核模块；`tun` 模式需要 `/dev/net/tun`，`tproxy` 需要 `xt_TPROXY`，`redirect`
需要 iptables/nftables 的 NAT 支持。

## 与官方 `v2raya` 包的关系

OpenWrt 官方 feed 维护的是 `v2raya` 2.2.7.5。本仓库的包名同样是 `v2raya`，
因此手动安装 2.5.10 会覆盖官方版本。

- 手动安装后，`apk` 认为已安装版本是 2.5.10，高于官方 2.2.7.5，`apk upgrade`
  不会自动降级
- 如果以后官方 feed 升级到更高的 `v2raya` 版本，`apk upgrade` 可能改用官方包；
  需要保留本仓库版本时请显式安装本仓库的 `.apk`
- 想回到官方包：

```sh
apk del v2raya v2raya-core
apk add v2raya
```

`/etc/v2raya/` 和 `/etc/config/v2raya` 属于 conffiles，卸载时通常保留。

## 本地编译

### 使用 Docker（推荐）

```sh
./scripts/build-local.sh x86_64
./scripts/build-local.sh aarch64_cortex-a53
./scripts/build-local.sh mipsel_24kc
```

脚本使用 `openwrt/sdk:<arch>-25.12.6` 镜像，在容器内编译，架构相关产物放到
`dist/<arch>/`；x86_64 构建还会把 `luci-app-v2raya` 和翻译包放到 `dist/all/`。

### 使用已解压的 SDK

```sh
./scripts/build-local.sh x86_64 /path/to/openwrt-sdk-25.12.6-...
```

或在 SDK 目录中手动执行：

```sh
echo "src-link custom /path/to/v2raya-openwrt" >> feeds.conf
./scripts/feeds update -a
make defconfig
./scripts/feeds install -p custom -f v2raya-core v2raya luci-app-v2raya
make package/v2raya-core/compile V=s
make package/v2raya/compile V=s
make package/luci-app-v2raya/compile V=s
```

产物位于：

```text
bin/packages/<arch>/custom/*.apk   # v2raya-core、v2raya
bin/packages/all/custom/*.apk      # luci-app-v2raya 及其翻译包
```

## GitHub Actions

`.github/workflows/build-apk.yml`：

- `workflow_dispatch`：手动触发测试编译
- push 到 `main`：构建三个架构并上传 artifact
- x86_64 任务额外构建 `luci-app-v2raya` 和翻译包，产物在 `v2raya-all` artifact
- 推送 `v*` tag：额外创建 GitHub Release，附上 `.apk`、`sha256sums-<arch>` 和
  `sha256sums-all`

构建使用官方 OpenWrt 25.12.6 SDK 容器，不接触任何签名私钥，不生成 feed 索引。

## 目录

```text
packages/v2raya-core/       core 的 OpenWrt Makefile
packages/v2raya/            service 的 Makefile、init、config
packages/luci-app-v2raya/   LuCI 应用、菜单、ACL 和翻译
scripts/build-local.sh      本地 Docker/SDK 编译脚本
.github/workflows/          GitHub Actions
UPSTREAM.md                 上游版本、commit、哈希和许可证
```

## 许可证

本仓库的构建脚本、workflow 和文档使用 MIT 许可证。

- `v2raya`（service + Web UI）：AGPL-3.0-only
- `v2raya-core`：MPL-2.0
- `luci-app-v2raya`：Apache-2.0

上游源码：

- https://github.com/v2rayA/v2rayA/tree/v2.5.10
- https://github.com/immortalwrt/luci/tree/master/applications/luci-app-v2raya
