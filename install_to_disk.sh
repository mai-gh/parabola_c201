#!/bin/bash

ROOTFS_TAR='parabola-systemd-cli-armv7h-tarball-2018-02-06.tar.gz'
KERNEL_BASE_VER="$(cat linux-libre/version | sed 's/\(\..*\)\..*/\1/g')"
PACKED_ZIMG_FILE="linux-libre/linux-$KERNEL_BASE_VER/vmlinux.kpart"
DISK="$1"
KERNEL_PART="$DISK"1
ROOTFS_PART="$DISK"2
ROOTFS_UUID="$(blkid | grep $ROOTFS_PART | awk -F'"' '{print $2}')"
SWAP_PART="$DISK"3
SWAP_UUID="$(blkid | grep $SWAP_PART | awk -F'"' '{print $2}')"

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

if [ x"$DISK" == 'x' ]; then
    echo "This script requires a base block device as its only arguement" 1>&2
    echo "example: $0 /dev/sdb"
    exit 1
fi

mkdir mnt
mount $ROOTFS_PART mnt
bsdtar -xf $ROOTFS_TAR -C mnt
echo "in another terminal you can run 'watch grep -e Dirty: -e Writeback: /proc/meminfo' to watch the sync progress"
sync

# set root password to root https://unix.stackexchange.com/questions/76313/change-password-of-a-user-in-etc-shadow
perl -pi -e 's|(root):(\$.*?:)|\1:\$6\$SALTsalt\$6cu/5trl4ffmLFSZzTa/g6RJK1ecHq79FXHN448S2EgSUHBv/y0AxNXW4MpJfPEZPNjdvpxZZCzDNRxINCjJ0.:|' mnt/etc/shadow

sed -i 's/^/## /g' mnt/etc/fstab
echo "UUID=$ROOTFS_UUID / ext4 rw,relatime,data=ordered 0 1" >> mnt/etc/fstab
echo "UUID=$SWAP_UUID none swap defaults 0 0" >> mnt/etc/fstab
cp $PACKED_ZIMG_FILE mnt/boot/
dd if=mnt/boot/vmlinux.kpart of=$KERNEL_PART
umount mnt


