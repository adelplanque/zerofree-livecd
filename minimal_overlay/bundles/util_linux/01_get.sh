#!/bin/sh

set -e

. ../../common.sh

echo "*** GET UTIL-LINUX BEGIN ***"

UTIL_LINUX_SOURCE_URL=`read_property UTIL_LINUX_SOURCE_URL`
SHA256SUMS="$(realpath SHA256SUMS)"

echo "Clean zerofree work area."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME
mkdir $WORK_DIR/overlay/$BUNDLE_NAME

cd $MAIN_SRC_DIR/source/overlay

UTIL_LINUX_SOURCE="$(basename $UTIL_LINUX_SOURCE_URL)"
if ! grep $UTIL_LINUX_SOURCE $SHA256SUMS | sha256sum -c -
then
    echo "Downloading util-linux sources from $UTIL_LINUX_SOURCE_URL"
    wget -O $UTIL_LINUX_SOURCE $UTIL_LINUX_SOURCE_URL
    if ! grep $UTIL_LINUX_SOURCE $SHA256SUMS | sha256sum -c -
    then
        echo "Bad checksum for $UTIL_LINUX_SOURCE"
        exit 1
    fi
fi

echo "Extract util-linux sources."
tar -xvf $UTIL_LINUX_SOURCE -C $WORK_DIR/overlay/$BUNDLE_NAME

# We go back to the main MLL source folder.
cd $SRC_DIR

echo "*** GET UTIL_LINUX END ***"
