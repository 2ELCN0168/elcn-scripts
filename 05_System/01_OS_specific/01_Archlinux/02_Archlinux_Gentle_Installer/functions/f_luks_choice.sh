# FUNCTION(S)
# ---
# This function asks the user if they want to use LUKS to encrypt their filesystem.
# ---

luks_choice() {

  export wantEncrypted=0

  # FORMATTING DONE
  while true; do
    read -p "Do you want your system to be encrypted with LUKS? [y/N] -> " response
    response=${response:-N}
    case "$response" in
      [yY])
        printf "\n"
        printf "${C_WHITE}> ${INFO} ${C_GREEN}cryptsetup${NO_FORMAT} will be installed."
        jump
        wantEncrypted=1
        break
        ;;
      [nN])
        printf "\n"
        printf "${C_WHITE}> ${INFO} ${C_RED}cryptsetup${NO_FORMAT} won't be installed."
        jump
        wantEncrypted=0
        break
        ;;
      *)
        invalid_answer
        ;;
    esac
  done
}