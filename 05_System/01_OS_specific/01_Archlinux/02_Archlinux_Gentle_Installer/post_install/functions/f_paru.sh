install_paru() {

  while true; do

    local testMem=$(free -m | head -2 | tail -1 | awk '{print $2}')

    if [[ $testMem -gt 7000 ]]; then
      break
    fi
    printf "[?] - Would you like to install paru? It's an AUR helper like yay. [y/N]\n"
    read -p "[?] - Warning, this can take some time... " response
    local response=${response:-N}
    if [[ ! $createUser == 'Y' ]]; then
      break
    fi
    case "$response" in 
      [yY])
        printf "${C_WHITE}> ${INFO} ${C_WHITE}Installing ${C_CYAN}paru${NO_FORMAT}..."
        su $username
        git clone https://aur.archlinux.org/paru.git /home/$username/paru
        cd /home/$username/paru
        makepkg -si
        exit
        mv /home/$username/paru /usr/src

        if paru --version; then
          printf "${C_WHITE}> ${SUC} ${C_WHITE}${C_CYAN}paru${NO_FORMAT} successfully installed."
        else
          printf "${C_WHITE}> ${ERR} ${C_WHITE}Cannot install ${C_CYAN}paru${NO_FORMAT}."
        fi
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