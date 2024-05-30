ending() {
  
  printf "\n"
  printf "${C_WHITE}> ${SUC} ${C_GREEN}Congratulations. The system has been installed.${NO_FORMAT}"
  jump

  if fastfetch --version &> /dev/null; then
      if [[ $nKorea -eq 1 ]]; then
        fastfetch --logo redstar
      else
        fastfetch
      fi
  fi
  jump

  printf "${C_WHITE}> ${INFO} ${C_WHITE}You can now reboot to your new system or make adjustments to your liking.${NO_FORMAT}"
  jump

  printf "${C_WHITE}>> [${C_CYAN}END${C_WHITE}] <<${NO_FORMAT}"
  jump
}