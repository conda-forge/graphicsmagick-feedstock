#!/usr/bin/env bash
set -ex

# Re-configure with the ImageMagick compatibility shortcuts enabled.
# Only Makefiles change, so this mostly reuses the existing objects.
# We did it this way instead of just linking the binaries to avoid,
# to be compatibility with future changes upstream
./configure --prefix=$PREFIX \
    --enable-shared \
    --enable-symbol-prefix \
    --disable-dependency-tracking \
    --enable-magick-compat
make -j${CPU_COUNT}

# Install into a staging dir so we don't clobber files owned by the
# graphicsmagick package, then copy over only the compat symlinks.
STAGE="${SRC_DIR}/_compat_stage"
rm -rf "${STAGE}"
make install DESTDIR="${STAGE}"

mkdir -p "${PREFIX}/bin"
for name in animate compare composite conjure convert display identify import mogrify montage; do
    if [[ ! -L "${STAGE}${PREFIX}/bin/${name}" ]]; then
        echo "ERROR: expected compat symlink ${name} not found" >&2
        exit 1
    fi
    cp -P "${STAGE}${PREFIX}/bin/${name}" "${PREFIX}/bin/"
done

rm -rf "${STAGE}"
