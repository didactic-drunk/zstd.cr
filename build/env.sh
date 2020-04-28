#!/bin/sh

# Overridable.
[ -z "$ZSTD_BUILD_DIR" ] && ZSTD_BUILD_DIR=`pwd`/build

# Minimum required zstd version.
# If this is not found on the system we
# automatically install CUR_ZSTD_VERSION.
export MIN_ZSTD_VERSION=1.4.0

# This version gets installed if the
# system zstd is too old or missing.
export CUR_ZSTD_VERSION=1.4.4
export CUR_ZSTD_SHA256=59ef70ebb757ffe74a7b3fe9c305e2ba3350021a918d168a046c6300aeea9315

[ ! -z "$ZSTD_BUILD_DEBUG" ] && export ZSTD_BUILD_VERBOSE=1

function version { echo "$@" | awk -F. '{ printf("%d%03d%03d%03d\n", $1,$2,$3,$4); }'; }

if `pkg-config libzstd --exists`; then
	PKG_VER=`pkg-config libzstd --modversion`

	if [ $(version "$PKG_VER") -ge $(version "$MIN_ZSTD_VERSION") ]; then
		[ ! -z "$ZSTD_BUILD_VERBOSE" ] && echo "Using packaged zstd."
	else
		[ ! -z "$ZSTD_BUILD_VERBOSE" ] echo "System packaged zstd is too old."
		export ZSTD_INSTALL=1
	fi
else
	[ ! -z "$ZSTD_BUILD_VERBOSE" ] && echo "Missing zstd system package."
	export ZSTD_INSTALL=1
fi


if [ "$ZSTD_INSTALL" = "1" ]; then
	export ZSTD_INSTALL_PATH="$ZSTD_BUILD_DIR"/zstd
	export PKG_CONFIG_PATH="$ZSTD_INSTALL_PATH"/lib/pkgconfig
fi
