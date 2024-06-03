
lvm_handling() {

  # FORMATTING DONE
  if [[ $LVM -eq 0 ]]; then
    printf "${C_WHITE}> ${INFO} ${C_CYAN}Formatting ${root_part} to ${filesystem}.${NO_FORMAT}\n"
    case "$filesystem" in
      XFS)
        mkfs.xfs -f -L Archlinux ${root_part} &> /dev/null
        ;;
      EXT4)
        mkfs.ext4 -L Archlinux ${root_part} &> /dev/null
        ;;
    esac 
    mount_default

  elif [[ $LVM -eq 1 ]]; then
    printf "\n"
    printf "${C_WHITE}> ${INFO} ${NO_FORMAT}You will use LVM."
    jump
    printf "${C_WHITE}> ${INFO} ${C_CYAN}Creating LVM to ${root_part} with ${filesystem}...${NO_FORMAT}"
    jump

    pvcreate ${root_part}
    vgcreate VG_Archlinux ${root_part}
    lvcreate -l 20%FREE VG_Archlinux -n root
    lvcreate -l 40%FREE VG_Archlinux -n home
    lvcreate -l 20%FREE VG_Archlinux -n usr
    lvcreate -l 10%FREE VG_Archlinux -n var
    lvcreate -l 10%FREE VG_Archlinux -n tmp

    case "$filesystem" in
      XFS)
        mkfs.xfs -f -L Arch_root /dev/mapper/VG_Archlinux-root &> /dev/null
        mkfs.xfs -f -L Arch_home /dev/mapper/VG_Archlinux-home &> /dev/null
        mkfs.xfs -f -L Arch_usr /dev/mapper/VG_Archlinux-usr &> /dev/null
        mkfs.xfs -f -L Arch_var /dev/mapper/VG_Archlinux-var &> /dev/null
        mkfs.xfs -f -L Arch_tmp /dev/mapper/VG_Archlinux-tmp &> /dev/null
        ;;
      EXT4)
        mkfs.ext4 -L Arch_root /dev/mapper/VG_Archlinux-root &> /dev/null
        mkfs.ext4 -L Arch_home /dev/mapper/VG_Archlinux-home &> /dev/null
        mkfs.ext4 -L Arch_usr /dev/mapper/VG_Archlinux-usr &> /dev/null
        mkfs.ext4 -L Arch_var /dev/mapper/VG_Archlinux-var &> /dev/null
        mkfs.ext4 -L Arch_tmp /dev/mapper/VG_Archlinux-tmp &> /dev/null
        ;;
    esac 

    jump
    printf "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-root${NO_FORMAT} to /mnt\n"
    mount /dev/mapper/VG_Archlinux-root /mnt

    printf "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-home${NO_FORMAT} to /mnt/home\n"
    mount --mkdir /dev/mapper/VG_Archlinux-home /mnt/home

    printf "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-usr${NO_FORMAT} to /mnt/usr\n"
    mount --mkdir /dev/mapper/VG_Archlinux-usr /mnt/usr

    printf "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-var${NO_FORMAT} to /mnt/var\n"
    mount --mkdir /dev/mapper/VG_Archlinux-var /mnt/var

    printf "${C_WHITE}> ${INFO} Mounting ${C_CYAN}VG_Archlinux-tmp${NO_FORMAT} to /mnt/tmp\n"
    mount --mkdir /dev/mapper/VG_Archlinux-tmp /mnt/tmp

    printf "${C_WHITE}> ${INFO} Mounting ${C_CYAN}${boot_part}${NO_FORMAT} to /mnt/boot"
    jump
    mount --mkdir ${boot_part} /mnt/boot

    root_part="/dev/mapper/VG_Archlinux-root"
  fi
}