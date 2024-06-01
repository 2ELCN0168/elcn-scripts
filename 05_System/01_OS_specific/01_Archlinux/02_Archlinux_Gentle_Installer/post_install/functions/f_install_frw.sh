install_frw() {

  jump
  printf "${C_WHITE}> ${INFO} Installing ${C_WHITE}nftables.${NO_FORMAT}"
  jump

  if ! pacman -S nftables --noconfirm; then
    printf "\n"
    printf "${C_WHITE}> ${ERR} Cannot install ${C_WHITE}nftables.${NO_FORMAT}"
  else
    printf "\n"
    printf "${C_WHITE}> ${SUC} Installed ${C_WHITE}nftables.${NO_FORMAT}"
    jump
    printf "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} nftables.${NO_FORMAT}"
    systemctl enable nftables &> /dev/null
  fi

  jump

  printf "${C_WHITE}> ${INFO} Installing ${C_WHITE}sshguard.${NO_FORMAT}"
  jump
  
  if ! pacman -S nftables --noconfirm; then
    printf "\n"
    printf "${C_WHITE}> ${ERR} Cannot install ${C_WHITE}sshguard.${NO_FORMAT}"
  else
    printf "\n"
    printf "${C_WHITE}> ${SUC} Installed ${C_WHITE}sshguard.${NO_FORMAT}"
    jump
    printf "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} sshguard.${NO_FORMAT}"
    systemctl enable sshguard &> /dev/null
  fi

  jump
}