#!/bin/sh

set -e

. ../../common.sh

echo "*** GET E2FSPROGS BEGIN ***"

E2FSPROGS_SOURCE_URL=`read_property E2FSPROGS_SOURCE_URL`
ZEROFREE_SOURCE_URL=`read_property ZEROFREE_SOURCE_URL`
SHA256SUMS="$(realpath SHA256SUMS)"

echo "Clean zerofree work area."
rm -rf $WORK_DIR/overlay/$BUNDLE_NAME
mkdir $WORK_DIR/overlay/$BUNDLE_NAME

cd $MAIN_SRC_DIR/source/overlay

E2FSPROGS_SOURCE="$(basename $E2FSPROGS_SOURCE_URL)"
if ! grep $E2FSPROGS_SOURCE $SHA256SUMS | sha256sum -c -
then
    echo "Downloading e2fsprogs sources from $E2FSPROGS_SOURCE_URL"
    wget -O $E2FSPROGS_SOURCE $E2FSPROGS_SOURCE_URL
    if ! grep $E2FSPROGS_SOURCE $SHA256SUMS | sha256sum -c -
    then
        echo "Bad checksum for $E2FSPROGS_SOURCE"
        exit 1
    fi
fi

echo "Extract e2fsprogs sources."
tar -xvf $E2FSPROGS_SOURCE -C $WORK_DIR/overlay/$BUNDLE_NAME

ZEROFREE_SOURCE="$(basename $ZEROFREE_SOURCE_URL)"
if ! grep $ZEROFREE_SOURCE $SHA256SUMS | sha256sum -c -
then
    echo "Downloading e2fsprogs sources from $ZEROFREE_SOURCE_URL"
    wget -O $ZEROFREE_SOURCE $ZEROFREE_SOURCE_URL
    if ! grep $ZEROFREE_SOURCE $SHA256SUMS | sha256sum -c -
    then
        echo "Bad checksum for $ZEROFREE_SOURCE"
        exit 1
    fi
fi

echo "Extract zerofree sources."
tar -xvf $ZEROFREE_SOURCE -C $WORK_DIR/overlay/$BUNDLE_NAME

# We go back to the main MLL source folder.
cd $SRC_DIR

echo "*** GET E2FSPROGS END ***"
