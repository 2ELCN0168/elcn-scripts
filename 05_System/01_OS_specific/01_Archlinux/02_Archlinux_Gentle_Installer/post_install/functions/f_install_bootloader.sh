install_refind() {

  printf "${C_WHITE}> ${INFO} Installing rEFInd.${NO_FORMAT}"
  jump
  refind-install &> /dev/null

  local rootLine=""
  local isMicrocode=""
  local isBTRFS=""
  local isEncrypt=""
  local isEncryptEnding=""
  local uuid=""
  if [[ $cpuBrand == 'INTEL' ]]; then
    isMicrocode=" initrd=intel-ucode.img"
  elif [[ $cpuBrand == 'AMD' ]]; then
    isMicrocode=" initrd=amd-ucode.img"
  fi

  if [[ $wantEncrypted -eq 1 ]]; then
    rootLine=""
    isEncrypt="rd.luks.name="
    isEncryptEnding="=root root=/dev/mapper/root"
  elif [[ $wantEncrypted -eq 0 ]]; then
    rootLine="root=UUID="
  fi

  if [[ $filesystem == 'BTRFS' && $btrfsSubvols -eq 1 ]]; then
    isBTRFS=" rootflags=subvol=@"
  fi


  if [[ $filesystem == 'BTRFS' && $btrfsSubvols -eq 1 && $wantEncrypted -eq 1 ]]; then
    uuid=$(blkid -o value -s UUID "$user_disk")
  else
    uuid=$(blkid -o value -s UUID "$root_part")
  fi

  # This is interesting, it generates the proper refind_linux.conf file with custom parameters, e.g., filesystem and microcode
  echo -e "${C_WHITE}> ${INFO} ${C_PINK}\"Arch Linux\" \"$rootLine$isEncrypt$uuid$isEncryptEnding rw initrd=initramfs-linux.img$isBTRFS$isMicrocode\"${NO_FORMAT} to ${C_WHITE}/boot/refind-linux.conf.${NO_FORMAT}\n"

  echo -e \"Arch Linux\" \"$rootLine$isEncrypt$uuid$isEncryptEnding rw initrd=initramfs-linux.img$isBTRFS$isMicrocode\" > /boot/refind_linux.conf

  printf "${C_WHITE}> ${SUC} ${C_WHITE} rEFInd configuration created successfully.${NO_FORMAT}"
  jump
}

install_grub() {
  if [[ $UEFI -eq 1 ]]; then
    printf "${C_WHITE}> ${INFO} Installing grub for EFI to /boot."
    jump
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB &> /dev/null
    if [[ ! $? -eq 0 ]]; then
      printf "${C_WHITE}> ${ERR} GRUB installation failed, trying another method..."
      jump
      grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removable --force &> /dev/null
    if [[ ! $? -eq 0 ]]; then
      printf "${C_WHITE}> ${ERR} ${C_RED}GRUB installation failed even with different parameters, you will have to install and configure a bootloader manually. Good luck.${NO_FORMAT}"
      while true; do
        read -p "[?] - Should we install REFIND? [Y/n] -> " installrefind
        local installrefind="${installrefind:-Y}"
        case "$installrefind" in 
          [yY])
          bootloader="REFIND"
          install_refind
          break
          ;;
        [nN])
          jump
          printf "${C_WHITE}> ${WARN} Fine, I guess you know what you're doing."
          jump
          break
          ;;
        *)
          invalid_answer
          ;;
        esac
      done
    fi
  fi

  elif [[ $UEFI -eq 0 ]]; then
    printf "${C_WHITE}> ${INFO} Installing grub for BIOS to /boot."
    jump
    grub-install --target=i386-pc /dev/$disk &> /dev/null
  fi

  # Add a verifcation for partition name with testing if ls /dev/$partname returns error or not instead of lsblk
  #read -p "Type your root partition name (e.g., sda2, nvme0n1p2 (default=sda2)) -> " partition
  #partition="${partition:-sda2}"
  #partition="/dev/${partition}"

  local rootLine=""
  local isMicrocode=""
  local isBTRFS=""
  local isEncrypt=""
  local isEncryptEnding=""

  # Make a backup of /etc/default/grub
  cp -a /etc/default/grub /etc/default/grub.bak

  if [[ $cpuBrand == 'INTEL' ]]; then
    isMicrocode=" initrd=intel-ucode.img"
  elif [[ $cpuBrand == 'AMD' ]]; then
    isMicrocode=" initrd=amd-ucode.img"
  fi

  if [[ $wantEncrypted -eq 1 ]]; then
    rootLine=""
    isEncrypt="rd.luks.name="
    isEncryptEnding="=root root=/dev/mapper/root"
    sed -i '/^\s*#\(GRUB_ENABLE_CRYPTODISK\)/ s/^#//' /etc/default/grub
  elif [[ $wantEncrypted -eq 0 ]]; then
    rootLine="root=UUID="
  fi

  if [[ $filesystem == 'BTRFS' && $btrfsSubvols -eq 1 ]]; then
    isBTRFS=" rootflags=subvol=@"
  fi

  # uuid=$(blkid -o value -s UUID "$partition")
  local uuid=$(blkid -o value -s UUID $root_part)

  grubKernelParameters="\"$rootLine$isEncrypt$uuid$isEncryptEnding rw initrd=initramfs-linux.img$isBTRFS$isMicrocode\""
  printf "${C_WHITE}> ${INFO} Inserting ${C_PINK}${grubKernelParameters}${NO_FORMAT} to /etc/default/grub."

  # VERY IMPORTANT LINE, SO ANNOYING TO GET IT WORKING, DO NOT DELETE!
  awk -v params="$grubKernelParameters" '/GRUB_CMDLINE_LINUX=""/{$0 = "GRUB_CMDLINE_LINUX=" params ""} 1' /etc/default/grub > tmpfile && mv tmpfile /etc/default/grub

  grub-mkconfig -o /boot/grub/grub.cfg
}

