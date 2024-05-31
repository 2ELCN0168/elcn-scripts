set_time() {

  printf "${C_WHITE}> ${INFO} Setting system clock to UTC."
  jump

  if hwclock --systohc &> /dev/null; then
    printf "${C_WHITE}> ${SUC} ${C_GREEN}Successfully set up system clock to UTC.${NO_FORMAT}"
  else
    printf "${C_WHITE}> ${WARN} ${C_YELLOW}Failed to setting system clock to UTC.${NO_FORMAT}"
  fi
  jump

  printf "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} systemd-timesyncd.${NO_FORMAT}"
  jump
  if systemctl enable systemd-timesyncd &> /dev/null; then
    printf "${C_WHITE}> ${SUC} ${C_GREEN}Successfully set up NTP.${NO_FORMAT}"
  else
    printf "${C_WHITE}> ${WARN} ${C_YELLOW}Failed to setting up NTP.${NO_FORMAT}"
  fi
  jump

  nKorea=0

  while true; do
    printf "==TIME=============="
    jump
    printf "${C_WHITE}[0] - ${C_CYAN}FRANCE${NO_FORMAT} [default]\n"
    printf "${C_WHITE}[1] - ${C_WHITE}ENGLAND${NO_FORMAT} \n"
    printf "${C_WHITE}[2] - ${C_WHITE}US (New-York)${NO_FORMAT} \n"
    printf "${C_WHITE}[3] - ${C_RED}Japan${NO_FORMAT} \n"
    printf "${C_WHITE}[4] - ${C_CYAN}South Korea (Seoul)${NO_FORMAT} \n"
    printf "${C_WHITE}[5] - ${C_RED}Russia (Moscow)${NO_FORMAT} \n"
    printf "${C_WHITE}[6] - ${C_RED}China (CST - Shanghai)${NO_FORMAT} \n"
    printf "${C_WHITE}[7] - ${C_RED}North Korea (Pyongyang)${NO_FORMAT} "
    jump
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
        nKorea=1
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
}

set_vconsole() {

  # Creating /mnt/etc/vconsole.conf
    printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Creating the file ${C_PINK}/etc/vconsole.conf${NO_FORMAT}."
    jump
    local keymap=""
    while true; do
      printf "==KEYMAP============"
      jump
      printf "${C_WHITE}[0] - ${C_WHITE}US INTL. - QWERTY${NO_FORMAT} [default]\n"
      printf "${C_WHITE}[1] - ${C_WHITE}US - QWERTY${NO_FORMAT} \n"
      printf "${C_WHITE}[2] - ${C_WHITE}FR - AZERTY${NO_FORMAT}"
      jump
      printf "====================\n"
      read -p "[?] - Select your keymap " response
      local response=${response:-0}
      case "$response" in
        [0])
          printf "\n"
          keymap="us-acentos"
          printf "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose ${C_PINK}${keymap}${NO_FORMAT}."
          break
          ;;
        [1])
          printf "\n"
          keymap="us"
          printf "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose ${C_PINK}${keymap}${NO_FORMAT}."
          break
          ;;
        [2])
          printf "\n"
          keymap="fr"
          printf "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose ${C_PINK}${keymap}${NO_FORMAT}."
          break
          ;;
        *)
          invalid_answer
          ;;
      esac
    done

    jump
    echo "KEYMAP=${keymap}" > /etc/vconsole.conf
    echo "FONT=ter-116b" >> /etc/vconsole.conf
}

set_pacman() {

  # Uncomment #Color and #ParallelDownloads 5 in /etc/pacman.conf AGAIIIIN
  printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Uncommenting ${C_WHITE}'Color'${NO_FORMAT} and ${C_WHITE}'ParallelDownloads 5'${NO_FORMAT} in ${C_PINK}/mnt/etc/pacman.conf${NO_FORMAT} AGAIIIIN."
  jump

  #sed -i '/^\s*#\(Color\|ParallelDownloads\)/ s/^#//' /etc/pacman.conf
  sed -i '/^#\(Color\|ParallelDownloads\)/s/^#//' /etc/pacman.conf

  if tldr -v &> /dev/null; then
    tldr --update &> /dev/null
  fi
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

set_bashrc() {

  echo "PS1='\[\e[93m\][\[\e[97;1m\]\u\[\e[0;93m\]@\[\e[97m\]\h\[\e[93m\]]\[\e[91m\][\w]\[\e[93m\](\t)\[\e[0m\] \[\e[97m\]\$\[\e[0m\] '" >> /etc/skel/.bashrc
  echo "alias ll='command ls -lh --color=auto'" >> /etc/skel/.bashrc
  echo "alias ls='command ls --color=auto'" >> /etc/skel/.bashrc
  echo "alias ip='command ip -color=auto'" >> /etc/skel/.bashrc
  echo "alias grep='grep --color=auto'" >> /etc/skel/.bashrc

  if [[ $nKorea -eq 1 ]]; then
    echo "alias fastfetch='fastfetch --logo redstaros'" >> /etc/skel/.bashrc
  fi

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
  if [[ $nKorea -eq 1 ]]; then
    echo "alias fastfetch='fastfetch --logo redstaros'" >> /etc/skel/.zshrc
  fi

  cp /etc/skel/.zshrc /root
}

set_vim_nvim() {

  cat << EOF > /etc/skel/.vimrc
  set number
  set relativenumber
EOF

  cp /etc/skel/.vimrc /root

  mkdir -p /etc/skel/.config/nvim
  cat << EOF > /etc/skel/.config/nvim/init.vim
  set number
  set relativenumber
  syntax on
  set cursorline
EOF

  cp -r /etc/skel/.config /root

}

create_user() {

  username=""
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
    read -p "[?] - Would you like to create a user? [N/y] " createUser
    createUser=${createUser:-N}
    case "$createUser" in
      [yY])
        create_user
        createUser="Y"
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



  set_time
  locales_gen
  set_hostname
  set_hosts
  set_vconsole
  set_pacman
  set_mkinitcpio
  set_root_passwd
  set_bashrc
  set_zshrc
  set_vim_nvim
  ask_newuser
}