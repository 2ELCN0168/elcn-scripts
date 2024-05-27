install_refind() {

  refind-install &> /dev/null

  rootLine=""
  isMicrocode=""
  isBTRFS=""
  isEncrypt=""
  isEncryptEnding=""

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

  if [[ $filesystem == 'BTRFS' && $BTRFSsubvols -eq 1 ]]; then
    isBTRFS=" rootflags=subvol=@"
  fi

  uuid=$(blkid -o value -s UUID "$root_part")

  # This is interesting, it generates the proper refind_linux.conf file with custom parameters, e.g., filesystem and microcode
  printf \"Arch Linux\" \"$rootLine$isEncrypt$uuid$isEncryptEnding rw initrd=initramfs-linux.img$isBTRFS$isMicrocode\"
  printf \"Arch Linux\" \"$rootLine$isEncrypt$uuid$isEncryptEnding rw initrd=initramfs-linux.img$isBTRFS$isMicrocode\" > /boot/refind_linux.conf

  printf "${C_GREEN}rEFInd configuration created successfully.${NO_FORMAT}"
}

install_grub() {
  if [[ $UEFI -eq 1 ]]; then
    printf "Installing grub for EFI to /boot."
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB &> /dev/null
    if [[ ! $? -eq 0 ]]; then
      printf "GRUB installation failed, trying another method..."
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB --removable --force &> /dev/null
    if [[ ! $? -eq 0 ]]; then
      printf "GRUB installation failed even with different parameters, you will have to install and configure a bootloader manually. Good luck."
      while true; do
        read -p "Should we install REFIND? [Y/n] -> " installrefind
        installrefind="${installrefind:-Y}"
        case "$installrefind" in 
          [yY])
          bootloader="REFIND"
          install_refind
          break
          ;;
        [nN])
          printf "Fine, I guess you know what you're doing."
          break
          ;;
        *)
          printf "Please answer properly."
          ;;
        esac
      done
    fi
  fi

  elif [[ $UEFI -eq 0 ]]; then
    printf "Installing grub for BIOS to /boot."
    grub-install --target=i386-pc /dev/$diskToUse &> /dev/null
  fi

  # Add a verifcation for partition name with testing if ls /dev/$partname returns error or not instead of lsblk
  #read -p "Type your root partition name (e.g., sda2, nvme0n1p2 (default=sda2)) -> " partition
  #partition="${partition:-sda2}"
  #partition="/dev/${partition}"

  rootLine=""
  isMicrocode=""
  isBTRFS=""
  isEncrypt=""
  isEncryptEnding=""

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

  if [[ $filesystem == 'BTRFS' && $BTRFSsubvols -eq 1 ]]; then
  isBTRFS=" rootflags=subvol=@"
  fi

  # uuid=$(blkid -o value -s UUID "$partition")
  uuid=$(blkid -o value -s UUID "$root_part")

  export grubKernelParameters="$rootLine$isEncrypt$uuid$isEncryptEnding rw initrd=initramfs-linux.img$isBTRFS$isMicrocode"
  printf "${grubKernelParameters}"

  # VERY IMPORTANT LINE, SO ANNOYING TO GET IT WORKING, DO NOT DELETE!
  awk -v params="$grubKernelParameters" '/GRUB_CMDLINE_LINUX=""/{$0 = "GRUB_CMDLINE_LINUX=\"" params "\""} 1' /etc/default/grub > tmpfile && mv tmpfile /etc/default/grub

  grub-mkconfig -o /boot/grub/grub.cfg
}

install_bootloader() {
  if [[ $bootloader == 'REFIND' ]]; then
    install_refind
  elif [[ $bootloader == 'GRUB' ]]; then
    install_grub
  fi
}