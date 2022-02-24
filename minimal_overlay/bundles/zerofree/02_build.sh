#!/bin/sh

set -e

# Load common properties and functions in the current script.
. ../../common.sh

set -x

echo "Removing old zerofree artifacts."
rm -rf $DEST_DIR

echo "Build e2fsprogs."
E2FSPROGS_SOURCES=$(ls -d $OVERLAY_WORK_DIR/$BUNDLE_NAME/e2fsprogs-*)
cd $E2FSPROGS_SOURCES
./configure                                                    \
    CPPFLAGS="--sysroot=$SYSROOT"                              \
    CFLAGS="$CFLAGS -ffunction-sections -fdata-sections -flto" \
    --enable-libuuid                                           \
    --enable-libblkid                                          \
    --disable-rpath                                            \
    --disable-fuse2fs
make -j $NUM_JOBS

echo "Build zerofree"
ZEROFREE_SOURCES=$(ls -d $OVERLAY_WORK_DIR/$BUNDLE_NAME/zerofree-*)
cd $ZEROFREE_SOURCES
gcc $CFLAGS -pthread -Wl,--gc-sections -flto -I$E2FSPROGS_SOURCES/lib --sysroot=$SYSROOT \
    -o zerofree zerofree.c $E2FSPROGS_SOURCES/lib/libext2fs.a $E2FSPROGS_SOURCES/lib/libcom_err.a
mkdir -p $DEST_DIR/bin
install -m 755 zerofree $DEST_DIR/bin/zerofree
install -D -m 755 $SRC_DIR/zerofree $DEST_DIR/etc/autorun/90_zerofree

echo "Reducing '$BUNDLE_NAME' size."
reduce_size $DEST_DIR/usr/bin

install_to_overlay

cd $SRC_DIR

set +x

echo "*** BUILD E2FSPROGS END ***"
