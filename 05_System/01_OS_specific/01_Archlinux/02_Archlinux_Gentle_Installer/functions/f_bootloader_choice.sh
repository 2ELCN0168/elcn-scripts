# FUNCTION(S)
# ---
# This function, after getting the BIOS mode, asks the user which bootloader they want to use.
# Choices are : rEFInd (default), GRUB2, systemd-boot.
# ---

  bootloader_choice() {

  # FORMATTING DONE

  export bootloader=""
  
  if [[ UEFI -eq 1 ]]; then
    while true; do
      printf "==BOOTLOADER========"
      jump
      printf "${C_WHITE}[0] - ${C_CYAN}rEFInd${NO_FORMAT} (default) \n"
      printf "${C_WHITE}[1] - ${C_YELLOW}GRUB2${NO_FORMAT} \n"
      printf "${C_WHITE}[2] - ${C_RED}systemd-boot${NO_FORMAT} "
      jump
      printf "====================\n"
      
      read -p "Which one do you prefer? [0/1/2] -> " response
      response=${response:-0}
      case "$response" in
        [0])
          jump
          printf "${C_WHITE}> ${NO_FORMAT}We will install ${C_CYAN}rEFInd${NO_FORMAT}"
          jump
          bootloader="REFIND"
          break
          ;;
        [1])
          jump
          printf "${C_WHITE}> ${NO_FORMAT}We will install ${C_YELLOW}GRUB2${NO_FORMAT}"
          jump
          bootloader="GRUB"
          break
          ;;
        [2])
          jump
          printf "${C_WHITE}> ${NO_FORMAT}We will install ${C_RED}systemd-boot${NO_FORMAT}"
          jump
          bootloader="SYSTEMDBOOT"
          break
          ;;
        *)
          invalid_answer
          ;;
      esac
    done
  elif [[ UEFI -eq 0 ]]; then
    bootloader="GRUB"
  fi
}