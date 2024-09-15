#!/bin/env bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./TclMagick/unix/config
cp $BUILD_PREFIX/share/gnuconfig/config.* ./config

./configure --prefix=$PREFIX --enable-shared --enable-symbol-prefix --disable-dependency-tracking --with-quantum-depth=16 --disable-static --with-magick-plus-plus=yes
make
make install

# WORKAROUND: somehow the build creates a symlink with funny characters.
for i in $(find $PREFIX/lib -maxdepth 1 -lname libxkbcommon.so.0.0.0); do
    echo "$i"
    rm -f "$i"
done