install_systemdboot() {

  local rootLine=""
  local isMicrocode=""
  local isBTRFS=""
  local isEncrypt=""
  local isEncryptEnding=""

  if [[ $cpuBrand == 'INTEL' ]]; then
    isMicrocode="initrd=intel-ucode.img"
  elif [[ $cpuBrand == 'AMD' ]]; then
    isMicrocode="initrd=amd-ucode.img"
  fi

  if [[ $wantEncrypted -eq 1 ]]; then
    rootLine=""
    isEncrypt="rd.luks.name="
    isEncryptEnding="=root root=/dev/mapper/root"
  elif [[ $wantEncrypted -eq 0 ]]; then
    rootLine="root=UUID="
  fi

  if [[ $filesystem == 'BTRFS' && $btrfsSubvols -eq 1 ]]; then
    isBTRFS=" rootflags=subvol=@"
  fi

  local uuid=$(blkid -o value -s UUID "$root_part")


  printf "${C_WHITE}> ${INFO} Installing ${C_RED}systemd-boot.${NO_FORMAT}"
  jump
  
  if bootctl install --esp-path=/boot &> /dev/null; then
    echo -e "title   Arch Linux" > /boot/loader/entries/arch.conf
    echo -e "linux   /vmlinuz-linux" >> /boot/loader/entries/arch.conf
    echo -e "initrd  /initramfs-linux.img" >> /boot/loader/entries/arch.conf
    if [[ -z $isMicrocode ]];then
      echo -e "initrd  /$isMicrocode" >> /boot/loader/entries/arch.conf
    fi
    echo -e "options $rootLine$isEncrypt$uuid$isEncryptEnding rw $isBTRFS" >> /boot/loader/entries/arch.conf

    printf "${C_WHITE}> ${SUC} Installed ${C_RED}systemd-boot.${NO_FORMAT}"
    jump
    if ! ls /etc/pacman.d/hooks; then
      printf "${C_WHITE}> ${INFO} Creating a pacman hook for ${C_RED}systemd-boot.${NO_FORMAT}"
      mkdir -p /etc/pacman.d/hooks
      cat << EOF > /etc/pacman.d/hooks/95-systemd-boot.hook
      [Trigger]
      Type = Package
      Operation = Upgrade
      Target = systemd

      [Action]
      Description = Gracefully upgrading systemd-boot...
      When = PostTransaction
      Exec = /usr/bin/systemctl restart systemd-boot-update.service
EOF
    fi
  else
    printf "${C_WHITE}> ${ERR} Error during installation of ${C_RED}systemd-boot.${NO_FORMAT}"
    jump
    while true; do
      read -p "[?] - Would you like to install rEFInd instead? [Y/n] " response
      local response=${response:-Y}
      case "$response" in 
        [yY])
          install_refind
          break
          ;;
        [nN])
          jump
          printf "${C_WHITE}> ${WARN} Fine, I guess you know what you're doing."
          jump
          break
          ;;
        *)
          invalid_answer
          ;;
      esac
    done
  fi

}

install_bootloader() {
  if [[ $bootloader == 'REFIND' ]]; then
    install_refind
  elif [[ $bootloader == 'GRUB' ]]; then
    install_grub
  elif [[ $bootloader == 'SYSTEMDBOOT' ]]; then
    install_systemdboot
  fi
}