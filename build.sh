 #
 # Copyright © 2016, Varun Chitre "varun.chitre15" <varun.chitre15@gmail.com>
 #
 # Custom build script
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # Please maintain this if you use this script or any part of it
 #
KERNEL_DIR=$PWD
ZIP_DIR=$KERNEL_DIR/AnyKernel2
KERN_IMG=$KERNEL_DIR/arch/arm64/boot/Image
DT_IMG=$KERNEL_DIR/arch/arm64/boot/dt.img
DTBTOOL=$KERNEL_DIR/tools/dtbToolCM
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
# Modify the following variable if you want to build
export CROSS_COMPILE="/home/saiko94/x-tools/aarch64-unknown-linux-gnueabi/bin/aarch64-unknown-linux-gnueabi-"
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER="ashish.m"
export KBUILD_BUILD_HOST="DespairInc."

compile_kernel ()
{
echo -e "$blue***********************************************"
echo "          Compiling Kenzo kernel          "
echo -e "***********************************************$nocol"
rm -f $KERN_IMG
make cyanogenmod_kenzo_defconfig -j5
make Image -j5
make dtbs -j5
if ! [ -a $KERN_IMG ];
then
echo -e "$red Kernel Compilation failed! Fix the errors! $nocol"
exit 1
fi
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
}

case $1 in
clean)
make ARCH=arm64 -j5 clean mrproper
rm -rf $KERNEL_DIR/arch/arm/boot/dt.img
;;
dt)
make cyanogenmod_kenzo_defconfig -j5
make dtbs -j5
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
;;
*)
compile_kernel
;;
esac
echo -e "$blue***********************************************"
echo "          creating flashable zip          "
echo -e "***********************************************$nocol"
cd $ZIP_DIR
make clean
cp $DT_IMG $ZIP_DIR/dtb
cp $KERN_IMG $ZIP_DIR/zImage
make
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nocol"
