#!/bin/sh
set -eu

# Build the v2raya APKs for one OpenWrt 25.12 architecture.
#
# Usage:
#   ./scripts/build-local.sh [arch] [sdk-dir]
#
#   arch      package architecture, default x86_64
#   sdk-dir   optional extracted OpenWrt 25.12.6 SDK directory
#
# Without sdk-dir the script uses the official SDK container
# openwrt/sdk:<arch>-25.12.6. Architecture-specific APKs go to
# dist/<arch>/; the architecture-independent LuCI packages built on
# x86_64 go to dist/all/.
#
# With sdk-dir it uses that SDK tree directly.

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
ARCH=${1:-x86_64}
SDK_DIR=${2:-${SDK_DIR:-}}
VERSION=25.12.6
OUT="$ROOT/dist/$ARCH"
OUT_ALL="$ROOT/dist/all"

PACKAGES="v2raya-core v2raya"
if [ "$ARCH" = "x86_64" ]; then
	PACKAGES="$PACKAGES luci-app-v2raya"
fi

mkdir -p "$OUT" "$OUT_ALL"

feed_setup='
	set -eu
	[ -f feeds.conf ] || cp feeds.conf.default feeds.conf
	grep -q "src-link custom /work" feeds.conf 2>/dev/null ||
		echo "src-link custom /work" >> feeds.conf
	./scripts/feeds update -a
	make defconfig
	./scripts/feeds install -p custom -f $PACKAGES
	for pkg in $PACKAGES; do
		make package/$pkg/compile V=s
	done
	for f in bin/packages/$ARCH/custom/*.apk; do
		[ -e "$f" ] || continue
		case "$(basename "$f")" in
			luci-*) cp "$f" /out-all/ ;;
			*) cp "$f" /out/ ;;
		esac
	done
'

if [ -n "$SDK_DIR" ]; then
	cd "$SDK_DIR"
	[ -f feeds.conf ] || cp feeds.conf.default feeds.conf
	grep -q "src-link custom $ROOT" feeds.conf 2>/dev/null ||
		echo "src-link custom $ROOT" >> feeds.conf
	./scripts/feeds update -a
	make defconfig
	./scripts/feeds install -p custom -f $PACKAGES
	for pkg in $PACKAGES; do
		make package/$pkg/compile V=s
	done
	for f in bin/packages/"$ARCH"/custom/*.apk; do
		[ -e "$f" ] || continue
		case "$(basename "$f")" in
			luci-*) cp "$f" "$OUT_ALL"/ ;;
			*) cp "$f" "$OUT"/ ;;
		esac
	done
else
	docker run --rm \
		-e ARCH="$ARCH" \
		-e PACKAGES="$PACKAGES" \
		-v "$ROOT:/work:ro" \
		-v "$OUT:/out" \
		-v "$OUT_ALL:/out-all" \
		-w /builder \
		"openwrt/sdk:${ARCH}-${VERSION}" \
		sh -lc "$feed_setup"
fi

echo "APKs written to $OUT"
ls -l "$OUT"
if [ "$ARCH" = "x86_64" ]; then
	echo "Architecture-independent APKs written to $OUT_ALL"
	ls -l "$OUT_ALL"
fi
