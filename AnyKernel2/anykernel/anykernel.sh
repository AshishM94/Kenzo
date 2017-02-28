# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# EDIFY properties
kernel.string=Zetsubou by Ashish94 @ xda-developers
do.devicecheck=1
do.modules=0
do.cleanup=1
do.cleanuponabort=0
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
insert_line init.rc "import /init.zetsubou.rc" after "import /init.environ.rc" "import /init.zetsubou.rc";

# Add frandom compatibility
backup_file ueventd.rc;
insert_line ueventd.rc "frandom" after "urandom" "/dev/frandom              0666   root       root\n";
insert_line ueventd.rc "erandom" after "urandom" "/dev/erandom              0666   root       root\n";
backup_file file_contexts;
insert_line file_contexts "frandom" after "urandom" "/dev/frandom		u:object_r:frandom_device:s0\n";
insert_line file_contexts "erandom" after "urandom" "/dev/erandom               u:object_r:erandom_device:s0\n";

#add zram to fstab
if [ $(grep -c "zram0" $ramdisk/fstab.qcom) == 0 ]; then
   echo "/dev/block/zram0 none swap defaults zramsize=536870912" >> $ramdisk/fstab.qcom
fi
insert_line init.qcom.rc "swapon_all fstab.qcom" after "mount_all fstab.qcom" "    swapon_all fstab.qcom";

#set io scheduler
SCHED=`grep selected.0 /tmp/aroma/sched.prop | cut -d '=' -f2`
if [ $SCHED = 1 ]; then
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"noop\"";
elif [ $SCHED = 2 ]; then
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"deadline\"";
elif [ $SCHED = 3 ]; then
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"row\"";
elif [ $SCHED = 4 ]; then
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"sio\"";
elif [ $SCHED = 5 ]; then
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"cfq\"";
elif [ $SCHED = 6 ]; then
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"bfq\"";
elif [ $SCHED = 7 ]; then
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"fiops\"";
elif [ $SCHED = 9 ]; then
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"sioplus\"";
elif [ $SCHED = 10 ]; then
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"tripndroid\"";
elif [ $SCHED = 11 ]; then
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"vr\"";
elif [ $SCHED = 12 ]; then
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"fifo\"";
else
replace_line init.qcom.power.rc "setprop sys.io.scheduler" "    setprop sys.io.scheduler \"zen\"";
fi;

# end ramdisk changes

write_boot;

## end install

