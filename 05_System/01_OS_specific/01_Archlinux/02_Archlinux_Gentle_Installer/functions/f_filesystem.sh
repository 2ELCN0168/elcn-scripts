# FUNCTION(S)
# ---
# This function asks the user which filesystem they want to use. 
# Choices are BTRFS (default), XFS, EXT4.
# ---

filesystem_choice() {

  export filesystem=""

  while true; do
    printf "====================\n"
    printf "${C_WHITE}[0] - ${C_YELLOW}BTRFS${NO_FORMAT} (default) \n"
    printf "${C_WHITE}[1] - ${C_CYAN}XFS${NO_FORMAT} \n"
    printf "${C_WHITE}[2] - ${C_RED}EXT4${NO_FORMAT} \n"
    printf "====================\n"
    
    read -p "Which filesystem do you want to use? [0/1/2] -> " response
    response=${response:-0} # Default is BTRFS if no response given
    jump
    case "$response" in
      [0])
        filesystem="BTRFS"
        printf "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose ${C_WHITE}${filesystem}${NO_FORMAT}"
        jump
        break
        ;;
      [1])
        filesystem="XFS"
        printf "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose ${C_WHITE}${filesystem}${NO_FORMAT}"
        jump
        break
        ;;
      [2])
        filesystem="EXT4"
        printf "${C_WHITE}> ${INFO} ${NO_FORMAT}You chose ${C_WHITE}${filesystem}${NO_FORMAT}"
        jump
        break
        ;;
      *)
        invalid_answer
        ;;
    esac
  done
}