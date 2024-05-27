ending() {

  printf "${C_WHITE}> ${INFO} ${C_GREEN}Congratulations. The system has been installed.${NO_FORMAT}"
  jump

  if fastfetch --version &> /dev/null; then
      fastfetch
  fi
  jump
}