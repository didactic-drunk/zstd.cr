#!/bin/bash
# The purpose of this file is to install zstd when:
# 1. No packaged version is found.
# 2. The packaged version is older than the version specified in this repository.
# pkg-config is used to find the library and determine it's version.
# You may replace the zstd library with your own installed version by setting PKG_CONFIG_PATH before compiling.

set -e

# Always use bash.  `dash` doesn't work properly with . includes.  I'm not sure why.
. ./build/env.sh

#export ZSTD_INSTALL="1"
if [ "$ZSTD_INSTALL" != "1" ]; then
	[ ! -z "$ZSTD_BUILD_VERBOSE" ] && echo "Skipping zstd build."
	exit 0
fi


mkdir -p "$ZSTD_BUILD_DIR"
cd "$ZSTD_BUILD_DIR"

if [ ! -f "$ZSTD_INSTALL_PATH/include/zstd.h" ]; then
	[ ! -z "$ZSTD_BUILD_DEBUG" ] && set -x

	DIRNAME=zstd-"$CUR_ZSTD_VERSION"
	TGZ_FILENAME="$DIRNAME".tar.gz

	if [ ! -f "$TGZ_FILENAME" ]; then
		wget https://github.com/facebook/zstd/releases/download/v"$CUR_ZSTD_VERSION"/"$TGZ_FILENAME"
	fi

	SHA=`openssl sha256 -hex < "$TGZ_FILENAME" | sed 's/^.* //'`
	if [ "$SHA" != "$CUR_ZSTD_SHA256" ]; then
		echo "SHA256 sum doesn't match."
		echo "$SHA" != "$CUR_ZSTD_SHA256"
		exit 1
	fi

	if [ ! -d "$DIRNAME" ]; then
		tar xfz "$TGZ_FILENAME"
	fi


	cd "$DIRNAME"
	if [ ! -f ".make.done" ]; then
		make
		touch .make.done
	fi
	if [ ! -f ".make.install.done" ]; then
		make install PREFIX="$ZSTD_INSTALL_PATH"
		touch .make.install.done
	fi

	[ ! -z "$ZSTD_BUILD_VERBOSE" ] && echo "Finished building zstd."
else
#	find "$ZSTD_INSTALL_PATH"

	[ ! -z "$ZSTD_BUILD_VERBOSE" ] && echo "Using already built zstd."
fi

exit 0
