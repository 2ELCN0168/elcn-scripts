paru() {

  while true; do
    read -p "[?] - Would you like to install paru? It's an AUR helper like yay. [y/N] " response
    local response=${response:-N}
    case "$response" in 
      [yY])
        printf "${C_WHITE}> ${INFO} ${C_WHITE}Installing ${C_CYAN}paru${NO_FORMAT}..."
        su $username
        cd 
        git clone https://aur.archlinux.org/paru.git
        cd paru
        makepkg -si && cd ..
        exit
        mv /home/$username/paru /usr/src

        if paru --version; then
          printf "${C_WHITE}> ${SUC} ${C_WHITE}${C_CYAN}paru${NO_FORMAT} successfully installed."
        else
          printf "${C_WHITE}> ${ERR} ${C_WHITE}Cannot install ${C_CYAN}paru${NO_FORMAT}."
        fi

      [nN])
        break
        ;;
      *)
        invalid_answer
        ;;
    esac
  done
}