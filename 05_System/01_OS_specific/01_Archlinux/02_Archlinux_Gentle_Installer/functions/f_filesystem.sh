# FUNCTION(S)
# ---
# This function asks the user which filesystem they want to use. 
# Choices are BTRFS (default), XFS, EXT4.
# ---

filesystem_choice() {

  export filesystem=""

  while true; do
    printf "==FILESYSTEM========"
    jump
    printf "${C_WHITE}[0] - ${C_YELLOW}BTRFS${NO_FORMAT} (default) \n"
    printf "${C_WHITE}[1] - ${C_CYAN}XFS${NO_FORMAT} \n"
    printf "${C_WHITE}[2] - ${C_RED}EXT4${NO_FORMAT} "
    jump
    printf "====================\n"
    
    read -p "Which filesystem do you want to use? [0/1/2] -> " response
    response=${response:-0} # Default is BTRFS if no response given
    jump
    case "$response" in
      [0])
        filesystem="BTRFS"
        printf "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose ${C_WHITE}${filesystem}${NO_FORMAT}"
        jump
        break
        ;;
      [1])
        filesystem="XFS"
        printf "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose ${C_WHITE}${filesystem}${NO_FORMAT}"
        jump
        break
        ;;
      [2])
        filesystem="EXT4"
        printf "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose ${C_WHITE}${filesystem}${NO_FORMAT}"
        jump
        break
        ;;
      *)
        invalid_answer
        ;;
    esac
  done
}

btrfs_handling() {

  # FORMATTING DONE

  export btrfsSubvols=0

  while true; do
    read -p "[?] - It seems that you've picked BTRFS, do you want a clean installation with subvolumes (0) or a regular one with only the filesystem (1)? [0=default/1] -> " response
    response=${response:-0}
    jump
    case "$response" in
      [0])
        btrfsSubvols=1
        printf "${C_WHITE}> ${INFO} ${C_GREEN}You chose to make subvolumes. Good choice.${NO_FORMAT}"
        jump
        break
        ;;
      [1])
        btrfsSubvols=0
        printf "${C_WHITE}> ${INFO} ${C_YELLOW}No subvolume will be created.${NO_FORMAT}"
        jump
        break
        ;;
      *)
        invalid_answer
        ;;
    esac
  done

  printf "${C_WHITE}> ${INFO} Formatting ${root_part} to ${filesystem}.${NO_FORMAT}\n"
  mkfs.btrfs -f -L Archlinux ${root_part} &> /dev/null

  if [[ $btrfsSubvols -eq 1 ]]; then
    mount ${root_part} /mnt &> /dev/null
    btrfs subvolume create /mnt/{@,@home,@usr,@tmp,@var,.snapshots} &> /dev/null

    printf "${C_WHITE}> ${INFO} Creating${NO_FORMAT} ${C_YELLOW}subvolume ${C_GREEN}@${NO_FORMAT}\n"
    printf "${C_WHITE}> ${INFO} Creating${NO_FORMAT} ${C_YELLOW}subvolume ${C_GREEN}@home${NO_FORMAT}\n"
    printf "${C_WHITE}> ${INFO} Creating${NO_FORMAT} ${C_YELLOW}subvolume ${C_GREEN}@usr${NO_FORMAT}\n"
    printf "${C_WHITE}> ${INFO} Creating${NO_FORMAT} ${C_YELLOW}subvolume ${C_GREEN}@tmp${NO_FORMAT}\n"
    printf "${C_WHITE}> ${INFO} Creating${NO_FORMAT} ${C_YELLOW}subvolume ${C_GREEN}@var${NO_FORMAT}\n"
    printf "${C_WHITE}> ${INFO} Creating${NO_FORMAT} ${C_YELLOW}subvolume ${C_GREEN}.snapshots${NO_FORMAT}"
    jump

    umount -R /mnt &> /dev/null

    printf "${C_WHITE}> ${INFO} Mounting ${C_GREEN}@${NO_FORMAT} to ${C_WHITE}/mnt${NO_FORMAT}\n"
    mount -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@ ${root_part} /mnt

    printf "${C_WHITE}> ${INFO} Mounting ${C_GREEN}@home${NO_FORMAT} to ${C_WHITE}/mnt/home${NO_FORMAT}\n"
    mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@home ${root_part} /mnt/home

    printf "${C_WHITE}> ${INFO} Mounting ${C_GREEN}@usr${NO_FORMAT} to ${C_WHITE}/mnt/usr${NO_FORMAT}\n"
    mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@usr ${root_part} /mnt/usr

    printf "${C_WHITE}> ${INFO} Mounting ${C_GREEN}@tmp${NO_FORMAT} to ${C_WHITE}/mnt/tmp${NO_FORMAT}\n"
    mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@tmp ${root_part} /mnt/tmp

    printf "${C_WHITE}> ${INFO} Mounting ${C_GREEN}@var${NO_FORMAT} to ${C_WHITE}/mnt/var${NO_FORMAT}\n"
    mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=@var ${root_part} /mnt/var

    printf "${C_WHITE}> ${INFO} Mounting ${C_GREEN}.snapshots${NO_FORMAT} to ${C_WHITE}/mnt/.snapshots${NO_FORMAT}\n"
    mount --mkdir -t btrfs -o compress=zstd,discard=async,autodefrag,subvol=.snapshots ${root_part} /mnt/.snapshots

    printf "${C_WHITE}> ${INFO} Mounting ${C_GREEN}/dev/sda1${NO_FORMAT} to ${C_WHITE}/mnt/boot${NO_FORMAT}\n"
    mount --mkdir ${boot_part} /mnt/boot
    jump

    lsblk -f
  elif [[ $btrfsSubvols -eq 0 ]]; then
    mount_default
  fi
}
  
fs_handling() {

  export LVM=0

  # FORMATTING DONE
  while true; do
    read -p "It seems that you've picked ${filesystem}, do you want to use LVM? [Y/n] -> " response
    response=${response:-Y}
    case "$response" in
      [yY])
      LVM=1
      break
      ;;            
    [nN])
      LVM=0
      printf "${C_WHITE}> ${NO_FORMAT}You won't use LVM."
      jump
      break
      ;;
    *)
      invalid_answer
      ;;
    esac
  done
  lvm_handling
}