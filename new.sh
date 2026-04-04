#!/bin/bash
clear
function compile() 
{
echo ORIGIN KERNEL FOR REALME X7 MAX 5G, CODENAMED - CUPIDA
echo
source ~/.bashrc && source ~/.profile
export LC_ALL=C && export USE_CCACHE=1
ccache -M 100G >/dev/null
export ARCH=arm64
export KBUILD_BUILD_HOST=Archlinux
export KBUILD_BUILD_USER="hzyry2046"
clangbin=clang/bin/clang
gcc64bin=los-4.9-64/bin/aarch64-linux-android-as
gcc32bin=los-4.9-32/bin/arm-linux-androideabi-as
make O=out ARCH=arm64 menuconfig

PATH="${PWD}/clang/bin:${PATH}:${PWD}/los-4.9-32/bin:${PATH}:${PWD}/los-4.9-64/bin:${PATH}" \
make -j$(nproc --all)   O=out \
                        ARCH=arm64 \
                        CC="clang" \
                        CLANG_TRIPLE=aarch64-linux-gnu- \
                        CROSS_COMPILE="${PWD}/los-4.9-64/bin/aarch64-linux-android-" \
                        CROSS_COMPILE_ARM32="${PWD}/los-4.9-32/bin/arm-linux-androideabi-" \
                        LD=ld.lld \
                        AS=llvm-as \
                        AR=llvm-ar \
                        NM=llvm-nm \
                        LLVM_IAS=1 \
                        OBJCOPY=llvm-objcopy \
                        CONFIG_NO_ERROR_ON_MISMATCH=y
}

function zupload()
{
zimage=out/arch/arm64/boot/Image.gz-dtb
if ! [ -a $zimage ];
then
echo  " Failed to compile zImage, fix the errors first "
else
echo -e " Build succesful, generating flashable zip now "
anykernelbin=AnyKernel/anykernel.sh
if ! [ -a $anykernelbin ]; then git clone --depth=1 https://github.com/nishant6342/AnyKernel3 -b cupida  AnyKernel
fi
cp out/arch/arm64/boot/Image.gz-dtb AnyKernel
cd AnyKernel
zip -r9 ORIGIN-OSS-KERNEL-RMX3031.zip *
cd ../
fi
}

compile
zupload
