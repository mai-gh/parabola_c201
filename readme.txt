how to install Parabola GNU/Linux-Libre onto a usb flash drive or
  microSD card for the ASUS C201PA

#### Required Hardware for this guide
        * ASUS C201PA
        * usb flash drive 8GB or greater
        * internet connection
        * a computer (assumed x86 or x86_64) 


#### Cross Build Environment
        * we are going to have to build the kernel manually
        * we want to keep things as close to parabola stock as possible, 
        * we will need the following installed on the build_computer
          +-- bash
          +-- makepkg
          +-- git
          +-- sgdisk
          +-- wget
          +-- arm-none-eabi-gcc

#### Get external dependencies
        * $ ./get_external_dependencies.sh

#### Build Kernel
        * $ ./build_kernel.sh

#### Partition the disk
        * the provided partition_8gb.sh script will automatically setup
          +-- the provided disk to have a 32MB kernel partition as part 1
          +-- a 4GB swap partition as part 3
          +-- a rootfs partition (ext4) as part 2, with max remaining size
        * partition_usb.sh will make a 4GB swap partition if the device is 5GB or larger
        * provide the disk device as the only arguement to partition_8gb.sh
          +-- eg: # ./partition_usb.sh /dev/sdX

#### Install the rootfs and kernel
        * # ./install_to_disk.sh /dev/sdX

#### Post Install

#### building a kernel in system
        * # pacman --noconfirm --needed -S fakeroot make gcc pkg-config libyaml base-devel trousers pkgfile strace bc uboot-tools dtc wget
        * comment out the line:    export CROSS_COMPILE=arm-none-eabi-

#### openrc install with encrypted fs on sdcard
