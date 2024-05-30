ask_packages() {
  
  printf "\n"
  while true; do
    read -p "[?] - Do you want to add networking tools (e.g., nload, nethogs, jnettop, iptraf-ng, tcpdump, nmap, bind-tools, ldns, etc.) [Y/n] " netPack
    local netPack=${netPack:-Y}
    case "$netPack" in
      [yY])
        printf "\n"
        printf "${C_WHITE}> ${INFO} ${C_CYAN}Networking pack${NO_FORMAT} will be installed."
        jump
        additionalPackages="$additionalPackages bind-tools ldns nmon nload nethogs jnettop iptraf-ng tcpdump nmap"
        break
        ;;
      [nN])
        break
        ;;
      *)
        invalid_answer
        ;;
    esac
  done

  while true; do
    read -p "[?] - Do you want to add helping tools (e.g., tealdeer, man, texinfo, etc.) [Y/n] " helpPack
    local helpPack=${helpPack:-Y}
    case "$helpPack" in
      [yY])
        printf "\n"
        printf "${C_WHITE}> ${INFO} ${C_GREEN}Helping pack${NO_FORMAT} will be installed."
        jump
        additionalPackages="$additionalPackages texinfo tealdeer man man-pages"
        break
        ;;
      [nN])
        break
        ;;
      *)
        invalid_answer
        ;;
    esac
  done

  while true; do
    read -p "[?] - Do you want to add monitoring tools (e.g., btop, htop, bmon, etc.) [Y/n] " monPack
    local monPack=${monPack:-Y}
    case "$monPack" in
      [yY])
        printf "\n"
        printf "${C_WHITE}> ${INFO} ${C_YELLOW}Monitoring pack${NO_FORMAT} will be installed."
        jump
        additionalPackages="$additionalPackages btop htop bmon"
        break
        ;;
      [nN])
        break
        ;;
      *)
        invalid_answer
        ;;
    esac
  done
}

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
  
  # Ask for additional packages
  ask_packages

  # Display additional packages
  printf "${C_WHITE}> ${INFO} Additional packages are${C_CYAN}${additionalPackages}${NO_FORMAT}"
  jump
  sleep 4
  
  # Perform the installation of the customized system
  pacstrap -K /mnt linux{,-{firmware,lts{,-headers}}} base{,-devel} git terminus-font openssh zsh{,-{syntax-highlighting,autosuggestions,completions,history-substring-search}} \
  systemctl-tui hdparm neovim vim dos2unix tree fastfetch networkmanager tmux ${additionalPackages}
  jump
  printf "${C_WHITE}> ${INFO} ${C_RED}Sorry, nano has been deleted from the Arch repository, you will have to learn${NO_FORMAT} ${C_GREEN}Vim${NO_FORMAT}."
}