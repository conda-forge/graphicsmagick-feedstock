#!/usr/bin/env bash
set -ex
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./TclMagick/unix/config
cp $BUILD_PREFIX/share/gnuconfig/config.* ./config

./configure --prefix=$PREFIX --enable-shared --enable-symbol-prefix --disable-dependency-tracking
make -j${CPU_COUNT}
