how to install Parabola GNU/Linux-Libre onto a usb flash drive or
  microSD card for the ASUS C201PA

#### Required Hardware for this guide
        * ASUS C201PA
        * usb flash drive 8GB or greater
        * internet connection
        * a computer (assumed x86 or x86_64) 
          +-- will be labeled build_computer from here out

#### Cross Build Environment
        * we are gpoing to have to build the kernel manually
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
        * partition_8gb.sh will work on all disks 8GB or larger
        TODO: add support for 4GB disks with no swap partition
        * provide the disk device as the only arguement to partition_8gb.sh
          +-- eg: # ./partition_8gb.sh /dev/sdX

#### Install the rootfs and kernel
        * # ./install_to_disk.sh /dev/sdX

