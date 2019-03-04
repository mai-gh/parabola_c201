#!/bin/bash

# get the rootfs tar
# you can check  https://wiki.parabola.nu/Get_Parabola for newer versions and to verify the gpg key
wget -c https://repo.parabola.nu/iso/systemd-cli-2018-02-06/parabola-systemd-cli-armv7h-tarball-2018-02-06.tar.gz
wget -c https://repo.parabola.nu/iso/systemd-cli-2018-02-06/parabola-systemd-cli-armv7h-tarball-2018-02-06.tar.gz.sig
wget -c https://repo.parabola.nu/iso/systemd-cli-2018-02-06/SHA512SUMS
sha512sum -c SHA512SUMS
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 0x4B745536
gpg --verify parabola-systemd-cli-armv7h-tarball-2018-02-06.tar.gz.sig
 
# we need the futility tool from vboot-utils
git clone https://chromium.googlesource.com/chromiumos/platform/vboot_reference
cd vboot_reference
make all
cd ..

# get the parabola kernel
git clone --depth 1 git://git.parabola.nu/abslibre.git
cp -r abslibre/libre/linux-libre .
cd linux-libre
makepkg --allsource

