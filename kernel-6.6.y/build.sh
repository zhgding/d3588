#!/bin/bash

set -xe

# set config
if [ -f liontron-d3588_defconfig ]; then
  cp -a liontron-d3588_defconfig ./arch/arm64/configs/liontron-d3588_defconfig
fi

make ARCH=arm64 \
  CROSS_COMPILE=aarch64-linux-gnu- \
  KBUILD_BUILD_USER="builder" \
  KBUILD_BUILD_HOST="kdevbuilder" \
  liontron-d3588_defconfig

# check kver
KVER=$(make kernelrelease)
KVER="${KVER/kdev*/kdev}"
if [[ "$KVER" != *kdev ]]; then
  echo "ERROR: KVER does not end with 'kdev'"
  exit 1
fi
echo "KVER: ${KVER}"

# build dtb
#dtc -I dts -O dtb d3588.dts -o d3588.dtb

# build kernel
make ARCH=arm64 \
  CROSS_COMPILE=aarch64-linux-gnu- \
  KBUILD_BUILD_USER="builder" \
  KBUILD_BUILD_HOST="kdevbuilder" \
  -j$(nproc)

# build modules
make ARCH=arm64 \
  CROSS_COMPILE=aarch64-linux-gnu- \
  KBUILD_BUILD_USER="builder" \
  KBUILD_BUILD_HOST="kdevbuilder" \
  modules -j$(nproc)

echo "All done!"
