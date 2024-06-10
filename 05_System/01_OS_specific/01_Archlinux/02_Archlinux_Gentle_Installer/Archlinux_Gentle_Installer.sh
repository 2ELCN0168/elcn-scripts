#! /bin/bash

source_files() {

    local f_path="./functions"

    source ./c_config.sh
    source $f_path/f_formatting.sh

    source $f_path/f_greetings.sh
    source $f_path/f_internet.sh
    source $f_path/f_lvm_luks_deletion.sh
    source $f_path/f_bios_mode.sh
    source $f_path/f_bootloader_choice.sh
    source $f_path/f_luks_choice.sh
    source $f_path/f_cpu_manufacturer.sh
    source $f_path/f_lvm_handling.sh
    source $f_path/f_mount_default.sh
    source $f_path/f_filesystem.sh
    source $f_path/f_disk_choice.sh
    source $f_path/f_partition_disks.sh
    source $f_path/f_format_choice.sh
    source $f_path/f_pacstrap.sh
    source $f_path/f_genfstab.sh
    source $f_path/f_systemd_resolved.sh
}

# SOURCE FILES
source_files

# INIT
greetings

# TEST INTERNET CONNECTION
test_internet

# ASK FOR LVM AND LUKS DESTRUCTION
lvm_luks_try

# TEST UEFI/BIOS MODE
get_bios_mode

# ASK FOR BOOTLOADER
bootloader_choice

# ASK FOR LUKS
luks_choice

# DETECT CPU MANUFACTURER
get_cpu_brand

# ASK FOR FILESYSTEM
filesystem_choice

# ASK FOR BLOCK DEVICE
disk_choice

# INIT PARTITIONING
partition_disk

# START FORMATING PARTITIONS BTRFS|XFS|EXT4 WITH(OUT) LUKS
format_partitions

# INSTALL THE SYSTEM
pacstrap_install

# GENERATE FSTAB
gen_fstab

cp -a c_config.sh post_install
cp -a functions/f_formatting.sh post_install/functions
cp -a post_install /mnt
chmod +x /mnt/post_install/Archlinux_Gentle_Installer_post_install.sh
arch-chroot /mnt /post_install/Archlinux_Gentle_Installer_post_install.sh