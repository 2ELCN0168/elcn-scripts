set_time() {

  jump
  printf "${C_WHITE}> ${INFO} Setting system clock to UTC."
  jump

  if hwclock --systohc &> /dev/null; then
    printf "${C_WHITE}> ${SUC} ${C_GREEN}Successfully set up system clock to UTC.${NO_FORMAT}"
  else
    printf "${C_WHITE}> ${WARN} ${C_YELLOW}Failed to setting system clock to UTC.${NO_FORMAT}"
  fi
  jump

  if timedatectl set-ntp true &> /dev/null; then
    printf "${C_WHITE}> ${SUC} ${C_GREEN}Successfully set up NTP.${NO_FORMAT}"
  else
    printf "${C_WHITE}> ${WARN} ${C_YELLOW}Failed to setting up NTP.${NO_FORMAT}"
  fi
  jump

  while true; do
    printf "====================\n"
    printf "${C_WHITE}[0] - ${C_CYAN}FRANCE${NO_FORMAT} [default]\n"
    printf "${C_WHITE}[1] - ${C_WHITE}ENGLAND${NO_FORMAT} \n"
    printf "${C_WHITE}[2] - ${C_WHITE}US (New-York)${NO_FORMAT} \n"
    printf "${C_WHITE}[3] - ${C_RED}Japan${NO_FORMAT} \n"
    printf "${C_WHITE}[4] - ${C_CYAN}South Korea (Seoul)${NO_FORMAT} \n"
    printf "${C_WHITE}[5] - ${C_RED}Russia (Moscow)${NO_FORMAT} \n"
    printf "${C_WHITE}[6] - ${C_RED}China (CST - Shanghai)${NO_FORMAT} \n"
    printf "${C_WHITE}[7] - ${C_RED}North Korea (Pyongyang)${NO_FORMAT} \n"
    printf "====================\n"
    read -p "[?] - Where do you live? " localtime
    local localtime=${localtime:-0}

    case "$localtime" in
      [0])
        ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
        break
        ;;
      [1])
        ln -sf /usr/share/zoneinfo/Europe/London /etc/localtime
        break
        ;;
      [2])
        ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
        break
        ;;
      [3])
        ln -sf /usr/share/zoneinfo/Japan /etc/localtime
        break
        ;;
      [4])
        ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
        break
        ;;
      [5])
        ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
        break
        ;;
      [6])
        ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
        break
        ;;
      [7])
        ln -sf /usr/share/zoneinfo/Asia/Pyongyang /etc/localtime
        break
        ;;
      *)
        invalid_answer
        ;;
    esac
  done
  printf "\n"
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

  printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Changing DNS to ${C_PINK}1.1.1.1 and 9.9.9.9${NO_FORMAT}"
  echo "nameserver 1.1.1.1" > /etc/resolv.conf
  echo "nameserver 9.9.9.9" >> /etc/resolv.conf
  jump
}

