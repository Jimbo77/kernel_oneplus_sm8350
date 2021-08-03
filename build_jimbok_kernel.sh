#!/bin/bash -x

CHIPSET_NAME=lahaina
OUTPUT_IMAGE=$1
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

cp $(pwd)/out/arch/$ARCH/boot/Image.gz $(pwd)/out/Image.gz
#cp $(pwd)/out/arch/$ARCH/boot/Image.gz-dtb $(pwd)/out/Image.gz-dtb


cat ${DTS_DIR}/vendor/qcom/*.dtb > $(pwd)/out/dtb.img

cp $(pwd)/out/Image.gz ~/build/AnyKernel3
cd ~/build/AnyKernel3; zip -r ../JimboK-$OUTPUT_IMAGE.zip *
cp ~/build/"JimboK-$OUTPUT_IMAGE.zip" ~/Kernel_Test/OnePlus9Pro
