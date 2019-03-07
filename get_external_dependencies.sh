#!/bin/bash
set -e -x



function printhelp {
    echo ""
    echo "Example Usage: "
    echo "$0 getrootfs"
    echo "$0 getfutility"
    echo "$0 getkernel"
    echo "$0 get all"
    echo ""
}


function getrootfs {
    # get the rootfs tar
    # you can check  https://wiki.parabola.nu/Get_Parabola for newer versions and to verify the gpg key
    wget -c https://repo.parabola.nu/iso/systemd-cli-2018-02-06/parabola-systemd-cli-armv7h-tarball-2018-02-06.tar.gz
    wget -c https://repo.parabola.nu/iso/systemd-cli-2018-02-06/parabola-systemd-cli-armv7h-tarball-2018-02-06.tar.gz.sig
    wget -c https://repo.parabola.nu/iso/systemd-cli-2018-02-06/SHA512SUMS
    sha512sum -c SHA512SUMS
    gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 0x4B745536
    gpg --verify parabola-systemd-cli-armv7h-tarball-2018-02-06.tar.gz.sig
}


function getfutility {
    # we need the futility tool from vboot-utils
    git clone https://chromium.googlesource.com/chromiumos/platform/vboot_reference
    cd vboot_reference
    git checkout 5c904692b5c3279b3258deaf98a65336f62d1df8
    make
    cd ..
}

function getkernel {
    # get the parabola kernel
    git clone --depth 1 git://git.parabola.nu/abslibre.git
    cp -r abslibre/libre/linux-libre .
    cd linux-libre
    makepkg --allsource
}


function getall {
    getrootfs
    getfutility
    getkernel
}

if [ x"$1" = 'x' ] || [ $1 = 'help' ]; then
    printhelp
else
    $1
fi
