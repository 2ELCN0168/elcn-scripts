jump() {
  printf "\n\n"
}

invalid_answer() {
  printf "${C_WHITE}[!] -${C_RED} Not a valid answer.${NO_FORMAT}"
  jump
}