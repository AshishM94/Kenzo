export ARCH=arm64
export SUBARCH=arm64
make zetsubou_defconfig
cp .config arch/arm64/configs/zetsubou_defconfig
