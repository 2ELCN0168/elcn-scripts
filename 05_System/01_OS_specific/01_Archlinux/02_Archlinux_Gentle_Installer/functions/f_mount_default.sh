mount_default() {

  # FORMATTING DONE
  printf "${C_WHITE}> ${NO_FORMAT}Mounting ${C_GREEN}${root_part}${NO_FORMAT} to /mnt\n"
  mount ${root_part} /mnt 
    
  printf "${C_WHITE}> ${NO_FORMAT}Mounting ${C_GREEN}${boot_part}${NO_FORMAT} to /mnt/boot\n"
  mount --mkdir ${boot_part} /mnt/boot
}