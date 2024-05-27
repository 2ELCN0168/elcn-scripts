set_hwclock() {

  jump
  printf "${C_WHITE}> ${INFO}Setting system clock to UTC."
  jump

  if hwclock --systohc &> /dev/null; then
    printf "${C_WHITE}> ${SUC} ${C_GREEN}Successfully set up system clock to UTC.${NO_FORMAT}"
  else
    printf "${C_WHITE}> ${WARN} ${C_YELLOW} Failed to setting system clock to UTC.${NO_FORMAT}"
  fi
  jump
}

locales_gen() {

  # Uncomment #en_US.UTF-8 UTF-8 in /mnt/etc/locale.gen
  printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Uncommenting ${C_CYAN}en_US.UTF-8 UTF-8${NO_FORMAT} in ${C_PINK}/etc/locale.gen${NO_FORMAT}..."
  sed -i '/^\s*#\(en_US.UTF-8 UTF-8\)/ s/^#//' /etc/locale.gen
  jump

  printf "${C_WHITE}> ${INFO} ${C_CYAN}Generating locales...${NO_FORMAT}"
  jump

  if locale-gen &> /dev/null; then
    printf "${C_WHITE}> ${SUC} ${C_GREEN}Locales generated successfully.${NO_FORMAT}"
  else
    printf "${C_WHITE}> ${WARN} ${C_YELLOW}Failed to generate locales.${NO_FORMAT}"
  fi
  jump
}

set_hostname() {
  # Setting up /etc/hostname
  read -p "Enter your hostname with domain (optional). Recommended hostname length: 15 chars. (e.g., MH1DVMARXXX001O.home.arpa). Default is 'localhost.home.arpa'. " hostname
  hostname=${hostname:-'localhost.home.arpa'}
  if [[ -n $hostname ]]; then
    printf $hostname > /etc/hostname
    printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Your hostname will be ${C_CYAN}${hostname}${NO_FORMAT}."
    jump 
  fi 
}

set_hosts() {

  # Setting up /mnt/etc/hosts
  printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Setting up ${C_PINK}/etc/hosts${NO_FORMAT}"
  jump

  printf "127.0.0.1 localhost.localdomain localhost localhost-ipv4\n" > /etc/hosts
  printf "::1       localhost.localdomain localhost localhost-ipv6\n" >> /etc/hosts
  printf "127.0.0.1 $hostname.localdomain  $hostname  $hostname-ipv4\n" >> /etc/hosts
  printf "::1       $hostname.localdomain  $hostname  $hostname-ipv6\n" >> /etc/hosts

  cat /etc/hosts
  sleep 1
}

set_vconsole() {

  # Creating /mnt/etc/vconsole.conf
    printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Creating the file ${C_PINK}/etc/vconsole.conf${NO_FORMAT}."
    jump
    printf "KEYMAP=us" > /etc/vconsole.conf
}

set_pacman() {

  # Uncomment #Color and #ParallelDownloads 5 in /etc/pacman.conf AGAIIIIN
  printf "${C_WHITE}> ${NO_FORMAT}Uncommenting ${C_WHITE}'Color'${NO_FORMAT} and ${C_WHITE}'ParallelDownloads 5'${NO_FORMAT} in ${C_PINK}/mnt/etc/pacman.conf${NO_FORMAT} AGAIIIIN.\n"
  jump

  #sed -i '/^\s*#\(Color\|ParallelDownloads\)/ s/^#//' /etc/pacman.conf
  sed -i '/^#\(Color\|ParallelDownloads\)/s/^#//' /etc/pacman.conf
}

set_mkinitcpio() {

  # Making a clean backup of /mnt/etc/mkinitcpio.conf
  printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Making a backup of ${C_PINK}/etc/mkinitcpio.conf${NO_FORMAT}..."
  jump
  cp -a /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bak

  # Setting up /etc/mkinitcpio.conf
  isBTRFS=""
  isLUKS=""
  isLVM=""

  if [[ $filesystem == 'BTRFS' ]]; then
    isBTRFS="btrfs "
  fi

  if [[ $wantEncrypted -eq 1 ]]; then
    isLUKS="sd-encrypt "
  fi

  if [[ $LVM -eq 1 ]]; then
    isLVM="lvm2 "
  fi

  printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Updating ${C_PINK}/etc/mkinitcpio.conf${NO_FORMAT} with custom parameters..."
  local mkcpioHOOKS="HOOKS=(base systemd ${isBTRFS}autodetect modconf kms keyboard sd-vconsole ${isLUKS}block ${isLVM}filesystems fsck)"
  awk -v newLine="$mkcpioHOOKS" '!/^#/ && /HOOKS/ { print newLine; next } 1' /etc/mkinitcpio.conf > tmpfile && mv tmpfile /etc/mkinitcpio.conf

  # Generate initramfs
  mkinitcpio -P
}

set_root_passwd() {

  jump
  printf "${C_WHITE}> ${INFO} ${C_CYAN}Changing root password...${NO_FORMAT}"
  jump
  while true; do
    if passwd; then
      break
    fi
  done
  jump
}

make_config() {

  printf "${C_WHITE}> ${INFO}systemctl ${C_GREEN}enable${NO_FORMAT} NetworkManager"
  systemctl enable NetworkManager &> /dev/null

  set_hwclock
  locales_gen
  set_hostname
  set_hosts
  set_vconsole
  set_pacman
  set_mkinitcpio
  set_root_passwd
}