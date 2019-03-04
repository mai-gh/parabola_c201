#!/bin/bash

export BASE_DIR="$(pwd)"
export CARCH='armv7h'
export KARCH='arm'
export CROSS_COMPILE=arm-none-eabi- 
export ARCH=arm


function msg2 {
  echo "$@"
}

function vbutil_kernel {
    "$BASE_DIR"/vboot_reference/build/futility/futility --debug vbutil_kernel $@
}

function modify_config {
    for i in $(egrep 'ROCKCHIP|CROS_|PEGASUS|MOUSE_SYNAPTICS_I2C|RK3288|^CONFIG_SND_SOC=|CONFIG_SND_SOC is not' .config | sed -e "s/^# //g" -e "s/=.*//g" -e "s/ is not set//g"); do 
        echo "$i=y"
        ./scripts/config --file .config --enable $i
    done
}


cd linux-libre

source PKGBUILD
bsdtar -xf linux-libre-$_srcbasever.tar.xz
xz --decompress --keep patch-$_srcbasever-$_srcver.xz

prepare
modify_config
build
_package-chromebook

