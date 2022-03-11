#!/bin/bash

set -e

# Shard directory passed as first argument when called from lib.cr
[ ! -z "$1" ] && cd "$1"

./build/zstd_install.sh > zstd_install.out 2>&1 || (cat zstd_install.out >&2 ; exit 2)

. ./build/env.sh


# ** HACK **
#
# In an ideal world the following two lines wouldn't be needed
# and a regular `pkg-config libzstd --libs` would do all we need.
#
# Unfortunately we don't live in such a world and the above
# doesn't work on systems where an older version of libzstd.so
# is installed in a path that the linker prefers over the -L flag
# that `pkg-config` emits (such as `/usr/lib/x86_64-linux-gnu/`).
#
# Since this is the case on widely popular distros such as the
# current LTS version of Ubuntu (Bionic Beaver) and since the
# system zstd can often neither be upgraded nor removed without
# a full distro upgrade, we apply the following hack here that
# forces the linker to prefer our custom library path.
lpath=$(pkg-config libzstd --libs-only-L | cut -c 3-)
echo "-L${lpath} -Wl,-rpath,${lpath} -lzstd"

# Caveat emptor:
# * This doesn't work on OSX. `brew install zstd` remains a prerequisite.
# * I have no idea what it does on Windows.