set_vconsole() {

  # Creating /mnt/etc/vconsole.conf
    printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Creating the file ${C_PINK}/etc/vconsole.conf${NO_FORMAT}."
    jump
    printf "KEYMAP=us" > /etc/vconsole.conf
    printf "FONT=ter-116b" >> /etc/vconsole.conf
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

  local choice=0

  while true; do
    printf "====================\n"
    printf "${C_WHITE}[0] - ${C_WHITE}Catppuccin latte (light)${NO_FORMAT}\n"
    printf "${C_WHITE}[1] - ${C_CYAN}Catppuccin mocha (dark)${NO_FORMAT} [default] \n"
    printf "${C_WHITE}[2] - ${NO_FORMAT}Keep default TTY colors \n"
    printf "====================\n"
    
    read -p "[?] - Which theme do you prefer for your TTY? " response
    local response=${response:-1}
    case "$response" in
      [0])
        choice=0
        break
        ;;
      [1])
        choice=1
        break
        ;;
      [2])
        choice=2
        break
        ;;
      *)
        invalid_answer
        ;;
    esac
  done

  mkdir /etc/tty_themes.d

  if [[ $choice -eq 0 ]]; then
    echo "source /etc/tty_themes.d/tty_catppuccin_latte.sh" >> /etc/skel/.bashrc
    cat << EOF > /etc/tty_themes.d/tty_catppuccin_latte.sh
    __tty_theme() {
    [ "\$TERM" = 'linux' ] || return # Only run in a TTY

    printf "\e]P0eff1f5" # black         rgb(239, 241, 245)  #eff1f5
    printf "\e]P1d20f39" # red           rgb(210, 15, 57)    #d20f39
    printf "\e]P240a02b" # green         rgb(64, 160, 43)    #40a02b
    printf "\e]P3df8e1d" # brown         rgb(223, 142, 29)   #df8e1d
    printf "\e]P41e66f5" # blue          rgb(30, 102, 245)   #1e66f5
    printf "\e]P58839ef" # magenta       rgb(136, 57, 239)   #8839ef
    printf "\e]P6179299" # cyan          rgb(23, 146, 153)   #179299
    printf "\e]PF4c4f69" # light_gray    rgb(76, 79, 105)    #4c4f69
    printf "\e]P86c6f85" # gray          rgb(108, 111, 133)  #6c6f85
    printf "\e]P9e64553" # bold_red      rgb(230, 69, 83)    #e64553
    printf "\e]PA40a02b" # bold_green    rgb(64, 160, 43)    #40a02b
    printf "\e]PBdf8e1d" # bold_yellow   rgb(223, 142, 29)   #df8e1d
    printf "\e]PC04a5e5" # bold_blue     rgb(4, 165, 229)    #04a5e5
    printf "\e]PDea76cb" # bold_magenta  rgb(234, 118, 203)  #ea76cb
    printf "\e]PE209fb5" # bold_cyan     rgb(32, 159, 181)   #209fb5
    printf "\e]PF4c4f69" # bold_white    rgb(76, 79, 105)    #4c4f69

    clear # To fix the background
  }

  __tty_theme
EOF
  elif [[ $choice -eq 1 ]]; then
    echo "source /etc/tty_themes.d/tty_catppuccin_mocha.sh" >> /etc/skel/.bashrc
    cat << EOF > /etc/tty_themes.d/tty_catppuccin_mocha.sh
    __tty_theme() {
    [ "\$TERM" = 'linux' ] || return # Only run in a TTY

    printf "\e]P01e1e2e" # black         rgb(30, 30, 46)     #1e1e2e
    printf "\e]P1f38ba8" # red           rgb(243, 139, 168)  #f38ba8
    printf "\e]P2a6e3a1" # green         rgb(166, 227, 161)  #a6e3a1
    printf "\e]P3fab387" # brown         rgb(250, 179, 135)  #fab387
    printf "\e]P489b4fa" # blue          rgb(137, 180, 250)  #89b4fa
    printf "\e]P5cba6f7" # magenta       rgb(203, 166, 247)  #cba6f7
    printf "\e]P694e2d5" # cyan          rgb(148, 226, 213)  #94e2d5
    printf "\e]P79399b2" # light_gray    rgb(147, 153, 178)  #9399b2
    printf "\e]P8585b70" # gray          rgb(88, 91, 112)    #585b70
    printf "\e]P9eba0ac" # bold_red      rgb(235, 160, 172)  #eba0ac
    printf "\e]PAa6e3a1" # bold_green    rgb(166, 227, 161)  #a6e3a1
    printf "\e]PBf9e2af" # bold_yellow   rgb(249, 226, 175)  #f9e2af
    printf "\e]PCb4befe" # bold_blue     rgb(180, 190, 254)  #b4befe
    printf "\e]PDf5c2e7" # bold_magenta  rgb(245, 194, 231)  #f5c2e7
    printf "\e]PE89dceb" # bold_cyan     rgb(137, 220, 235)  #89dceb
    printf "\e]PFcdd6f4" # bold_white    rgb(205, 214, 244)  #cdd6f4

    clear # To fix the background
  }

  __tty_theme
