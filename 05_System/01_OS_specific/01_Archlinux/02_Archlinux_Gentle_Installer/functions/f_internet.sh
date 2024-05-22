# FUNCTION(S)
# ---
# The first function will test internet.
# The second will launch iwctl utility to let the user configure internet
# ---

test_internet() {

  export attempt=0
  export max_attempts=3

  while (( $attempt < $max_attempts )); do
    if ping -c 3 1.1.1.1 &> /dev/null; then
      printf "${C_WHITE}> ${SUC} ${C_GREEN}Internet connection detected.${NO_FORMAT}"
      jump
      break
    elif ! ping -c 3 1.1.1.1 &> /dev/null; then
      printf "${C_WHITE}> ${WARN} ${C_RED}No Internet connection detected.${NO_FORMAT}"
      jump
      run_iwctl
    fi
    (( attempt++ ))
  done

  if [[ $attempt -ge $max_attempts ]]; then
    printf "${C_WHITE}> ${ERR} ${C_RED}Max attempts reached. Exiting.${NO_FORMAT}"
    exit 1
  fi
}

run_iwctl() {

  read -p "[?] - Would you like to run the iwctl utility to setup a wifi connection? [Y/n] " response
  local response=${response:-Y}
  case "$response" in 
    [yY])
      iwctl
      ;;
    [nN])
      exit 1
      ;;
    *)
      invalid_answer
      ;;
  esac
}