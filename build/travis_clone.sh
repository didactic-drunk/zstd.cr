#!/bin/bash

set -e

if [ ! -f zstd.git ]; then
	git clone --branch=master https://github.com/facebook/zstd.git
fi

cd zstd/lib
git pull
make clean && make && sudo make install
