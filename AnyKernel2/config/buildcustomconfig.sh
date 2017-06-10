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
SR=`grep "item.1.1" /tmp/aroma/gest.prop | cut -d '=' -f2`
SL=`grep "item.1.2" /tmp/aroma/gest.prop | cut -d '=' -f2`
SU=`grep "item.1.3" /tmp/aroma/gest.prop | cut -d '=' -f2`
SD=`grep "item.1.4" /tmp/aroma/gest.prop | cut -d '=' -f2`

if [ $SL = 1 ]; then
  SL=2
fi
if [ $SU == 1 ]; then
  SU=4
fi
if [ $SD == 1 ]; then
  SD=8
fi  

S2W=$(( SL + SR + SU + SD ))
echo "write /sys/android_touch/sweep2wake " $S2W >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "#DT2W" >> $CONFIGFILE
DT2W=`grep "item.1.5" /tmp/aroma/gest.prop | cut -d '=' -f2`
echo "write /sys/android_touch/doubletap2wake " $DT2W >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "#S2S" >> $CONFIGFILE
S2S=`grep selected.0 /tmp/aroma/s2s.prop | cut -d '=' -f2`
if [ $S2S = 2 ]; then
  echo "write /sys/android_touch/sweep2sleep 1" >> $CONFIGFILE
elif [ $S2S = 3 ]; then
  echo "write /sys/android_touch/sweep2sleep 2" >> $CONFIGFILE
elif [ $S2S = 4 ]; then
  echo "write /sys/android_touch/sweep2sleep 3" >> $CONFIGFILE
else
  echo "write /sys/android_touch/sweep2sleep 0" >> $CONFIGFILE
fi

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
cpu0=`grep selected.1 /tmp/aroma/cpu0.prop | cut -d '=' -f2`
if [ $cpu0 = 1 ]; then
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 400000" >> $CONFIGFILE
elif [ $cpu0 = 2 ]; then
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 691200" >> $CONFIGFILE
else
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 806400" >> $CONFIGFILE
fi
#
echo "#a72 min" >> $CONFIGFILE
echo "chown system system /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq" >> $CONFIGFILE
echo "chmod 0664 /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq" >> $CONFIGFILE
cpu4=`grep selected.1 /tmp/aroma/cpu4.prop | cut -d '=' -f2`
if [ $cpu4 = 1 ]; then
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 400000" >> $CONFIGFILE
elif [ $cpu4 = 2 ]; then
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 883200" >> $CONFIGFILE
else
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq 1190400" >> $CONFIGFILE
fi
#
echo "#set max frequencies for both clusters" >> $CONFIGFILE
echo "#a53 max" >> $CONFIGFILE
echo "chown system system /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq" >> $CONFIGFILE
echo "chmod 0664 /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq" >> $CONFIGFILE
cpu0=`grep selected.2 /tmp/aroma/cpu0.prop | cut -d '=' -f2`
if [ $cpu0 = 1 ]; then
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1401600" >> $CONFIGFILE
elif [ $cpu0 = 2 ]; then
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1382400" >> $CONFIGFILE
elif [ $cpu0 = 3 ]; then
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1305600" >> $CONFIGFILE
else
echo "write /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 1190400" >> $CONFIGFILE
fi
#
echo "#a72 max" >> $CONFIGFILE
echo "chown system system /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq" >> $CONFIGFILE
echo "chmod 0664 /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq" >> $CONFIGFILE
cpu4=`grep selected.2 /tmp/aroma/cpu4.prop | cut -d '=' -f2`
if [ $cpu4 = 1 ]; then
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 2035200" >> $CONFIGFILE
elif [ $cpu4 = 2 ]; then
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 1804800" >> $CONFIGFILE
elif [ $cpu4 = 3 ]; then
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 1747200" >> $CONFIGFILE
else
echo "write /sys/devices/system/cpu/cpu4/cpufreq/scaling_max_freq 1612800" >> $CONFIGFILE
fi

echo "" >> $CONFIGFILE

echo "#Adreno Boost" >> $CONFIGFILE
echo "write /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost 1" >> $CONFIGFILE

echo "" >> $CONFIGFILE

echo "#Display & Sound" >> $CONFIGFILE
misc=`grep selected.1 /tmp/aroma/misc.prop | cut -d '=' -f2`
if [ $misc = 2 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"223 223 255"\" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 271" >> $CONFIGFILE
elif [ $misc = 3 ]; then
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"256 256 225"\" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 255" >> $CONFIGFILE
else
echo "write /sys/devices/platform/kcal_ctrl.0/kcal \"256 256 256"\" >> $CONFIGFILE
echo "write /sys/devices/platform/kcal_ctrl.0/kcal_sat 255" >> $CONFIGFILE
fi
misc=`grep selected.2 /tmp/aroma/misc.prop | cut -d '=' -f2`
if [ $misc = 1 ]; then
echo "write /sys/kernel/sound_control/headphone_pa_gain \"5 5"\" >> $CONFIGFILE
else
echo "write /sys/kernel/sound_control/headphone_gain \"6 6"\" >> $CONFIGFILE
fi
misc=`grep selected.3 /tmp/aroma/misc.prop | cut -d '=' -f2`
if [ $misc = 1 ]; then
echo "write /sys/kernel/sound_control/speaker_gain 18" >> $CONFIGFILE
fi

echo "" >> $CONFIGFILE

echo "#swappiness" >> $CONFIGFILE
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
