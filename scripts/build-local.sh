#!/bin/sh
set -eu

# Build the v2raya and v2raya-core APKs for one OpenWrt 25.12 architecture.
#
# Usage:
#   ./scripts/build-local.sh [arch] [sdk-dir]
#
#   arch      package architecture, default x86_64
#   sdk-dir   optional extracted OpenWrt 25.12.6 SDK directory
#
# Without sdk-dir the script uses the official SDK container
# openwrt/sdk:<arch>-25.12.6 and writes the APKs to dist/<arch>/.
# With sdk-dir it uses that SDK tree directly.

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
ARCH=${1:-x86_64}
SDK_DIR=${2:-${SDK_DIR:-}}
VERSION=25.12.6
OUT="$ROOT/dist/$ARCH"

mkdir -p "$OUT"

feed_setup='
	set -eu
	[ -f feeds.conf ] || cp feeds.conf.default feeds.conf
	grep -q "src-link custom /work" feeds.conf 2>/dev/null ||
		echo "src-link custom /work" >> feeds.conf
	./scripts/feeds update -a
	./scripts/feeds install -a
	./scripts/feeds install -p custom -f v2raya-core v2raya
	make defconfig
	make package/v2raya-core/compile V=s
	make package/v2raya/compile V=s
	cp bin/packages/$ARCH/custom/*.apk /out/
'

if [ -n "$SDK_DIR" ]; then
	cd "$SDK_DIR"
	[ -f feeds.conf ] || cp feeds.conf.default feeds.conf
	grep -q "src-link custom $ROOT" feeds.conf 2>/dev/null ||
		echo "src-link custom $ROOT" >> feeds.conf
	./scripts/feeds update -a
	./scripts/feeds install -a
	./scripts/feeds install -p custom -f v2raya-core v2raya
	make defconfig
	make package/v2raya-core/compile V=s
	make package/v2raya/compile V=s
	cp bin/packages/"$ARCH"/custom/*.apk "$OUT"/
else
	docker run --rm \
		-e ARCH="$ARCH" \
		-v "$ROOT:/work:ro" \
		-v "$OUT:/out" \
		-w /builder \
		"openwrt/sdk:${ARCH}-${VERSION}" \
		sh -lc "$feed_setup"
fi

echo "APKs written to $OUT"
ls -l "$OUT"
