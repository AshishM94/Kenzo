KERNEL_DIR=$PWD
ZIP_DIR=$KERNEL_DIR/AnyKernel2/META-INF/com/google/android/aroma
echo -n "enter date in yyyy-mm-dd format: "
read date
git log --pretty=format:"%h - %an, %ar : %s" --since="$date" > $ZIP_DIR/changelog.txt
