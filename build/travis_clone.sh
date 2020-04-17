#!/bin/bash

set -x
set -e

cd $HOME

# Sometimes an empty directory is leftover on travis.  Probably from a discarded cache.
rmdir zstd || true

if [ ! -d zstd ]; then
	git clone --single-branch --branch=master https://github.com/facebook/zstd.git
fi

cd zstd/lib

git fetch

if [ `git rev-list HEAD...origin/master --count` != 0 ]; then
	# Only run when changed.
	make clean && make
else
	echo "zstd up to date"
fi

sudo make install
