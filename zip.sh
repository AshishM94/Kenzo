KERNEL_DIR=$PWD
ZIP_DIR=$KERNEL_DIR/AnyKernel2
LOG_DIR=$ZIP_DIR/META-INF/com/google/android/aroma
KERN_IMG=$KERNEL_DIR/arch/arm64/boot/Image
DT_IMG=$KERNEL_DIR/arch/arm64/boot/dt.img
echo -n "enter date in yyyy-mm-dd format to generate change-log: "
read date
git log --pretty=format:"%h - %an, %ar : %s" --since="$date" > $LOG_DIR/changelog.txt
cd $ZIP_DIR
make clean
cp $DT_IMG $ZIP_DIR/anykernel/dtb
cp $KERN_IMG $ZIP_DIR/anykernel/zImage
make
make sign
