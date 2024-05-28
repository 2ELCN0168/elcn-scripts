set_hwclock() {

  jump
  printf "${C_WHITE}> ${INFO} Setting system clock to UTC."
  jump

  if hwclock --systohc &> /dev/null; then
    printf "${C_WHITE}> ${SUC} ${C_GREEN}Successfully set up system clock to UTC.${NO_FORMAT}"
  else
    printf "${C_WHITE}> ${WARN} ${C_YELLOW}Failed to setting system clock to UTC.${NO_FORMAT}"
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
    jump
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
  jump
}

set_vconsole() {

  # Creating /mnt/etc/vconsole.conf
    printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Creating the file ${C_PINK}/etc/vconsole.conf${NO_FORMAT}."
    jump
    printf "KEYMAP=us" > /etc/vconsole.conf
}

set_pacman() {

  # Uncomment #Color and #ParallelDownloads 5 in /etc/pacman.conf AGAIIIIN
  printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Uncommenting ${C_WHITE}'Color'${NO_FORMAT} and ${C_WHITE}'ParallelDownloads 5'${NO_FORMAT} in ${C_PINK}/mnt/etc/pacman.conf${NO_FORMAT} AGAIIIIN."
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
  jump

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

create_tty_theme() {
  mkdir /etc/tty_themes.d
  cat << EOF > /etc/tty_themes.d/tty_classic_renewal.sh
  # Theme generated using: https://ari.lt/page/ttytheme
  # Installation: Just add these lines to your ~/.bashrc

  __tty_theme() {

    
      [ "\$TERM" = 'linux' ] || return # Only run in a TTY

      printf "\e]P02f302c" # black         rgb(47, 48, 44)     #2f302c
      printf "\e]P1952834" # red           rgb(149, 40, 52)    #952834
      printf "\e]P247933a" # green         rgb(71, 147, 58)    #47933a
      printf "\e]P399642b" # brown         rgb(153, 100, 43)   #99642b
      printf "\e]P4234564" # blue          rgb(35, 69, 100)    #234564
      printf "\e]P57736ba" # magenta       rgb(119, 54, 186)   #7736ba
      printf "\e]P6479faa" # cyan          rgb(71, 159, 170)   #479faa
      printf "\e]P7aaaaaa" # light_gray    rgb(170, 170, 170)  #aaaaaa
      printf "\e]P8555555" # gray          rgb(85, 85, 85)     #555555
      printf "\e]P9ff6380" # bold_red      rgb(255, 99, 128)   #ff6380
      printf "\e]PA96ff59" # bold_green    rgb(150, 255, 89)   #96ff59
      printf "\e]PBffff73" # bold_yellow   rgb(255, 255, 115)  #ffff73
      printf "\e]PC7494c7" # bold_blue     rgb(116, 148, 199)  #7494c7
      printf "\e]PDff75ff" # bold_magenta  rgb(255, 117, 255)  #ff75ff
      printf "\e]PE8cffff" # bold_cyan     rgb(140, 255, 255)  #8cffff
      printf "\e]PFffffff" # bold_white    rgb(255, 255, 255)  #ffffff

      clear # To fix the background
  }

  __tty_theme

EOF

}

set_bashrc() {

  echo "source /etc/tty_themes.d/tty_classic_renewal.sh" >> /etc/skel/.bashrc
  echo "PS1='\[\e[93m\][\[\e[97;1m\]\u\[\e[0;93m\]@\[\e[97m\]\h\[\e[93m\]]\[\e[91m\][\w]\[\e[93m\](\t)\[\e[0m\] \[\e[97m\]\$\[\e[0m\] '" >> /etc/skel/.bashrc
  echo "alias ll='command ls -lh --color=auto'" >> /etc/skel/.bashrc
  echo "alias ls='command ls --color=auto'" >> /etc/skel/.bashrc
  echo "alias ip='command ip -color=auto'" >> /etc/skel/.bashrc
  echo "alias grep='grep --color=auto'" >> /etc/skel/.bashrc

  cp /etc/skel/.bashrc /root
}

set_zshrc() {

  echo "source /etc/tty_themes.d/tty_classic_renewal.sh" >> /etc/skel/.zshrc
  echo 'PROMPT="%F{red}[%f%B%F{white}%n%f%b%F{red}@%f%F{white}%m%f%F{red}:%f%B%~%b%F{red}]%f(%F{red}%*%f)%F{red}%#%f "' >> /etc/skel/.zshrc
}

create_user() {

  local username=""
  local sudo="-G wheel "
  
  while [[ -z "$username" ]]; do
    read -p "[?] - What will be the name of the new user? " response
    username="$response"
  done
  jump

  while true; do
    read -p "[?] - Will this user be sudo? [0/1=default]" sudoResponse
    local sudoResponse=${sudoResponse:-1}
    case "$sudoResponse" in
      0)
        sudo=""
        break
        ;;
      1)
        sudo="-G wheel "
        break
        ;;
      *)
        invalid_answer
        ;;
    esac
  done

  printf "\n"
  printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Creating a new user named ${C_WHITE}${username}${NO_FORMAT}."
  jump

  if useradd -m -U ${sudo}-s /bin/zsh ${username} &> /dev/null; then
    printf "${C_WHITE}> ${SUC} ${NO_FORMAT}New user ${C_WHITE}${username}${NO_FORMAT} created."
    jump
    passwd $username
    printf "\n"
  else
    printf "${C_WHITE}> ${ERR} ${NO_FORMAT}New user ${C_WHITE}${username}${NO_FORMAT} cannot be created."
    jump
  fi

  if [[ -z $sudo ]]; then
    echo "${username} ALL=(ALL:ALL) ALL" > /etc/sudoers.d/$username.sudo
  fi

}

ask_newuser() {

  while true; do
    read -p "[?] - Would you like to create a user? [N/y] " response
    local response=${response:-N}
    case "$response" in
      [yY])
        create_user
        break
        ;;
      [nN])
        printf "${C_WHITE}> ${INFO} ${NO_FORMAT}No user will be created."
        break
        ;;
      *)
        invalid_answer
        ;;
    esac
  done
}

make_config() {

  printf "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} NetworkManager.${NO_FORMAT}"
  systemctl enable NetworkManager &> /dev/null

  printf "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} systemd-resolved.${NO_FORMAT}"
  systemctl enable systemd-resolved &> /dev/null

  set_hwclock
  locales_gen
  set_hostname
  set_hosts
  set_vconsole
  set_pacman
  set_mkinitcpio
  set_root_passwd
  create_tty_theme
  set_bashrc
  ask_newuser
}