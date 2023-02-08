#!/bin/sh
#set -x
HOST=root@qos.wnam.ru
ARCH=$(cat .config | grep -o 'CONFIG_ARCH=.*' | cut -d"=" -f2 | sed 's/\"//g')
ARCH_PACKAGES=$(cat .config | grep -o 'CONFIG_TARGET_ARCH_PACKAGES=.*' | cut -d"=" -f2 | sed 's/\"//g')
TARGET=$(cat .config | grep -o 'CONFIG_TARGET_BOARD=.*' | cut -d"=" -f2 | sed 's/\"//g')
SUBTARGET=$(cat .config | grep -o 'CONFIG_TARGET_SUBTARGET=.*' | cut -d"=" -f2 | sed 's/\"//g')
PROFILE=$(cat .config | grep -o 'CONFIG_TARGET_PROFILE=.*' | cut -d"=" -f2 | sed 's/DEVICE_//g' | sed 's/\"//g')
MODEL=$(echo $PROFILE | cut -d '_' -f 2)
VENDOR=$(echo $PROFILE | cut -d '_' -f 1)
URL=$ARCH/$TARGET/$SUBTARGET/$PROFILE
DST=/var/www/packages/$ARCH/$TARGET/$SUBTARGET/$PROFILE
VERSION=$(cd /sdk1/wda && /sdk1/wda/setver.sh)
echo "         HOST: $HOST"
echo "         ARCH: $ARCH"
echo "ARCH_PACKAGES: $ARCH_PACKAGES"
echo "       TARGET: $TARGET"
echo "    SUBTARGET: $SUBTARGET"
echo "      PROFILE: $PROFILE"
echo "       VENDOR: $VENDOR"
echo "        MODEL: $MODEL"

echo "      VERSION: $VERSION"
echo "          DST: $DST"
echo "          URL: $URL"

#make -j$(nproc)

PKGS=./bin/packages/$ARCH_PACKAGES/*
KMODS=./bin/targets/$TARGET/$SUBTARGET/packages/*
FW=./bin/targets/$TARGET/$SUBTARGET/openwrt*$PROFILE*
SYSUPGRADE=$(find ./bin/targets -path $FW*sysupgrade*)
[ -z "$SYSUPGRADE" ] && echo "fw sysupgrade not found" && exit 1
SYSUPGRADE_BASENAME=$(basename -- $SYSUPGRADE)
SHA256=$(./staging_dir/host/bin/mkhash -N sha256 $SYSUPGRADE)

ssh $HOST "mkdir -p $DST/packages"
ssh $HOST "mkdir -p $DST/packages/kmods"
ssh $HOST "mkdir -p $DST/openwrt"

scp -r $KMODS $HOST:$DST/packages/kmods
scp -r $PKGS $HOST:$DST/packages/
scp $FW $HOST:$DST/openwrt/

ssh $HOST "[ -e \"$DST/openwrt/sysupgrade.bin\" ] && rm -f $DST/openwrt/sysupgrade.bin"
ssh $HOST "[ -e \"$DST/openwrt/sysupgrade.bin\" ] || ln -r -s $DST/openwrt/$SYSUPGRADE_BASENAME $DST/openwrt/sysupgrade.bin"


ssh $HOST "[ -e \"$DST/openwrt/${MODEL}_${VERSION}_sysupgrade.bin\" ] && rm -f $DST/openwrt/${MODEL}_${VERSION}_sysupgrade.bin"
ssh $HOST "[ -e \"$DST/openwrt/${MODEL}_${VERSION}_sysupgrade.bin\" ] || cp    $DST/openwrt/$SYSUPGRADE_BASENAME $DST/openwrt/${MODEL}_${VERSION}_sysupgrade.bin"
ssh $HOST "echo $SHA256 > $DST/openwrt/${MODEL}_${VERSION}_sysupgrade.bin.sha256"
ssh $HOST "echo $SHA256 > $DST/openwrt/sysupgrade.bin.sha256"
