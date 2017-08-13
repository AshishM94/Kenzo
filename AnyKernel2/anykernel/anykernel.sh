# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() {
kernel.string=Zetsubou by Ashish94 @ xda-developers
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=kenzo
device.name2=Redmi Note 3
device.name3=kate
device.name4=
device.name5=
} # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel permissions
# set permissions for included ramdisk files
chmod -R 755 $ramdisk


## AnyKernel install
dump_boot;

# begin ramdisk changes

# add zetsubou initialization script
insert_line init.rc "import /init.zetsubou.rc" after "import /init.environ.rc" "import /init.zetsubou.rc";
cp /tmp/init.zetsubou.rc /tmp/anykernel/ramdisk/init.zetsubou.rc
chmod 0750 /tmp/anykernel/ramdisk/init.zetsubou.rc

#add zram to fstab
if [ $(grep -c "zram0" $ramdisk/fstab.qcom) == 0 ]; then
   echo "/dev/block/zram0 none swap defaults zramsize=536870912" >> $ramdisk/fstab.qcom
fi
insert_line init.qcom.rc "swapon_all fstab.qcom" after "mount_all fstab.qcom" "    swapon_all fstab.qcom";

#set zen as default io scheduler
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"zen\"";

#fstab lazytime support
patch_fstab fstab.qcom /system ext4 options "ro,barrier=1,discard wait" "ro,lazytime,barrier=1,discard wait"
patch_fstab fstab.qcom /data f2fs options "nosuid,nodev,noatime,inline_xattr,data_flush wait,check,encryptable=footer,formattable,length=-16384" "nosuid,nodev,lazytime,inline_xattr,data_flush wait,check,encryptable=footer,formattable,length=-16384"
patch_fstab fstab.qcom /data ext4 options "nosuid,nodev,noatime,barrier=1,noauto_da_alloc wait,check,encryptable=footer,formattable,length=-16384" "nosuid,nodev,lazytime,barrier=1,noauto_da_alloc wait,check,encryptable=footer,formattable,length=-16384"
patch_fstab fstab.qcom /cache f2fs options "nosuid,nodev,noatime,inline_xattr,flush_merge,data_flush wait,check,formattable" "nosuid,nodev,lazytime,inline_xattr,flush_merge,data_flush wait,check,formattable"
patch_fstab fstab.qcom /cache ext4 options "nosuid,nodev,noatime,barrier=1 wait,check,formattable" "nosuid,nodev,lazytime,barrier=1 wait,check,formattable"
patch_fstab fstab.qcom /persist ext4 options "nosuid,nodev,barrier=1 wait" "lazytime,nosuid,nodev,barrier=1 wait"

# end ramdisk changes

write_boot;

## end install

