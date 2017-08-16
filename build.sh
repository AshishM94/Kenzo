#!/bin/bash
#
# Zetsubou Kernel build script
#
# Copyright (C) 2017 Ashish Malik (im.ashish994@gmail.com)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

#colors
black='\033[0;30m'
red='\033[0;31m'
green='\033[0;32m'
brown='\033[0;33m'
blue='\033[0;34m'
purple='\033[1;35m'
cyan='\033[0;36m'
nc='\033[0m'

#directories
KERNEL_DIR=$PWD
KERN_IMG=$KERNEL_DIR/arch/arm64/boot/Image.gz-dtb
ZIP_DIR=$KERNEL_DIR/AnyKernel2
LOG_DIR=$ZIP_DIR/META-INF/com/google/android/aroma
CONFIG_DIR=$KERNEL_DIR/arch/arm64/configs

#export
export CROSS_COMPILE="$HOME/kernel/aarch64-linux-android-6.x/bin/aarch64-linux-android-"
export ARCH=arm64
export SUBARCH=arm64
export KBUILD_BUILD_USER=$(uname -n)
export KBUILD_BUILD_HOST=$(uname -r)

#misc
CONFIG=zetsubou_defconfig
THREAD="-j$(grep -c ^processor /proc/cpuinfo)"

#ASCII art
echo -e "$cyan############################ WELCOME TO ##############################"
echo -e "         _             _                   _                        _" 
echo -e "        | |           | |                 | |                      | |"
echo -e " _______| |_ ___ _   _| |__   ___  _   _  | | _____ _ __ _ __   ___| |"
echo -e "|_  / _ \ __/ __| | | | '_ \ / _ \| | | | | |/ / _ \ '__| '_ \ / _ \ |"
echo -e " / /  __/ |_\__ \ |_| | |_) | (_) | |_| | |   <  __/ |  | | | |  __/ |"
echo -e "/___\___|\__|___/\__,_|_.__/ \___/ \__,_| |_|\_\___|_|  |_| |_|\___|_|"
                                                                                                                                      echo -e "\n############################# BUILDER ################################$nc"

#main script
while true; do
echo -e "\n$green[1]Build kernel"
echo -e "[2]Regenerate defconfig"
echo -e "[3]Source cleanup"
echo -e "[4]Generate change-log"
echo -e "[5]Generate flashable zip"
echo -e "[6]Quit$nc"
echo -ne "\n$blue(i)Please enter a choice[1-6]:$nc "

read choice

if [ "$choice" == "1" ]; then
  BUILD_START=$(date +"%s")
  DATE=`date`
  echo -e "\n$cyan#######################################################################$nc"
  echo -e "$brown(i)Build started at $DATE$nc"
  make $CONFIG $THREAD &>/dev/null
  make $THREAD &>buildlog.txt & pid=$!
  spin[0]="$blue-"
  spin[1]="\\"
  spin[2]="|"
  spin[3]="/$nc"

  echo -ne "$blue[Please wait...] ${spin[0]}$nc"
  while kill -0 $pid &>/dev/null
  do
    for i in "${spin[@]}"
    do
          echo -ne "\b$i"
          sleep 0.1
    done
  done
  if ! [ -a $KERN_IMG ]; then
    echo -e "\n$red(!)Kernel compilation failed, See buildlog to fix errors $nc"
    echo -e "$red#######################################################################$nc"
    exit 1
  fi
  BUILD_END=$(date +"%s")
  DIFF=$(($BUILD_END - $BUILD_START))
  echo -e "\n$brown(i)Kernel compiled successfully.$nc"
  echo -e "$cyan#######################################################################$nc"
  echo -e "$purple(i)Total time elapsed: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds.$nc"
  echo -e "$cyan#######################################################################$nc"
fi


if [ "$choice" == "2" ]; then
  echo -e "\n$cyan#######################################################################$nc"
  make $CONFIG
  cp .config arch/arm64/configs/$CONFIG
  echo -e "$purple(i)Defconfig generated.$nc"
  echo -e "$cyan#######################################################################$nc"
fi


if [ "$choice" == "3" ]; then
  echo -e "\n$cyan#######################################################################$nc"
  rm -f $KERN_IMG
  make clean &>/dev/null
  make mrproper &>/dev/null
  echo -e "$purple(i)Kernel source cleaned up.$nc"
  echo -e "$cyan#######################################################################$nc"
fi


if [ "$choice" == "4" ]; then
  echo -e "\n$cyan#######################################################################$nc"
  echo -ne "$brown Enter starting date in yyyy-mm-dd format:$nc "
  read date
  git log --pretty=format:"%h - %an : %s" --since="$date" > $LOG_DIR/changelog.txt
  echo -e "$purple(i)Change-log generated."
  echo -e "$cyan#######################################################################$nc"
fi


if [ "$choice" == "5" ]; then
  echo -e "\n$cyan#######################################################################$nc"
  cd $ZIP_DIR
  make clean &>/dev/null
  cp $KERN_IMG $ZIP_DIR/anykernel
  make &>/dev/null
  make sign &>/dev/null
  cd ..
  echo -e "$purple(i)Flashable zip generated under $ZIP_DIR.$nc"
  echo -e "$cyan#######################################################################$nc"
fi


if [ "$choice" == "6" ]; then
 exit 1
fi
done
