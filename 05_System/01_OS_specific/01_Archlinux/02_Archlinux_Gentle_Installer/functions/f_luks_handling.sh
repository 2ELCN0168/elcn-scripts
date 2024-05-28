# FUNCTION(S)
# ---
# This function creates a LUKS format partition if the user answered "yes" to one of the first questions.
# ---

luks_handling() {

    # FORMATTING DONE
    printf "${C_WHITE}> ${INFO} Starting to encrypt your new system..."
    jump

    if cryptsetup luksFormat ${root_part}; then
      printf "\n"
      printf "${C_WHITE}> ${SUC} ${C_GREEN}Successfully created LUKS partition on ${root_part}.${NO_FORMAT}"
      jump
    else
      printf "\n"
      printf "${C_WHITE}> ${ERR} ${C_RED}Error during LUKS partition creation on ${root_part}.${NO_FORMAT}"
      jump
      exit 1
    fi

    printf "${C_WHITE}> ${INFO} Opening the new encrypted volume."
    jump

    cryptsetup open ${root_part} root
    
    printf "\n"
    printf "${C_WHITE}> ${INFO} Replacing ${root_part} by ${C_PINK}/dev/mapper/root.${NO_FORMAT}"
    jump
    
    export root_part="/dev/mapper/root"
}