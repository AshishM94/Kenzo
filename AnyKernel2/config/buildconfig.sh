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
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 400000" >> $CONFIGFILE
echo "#a72 min" >> $CONFIGFILE
echo "chown system system /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq" >> $CONFIGFILE
echo "chmod 0664 /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq" >> $CONFIGFILE
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 400000" >> $CONFIGFILE
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

echo "#Display & Sound" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"223 223 255"\" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 271" >> $CONFIGFILE
echo "write /sys/kernel/sound_control/headphone_pa_gain \"5 5"\" >> $CONFIGFILE
echo "write /sys/kernel/sound_control/speaker_gain 18" >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "#set Swappiness" >> $CONFIGFILE
echo "write /proc/sys/vm/swappiness 0" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#enable laptop mode" >> $CONFIGFILE
echo "write /proc/sys/vm/laptop_mode 1" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#disable touchboost" >> $CONFIGFILE
echo "write /sys/module/msm_performance/parameters/touchboost 0" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#little-cluster input boost" >> $CONFIGFILE
echo "write /sys/module/cpu_boost/parameters/input_boost_freq \"0:1190400 1:1190400 2:1190400 3:1190400 4:0 5:0"\" >> $CONFIGFILE
echo "write /sys/module/cpu_boost/parameters/input_boost_ms 1000" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#disable core control and enable msm thermal" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/core_control/enabled 0" >> $CONFIGFILE
echo "write /sys/module/msm_thermal/parameters/enabled Y" >> $CONFIGFILE
echo "" >> $CONFIGFILE

echo "#Enabling QC2.0. It can charge up-to 3A depending on the charger" >> $CONFIGFILE
echo "write /sys/module/qpnp_smbcharger/parameters/default_dcp_icl_ma 3000" >> $CONFIGFILE
echo "write /sys/module/qpnp_smbcharger/parameters/default_hvdcp_icl_ma 3000" >> $CONFIGFILE
echo "write /sys/module/qpnp_smbcharger/parameters/default_hvdcp3_icl_ma 3000" >> $CONFIGFILE
