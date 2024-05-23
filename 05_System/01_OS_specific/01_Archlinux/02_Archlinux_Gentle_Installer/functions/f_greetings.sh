# FUNCTION(S)
# ---
# Greetings is the initialization function, it displays the first messages 
# before starting and ensure there's nothing mounted on /mnt
# ---

greetings() {
  #clear
  printf "\n${C_CYAN}███${C_RED}█${C_CYAN}█${C_YELLOW}█${C_CYAN}█${NO_FORMAT}"
  jump

  date
  printf "${C_CYAN}> ${C_WHITE}Welcome to this gently automated ${C_CYAN}Arch/\Linux${NO_FORMAT} ${C_WHITE}installer. ${C_CYAN}<${NO_FORMAT}"
  jump

  printf "${C_WHITE}> ${C_PINK}Before starting, make sure you have ${C_RED}any LVM ${C_PINK}configured on your disk, or it will ${C_RED}mess up${C_PINK} the script. You must delete any LV, VG and PV before starting.${NO_FORMAT}"
  jump

  # This unmounting action ensure to have nothing actually mounted on /mnt before starting
  umount -R /mnt &> /dev/null

  cp -a ../c_config.sh ../post_install/c_config.sh
}