#!/bin/bash -x

CHIPSET_NAME=lahaina
#VARIANT=$1
#VERSION=$2

rm -rf out

ccache -M 4.5

export ARCH=arm64

make mrproper

mkdir -p out

DTS_DIR=$(pwd)/out/arch/$ARCH/boot/dts
rm -f ${DTS_DIR}/vendor/qcom/*.dtb ${DTBO_FILES}

export CLANG_PATH=$(pwd)/toolchain/clang-r377782b/bin
export PATH=${CLANG_PATH}:${PATH}
export CROSS_COMPILE=aarch64-linux-gnu-

#KERNEL_MAKE_ENV="ARCH=arm64 DTC_EXT=$(pwd)/tools/dtc"

make -j$(nproc) -C $(pwd) O=$(pwd)/out LLVM=1 jimbok_defconfig

make -j$(nproc) -C $(pwd) O=$(pwd)/out LLVM=1

#cp $(pwd)/out/arch/$ARCH/boot/Image.gz $(pwd)/out/Image.gz
#cp $(pwd)/out/arch/$ARCH/boot/Image.gz-dtb $(pwd)/out/Image.gz-dtb

cp $(pwd)/out/arch/$ARCH/boot/Image $(pwd)/out/Image
cat ${DTS_DIR}/vendor/qcom/*.dtb > $(pwd)/out/dtb.img
