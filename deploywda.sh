#!/bin/sh
#set -x
HOST=root@qos.wnam.ru
URLPRE=http://packages.wnam.ru
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
PKGS=./bin/packages/*
PKG=./bin/targets/$TARGET/$SUBTARGET/packages/*
FW=./bin/targets/$TARGET/$SUBTARGET/openwrt*$PROFILE*

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



FIND=*target-${ARCH}_${CONFIG_CPU_TYPE}*${VERSION}*/bin/wda
WDA=$(find ./build_dir -path "$FIND" | grep "$VERSION" | head -1)
[ -z "$WDA" ] && echo wda binary not found && exit 1
SHA256=$(./staging_dir/host/bin/mkhash -N sha256 $WDA)
#echo $WDA $SHA256

FINDWDAIPK=*bin/packages/${ARCH_PACKAGES}/wda/wda*$VERSION*.ipk
WDAIPK=$(find ./bin/packages -path "${FINDWDAIPK}" | head -1)
WDAIPKBN=$(basename $WDAIPK)
[ ! -e "$WDAIPK" ] && echo wda.ipk not found && exit 1
SHA256IPK=$(./staging_dir/host/bin/mkhash -N sha256 $WDAIPK)
#echo $WDAIPK $SHA256IPK

#WDA BIN
ssh $HOST "mkdir -p $DST/wda"
scp $WDA $HOST:$DST/wda/wda
ssh $HOST "[ -e \"$DST/wda/${MODEL}_${VERSION}_wda\" ] && rm -f $DST/wda/${MODEL}_${VERSION}_wda"
ssh $HOST "cp ${DST}/wda/wda ${DST}/wda/${MODEL}_${VERSION}_wda"
ssh $HOST "echo $SHA256 > $DST/wda/${MODEL}_${VERSION}_wda.sha256"
ssh $HOST "echo $SHA256 > $DST/wda/wda.sha256"

#WDA IPK
D_WDAIPK=$DST/packages/wda
P_WDAIPK=${D_WDAIPK}/${WDAIPKBN}
FMT=${MODEL}_${VERSION}_wda.ipk
scp $WDAIPK $HOST:${P_WDAIPK}
ssh $HOST "[ -e \"${D_WDAIPK}/${FMT}\" ] || [ -L \"${D_WDAIPK}/${FMT}\" ] && rm -f ${D_WDAIPK}/${FMT}"
ssh $HOST "[ -e \"${P_WDAIPK}\" ] && ln -s -r ${P_WDAIPK} ${D_WDAIPK}/${FMT}"
ssh $HOST "[ -e \"${D_WDAIPK}/${FMT}\" ] && echo ${SHA256IPK} > ${D_WDAIPK}/${FMT}.sha256"
#ECHO
echo ${URLPRE}/$URL/packages/wda/${FMT}
echo ${URLPRE}/$URL/packages/wda/${FMT}.sha256
echo ${URLPRE}/$URL/wda/${MODEL}_${VERSION}_wda
echo ${URLPRE}/$URL/wda/wda
