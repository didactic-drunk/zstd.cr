#!/bin/bash

set -e

cd $HOME

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
