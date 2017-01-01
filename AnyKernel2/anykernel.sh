# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# EDIFY properties
kernel.string=Zetsubou by Ashish94 @ xda-developers
do.devicecheck=1
do.initd=1
do.modules=0
do.cleanup=1
device.name1=kenzo
device.name2=Redmi Note 3
device.name3=
device.name4=
device.name5=

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
#insert_line init.rc "import /init.zetsubou.rc" after "import /init.cm.rc" "import /init.zetsubou.rc";

# fstab default to noatime
#patch_fstab fstab.qcom /data f2fs options "nosuid,nodev,noatime,nodiratime,inline_xattr,data_flush                        wait,check,encryptable=footer,formattable,length=-16384" "nosuid,nodev,noatime,inline_xattr,data_flush                        wait,check,encryptable=footer,formattable,length=-16384"
#patch_fstab fstab.qcom /data ext4 options "nosuid,nodev,noatime,nodiratime,barrier=1,noauto_da_alloc                      wait,check,encryptable=footer,formattable,length=-16384" "nosuid,nodev,noatime,barrier=1,noauto_da_alloc                      wait,check,encryptable=footer,formattable,length=-16384"
#patch_fstab fstab.qcom /cache f2fs options "nosuid,nodev,noatime,nodiratime,inline_xattr,flush_merge,data_flush            wait,check,formattable" "nosuid,nodev,noatime,inline_xattr,flush_merge,data_flush            wait,check,formattable"
#patch_fstab fstab.qcom /cache ext4 options "nosuid,nodev,noatime,nodiratime,barrier=1                                      wait,check,formattable" "nosuid,nodev,noatime,barrier=1                                      wait,check,formattable"

# Add frandom compatibility
#backup_file ueventd.rc;
#insert_line ueventd.rc "frandom" after "urandom" "/dev/frandom              0666   root       root\n";
#insert_line ueventd.rc "erandom" after "urandom" "/dev/erandom              0666   root       root\n";
#backup_file file_contexts;
#insert_line file_contexts "frandom" after "urandom" "/dev/frandom		u:object_r:frandom_device:s0\n";
#insert_line file_contexts "erandom" after "urandom" "/dev/erandom               u:object_r:erandom_device:s0\n";

# end ramdisk changes

write_boot;

## end install

