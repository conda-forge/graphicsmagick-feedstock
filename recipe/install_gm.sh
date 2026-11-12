#!/usr/bin/env bash
set -ex

make install

# WORKAROUND: somehow the build creates a symlink with funny characters.
for i in $(find $PREFIX/lib -maxdepth 1 -lname libxkbcommon.so.0.0.0); do
    echo "$i"
    rm -f "$i"
done
