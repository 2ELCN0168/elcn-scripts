# FUNCTION(S)
# ---
# This function try to determinates if the system has booted in UEFI mode or in BIOS mode.
# ---

get_bios_mode() {

  # FORMATTING DONE

  export UEFI=0

  if cat /sys/firmware/efi/fw_platform_size &> /dev/null; then
    printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Running in ${C_CYAN}UEFI${NO_FORMAT} mode.\n"
    printf "${C_CYAN}You are using UEFI mode, you have the choice for the bootloader...${NO_FORMAT}"
    jump
    UEFI=1
  else
    printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Running in ${C_RED}BIOS${NO_FORMAT} mode.\n"
    printf "${C_YELLOW}No choice for you. You would have been better off using UEFI mode. We will install GRUB2.${NO_FORMAT}"
    jump
    UEFI=0
  fi
}