EOF
  elif [[ $choice -eq 2 ]]; then
    continue
  fi

}

set_bashrc() {

  echo "PS1='\[\e[93m\][\[\e[97;1m\]\u\[\e[0;93m\]@\[\e[97m\]\h\[\e[93m\]]\[\e[91m\][\w]\[\e[93m\](\t)\[\e[0m\] \[\e[97m\]\$\[\e[0m\] '" >> /etc/skel/.bashrc
  echo "alias ll='command ls -lh --color=auto'" >> /etc/skel/.bashrc
  echo "alias ls='command ls --color=auto'" >> /etc/skel/.bashrc
  echo "alias ip='command ip -color=auto'" >> /etc/skel/.bashrc
  echo "alias grep='grep --color=auto'" >> /etc/skel/.bashrc

  cp /etc/skel/.bashrc /root
}

set_zshrc() {

  echo "# Lines configured by zsh-newuser-install" > /etc/skel/.zshrc
  echo "HISTFILE=~/.histfile" >> /etc/skel/.zshrc
  echo "HISTSIZE=1000" >> /etc/skel/.zshrc
  echo "SAVEHIST=1000" >> /etc/skel/.zshrc
  echo "bindkey -e" >> /etc/skel/.zshrc
  echo "# End of lines configured by zsh-newuser-install" >> /etc/skel/.zshrc
  
  echo "" >> /etc/skel/.zshrc
  echo "# PLUGINS #" >> /etc/skel/.zshrc
  echo "" >> /etc/skel/.zshrc
  
  echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /etc/skel/.zshrc
  echo "source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> /etc/skel/.zshrc
  echo 'PROMPT="%F{red}[%f%B%F{white}%n%f%b%F{red}@%f%F{white}%m%f%F{red}:%f%B%~%b%F{red}]%f(%F{red}%*%f)%F{red}%#%f "' >> /etc/skel/.zshrc
  
  echo "" >> /etc/skel/.zshrc
  echo "# ALIASES #" >> /etc/skel/.zshrc
  echo "" >> /etc/skel/.zshrc

  echo "alias ll='command ls -lh --color=auto'" >> /etc/skel/.zshrc
  echo "alias ls='command ls --color=auto'" >> /etc/skel/.zshrc
  echo "alias ip='command ip -color=auto'" >> /etc/skel/.zshrc
  echo "alias grep='grep --color=auto'" >> /etc/skel/.zshrc
}

set_vim_nvim() {

  cat << EOF > /etc/skel/.vimrc
  set number
  set relative number
EOF

  cat << EOF > /etc/skel/.config/nvim/init.vim
  set number
  set relative number
  syntax on
  set cursorline
EOF
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
    read -p "[?] - Will this user be sudo? [Y/n]" sudoResponse
    local sudoResponse=${sudoResponse:-Y}
    case "$sudoResponse" in
      [yY])
        sudo=""
        break
        ;;
      [nN])
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
    printf "\n"
    read -p "[?] - Would you like to create a user? [N/y] " response
    local response=${response:-N}
    case "$response" in
      [yY])
        create_user
        break
        ;;
      [nN])
        printf "\n"
        printf "${C_WHITE}> ${INFO} ${NO_FORMAT}No user will be created."
        jump
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

  jump

  printf "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} systemd-resolved.${NO_FORMAT}"
  systemctl enable systemd-resolved &> /dev/null

  set_time
  locales_gen
  set_hostname
  set_hosts
  set_vconsole
  set_pacman
  set_mkinitcpio
  set_root_passwd
  create_tty_theme
  set_bashrc
  set_zshrc
  set_vim_nvim
  ask_newuser
}