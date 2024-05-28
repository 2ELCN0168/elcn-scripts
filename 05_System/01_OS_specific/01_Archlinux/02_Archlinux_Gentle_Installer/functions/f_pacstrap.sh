
pacstrap_install() {

  # FORMATTING DONE
  # List of additional packages depending on parameters specified by the user, avoiding installation of useless things
  additionalPackages=""

  if [[ $filesystem == 'BTRFS' ]]; then
    additionalPackages="$additionalPackages btrfs-progs"
  elif [[ $filesystem == 'XFS' ]]; then
    additionalPackages="$additionalPackages xfsprogs"
  fi

  if [[ $disk =~ "nvme" ]]; then
    additionalPackages="$additionalPackages nvme-cli libnvme"
  fi

  if [[ $LVM -eq 1 ]]; then
    additionalPackages="$additionalPackages lvm2"
  fi

  if [[ $wantEncrypted -eq 1 ]]; then
    additionalPackages="$additionalPackages cryptsetup"
  fi

  if [[ $bootloader == 'REFIND' ]]; then
    additionalPackages="$additionalPackages refind"
  elif [[ $bootloader == 'GRUB' && $UEFI -eq 1 ]]; then
    additionalPackages="$additionalPackages grub efibootmgr"
  elif [[ $bootloader == 'GRUB' && $UEFI -eq 0 ]]; then
    additionalPackages="$additionalPackages grub"
  fi

  if [[ $cpuBrand == 'INTEL' ]]; then
    additionalPackages="$additionalPackages intel-ucode"
  elif [[ $cpuBrand == 'AMD' ]]; then
    additionalPackages="$additionalPackages amd-ucode"
  fi

  # Uncomment #Color and #ParallelDownloads 5 in /etc/pacman.conf
  sed -i '/^#\(Color\|ParallelDownloads\)/s/^#//' /etc/pacman.conf
  
  # Display additional packages
  jump
  printf "${C_WHITE}> ${INFO} Additional packages are${C_CYAN}${additionalPackages}${NO_FORMAT}"
  jump
  sleep 4
  
  # Perform the installation of the customized system
  pacstrap -K /mnt linux{,-{firmware,lts{,-headers}}} base{,-devel} git terminus-font openssh zsh{,-{syntax-highlighting,autosuggestions,completions,history-substring-search}} \
  systemctl-tui btop htop bmon nmon nload nethogs jnettop iptraf-ng tcpdump nmap bind-tools hdparm vim man{,-{db,pages}} dos2unix tree texinfo tealdeer fastfetch networkmanager tmux ${additionalPackages}
  jump
  printf "${C_WHITE}> ${INFO} ${C_RED}Sorry, nano has been deleted from the Arch repository, you will have to learn${NO_FORMAT} ${C_GREEN}Vim${NO_FORMAT}."
}