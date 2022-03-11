#!/bin/sh

# Overridable.
[ -z "$ZSTD_BUILD_DIR" ] && ZSTD_BUILD_DIR=`pwd`/build

# Minimum required zstd version.
# If this is not found on the system we
# automatically install CUR_ZSTD_VERSION.
export MIN_ZSTD_VERSION=1.4.0

# This version gets installed if the
# system zstd is too old or missing.
export CUR_ZSTD_VERSION=1.5.2
export CUR_ZSTD_SHA256=7c42d56fac126929a6a85dbc73ff1db2411d04f104fae9bdea51305663a83fd0

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
	export ZSTD_INSTALL_PATH="$ZSTD_BUILD_DIR/zstd-${CUR_ZSTD_VERSION}-build"
	export PKG_CONFIG_PATH="$ZSTD_INSTALL_PATH"/lib/pkgconfig
fi
