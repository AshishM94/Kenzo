# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() {
kernel.string=Spitfire Kernel by AshishM94
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=kenzo
device.name2=kate
device.name3=Redmi Note 3
device.name4=
device.name5=
} # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
chmod -R 750 $ramdisk/*;
chown -R root:root $ramdisk/*;


## AnyKernel install
dump_boot;

# begin ramdisk changes

# add init script
insert_line init.rc "import /init.spitfire.rc" after "import /init.environ.rc" "import /init.spitfire.rc";

#add zram to fstab
if [ $(grep -c "zram0" $ramdisk/fstab.qcom) == 0 ]; then
   echo "/dev/block/zram0 none swap defaults zramsize=536870912" >> $ramdisk/fstab.qcom
fi
insert_line init.qcom.rc "swapon_all fstab.qcom" after "mount_all fstab.qcom" "    swapon_all fstab.qcom";

#set zen as default io scheduler
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"zen\"";

#fstab lazytime support
patch_fstab fstab.qcom /system ext4 options "ro,barrier=1,discard" "ro,lazytime,barrier=1,discard"
patch_fstab fstab.qcom /data f2fs options "nosuid,nodev,noatime,inline_xattr,data_flush" "nosuid,nodev,lazytime,inline_xattr,data_flush"
patch_fstab fstab.qcom /data ext4 options "nosuid,nodev,noatime,barrier=1,noauto_da_alloc" "nosuid,nodev,lazytime,barrier=1,noauto_da_alloc"
patch_fstab fstab.qcom /cache f2fs options "nosuid,nodev,noatime,inline_xattr,flush_merge,data_flush" "nosuid,nodev,lazytime,inline_xattr,flush_merge,data_flush"
patch_fstab fstab.qcom /cache ext4 options "nosuid,nodev,noatime,barrier=1" "nosuid,nodev,lazytime,barrier=1"
patch_fstab fstab.qcom /persist ext4 options "nosuid,nodev,barrier=1" "nosuid,nodev,lazytime,barrier=1"

# end ramdisk changes

write_boot;

## end install

