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
    echo "${username} ALL=(ALL:ALL) ALL" > /etc/sudoers.d/$username
  fi

}