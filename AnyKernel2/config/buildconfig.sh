#!/sbin/sh

#Build config file
CONFIGFILE="/tmp/anykernel/ramdisk/init.zetsubou.rc"

echo "on post-fs" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#cpuset" >> $CONFIGFILE
echo "write /dev/cpuset/foreground/cpus 0-5" >> $CONFIGFILE
echo "write /dev/cpuset/foreground/boost/cpus 0-5" >> $CONFIGFILE
echo "write /dev/cpuset/background/cpus 0-5" >> $CONFIGFILE
echo "write /dev/cpuset/system-background/cpus 0-5" >> $CONFIGFILE

echo "" >> $CONFIGFILE
echo "#Force kernel read only 1 page at a time" >> $CONFIGFILE
echo "write /proc/sys/vm/page-cluster 0" >> $CONFIGFILE

echo "" >> $CONFIGFILE
echo "on boot" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#S2W" >> $CONFIGFILE
echo "write /sys/android_touch/sweep2wake  4" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#DT2W" >> $CONFIGFILE
echo "write /sys/android_touch/doubletap2wake  0" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#S2S" >> $CONFIGFILE
echo "write /sys/android_touch/sweep2sleep 3" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "on property:sys.boot_completed=1" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#cpuset" >> $CONFIGFILE
echo "write /dev/cpuset/foreground/cpus 0-2,4-5" >> $CONFIGFILE
echo "write /dev/cpuset/foreground/boost/cpus 4-5" >> $CONFIGFILE
echo "write /dev/cpuset/background/cpus 0-2" >> $CONFIGFILE
echo "write /dev/cpuset/system-background/cpus 0-2" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#set I/O scheduler" >> $CONFIGFILE
echo "write /sys/block/mmcblk0/queue/rq_affinity 0" >> $CONFIGFILE
echo "write /sys/block/mmcblk0/bdi/min_ratio 5" >> $CONFIGFILE
echo "write /sys/block/mmcblk0/queue/read_ahead_kb 256" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#set min frequencies for both clusters" >> $CONFIGFILE
echo "#a53 min" >> $CONFIGFILE
echo "chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq" >> $CONFIGFILE
echo "chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 400000" >> $CONFIGFILE
echo "#a72 min" >> $CONFIGFILE
echo "chown system system /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq" >> $CONFIGFILE
echo "chmod 0664 /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 400000" >> $CONFIGFILE
echo "#set max frequencies for both clusters" >> $CONFIGFILE
echo "#a53 max" >> $CONFIGFILE
echo "chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq" >> $CONFIGFILE
echo "chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1401600" >> $CONFIGFILE
echo "#a72 max" >> $CONFIGFILE
echo "chown system system /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq" >> $CONFIGFILE
echo "chmod 0664 /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 1804800" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#adreno-boost" >> $CONFIGFILE
echo "write /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost 1" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "# Set Swappiness" >> $CONFIGFILE
echo "write /proc/sys/vm/swappiness 10" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#enable laptop mode" >> $CONFIGFILE
echo "write /proc/sys/vm/laptop_mode 1" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#disable core control and enable msm thermal" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/core_control/enabled 0" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/parameters/enabled Y" >> $CONFIGFILE
