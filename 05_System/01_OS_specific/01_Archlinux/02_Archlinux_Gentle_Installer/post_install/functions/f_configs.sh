make_config() {

  printf "${C_WHITE}> ${INFO} ${C_CYAN}Setting system clock to UTC${NO_FORMAT}."
  if hwclock --systohc; then
    printf "${C_WHITE}> ${SUC} ${C_CYAN}System clock set to UTC${NO_FORMAT}."
  else
    printf "${C_WHITE}> ${WARN} ${C_CYAN}Failed to set system clock to UTC${NO_FORMAT}."
  printf "${C_WHITE}> ${INFO} systemctl ${C_GREEN}enable${NO_FORMAT} NetworkManager"
  systemctl enable NetworkManager &> /dev/null

  printf "${C_GREEN}Generating locales...${NO_FORMAT}"
  locale-gen &> /dev/null
  printf "${C_GREEN}Locales generated successfully.${NO_FORMAT}"

  printf "${C_YELLOW}Changing root password...${NO_FORMAT}"
  while true; do
    if passwd; then
    break
    fi
  done
}