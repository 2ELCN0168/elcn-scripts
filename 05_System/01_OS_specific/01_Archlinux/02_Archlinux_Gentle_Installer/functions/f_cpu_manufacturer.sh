# FUNCTION(S)
# ---
# This function aims to get the CPU manufacturer to install the apropriate microcode in a later stage.
# ---

get_cpu_brand() {

  local vendor
  export cpuBrand=""

  vendor=$(lscpu | grep -i vendor | awk '{ print $3 }' | head -1)

  case "$vendor" in
    "GenuineIntel")
      printf "${C_WHITE}> ${INFO} ${C_CYAN}INTEL CPU${NO_FORMAT} detected."
      jump
      cpuBrand="INTEL"
      ;;
    "AuthenticAMD")
      printf "${C_WHITE}> ${INFO} ${C_RED}AMD CPU${NO_FORMAT} detected."
      jump
      cpuBrand="AMD"
      ;;
    *)  
      printf "${C_WHITE}> ${INFO} ${C_YELLOW}Could not detect your CPU vendor. No microcode will be installed.${NO_FORMAT}"
      jump
      cpuBrand="UNKNOWN"
      ;;
  esac
}