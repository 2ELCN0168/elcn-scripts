# FUNCTION(S)
# ---
# lvm_luks_deletion() will try to delete any present LVM even if it's on another disk.
# It will also try to close a LUKS partition before we format it in a next step.
# ---

lvm_luks_try() {

  local result=0

  if pvscan --cache | grep -q '/dev'; then
    printf "${C_WHITE}> ${INFO} ${C_PINK} A LVM is detected.${NO_FORMAT}"
    jump
    result=$result+1
  fi

  if lsblk -f | grep -qi 'LUKS'; then
    printf "${C_WHITE}> ${INFO} ${C_PINK} LUKS partition is detected.${NO_FORMAT}"
    jump
    result=$result+2
  fi

  if [[ $result -eq 0 ]]; then
    printf "${C_WHITE}> ${INFO} ${C_YELLOW}It seems that there is no ${C_CYAN}LVM ${C_YELLOW}nor${C_CYAN} LUKS${C_YELLOW}, continue...${NO_FORMAT}"
    jump
  elif [[ $result -eq 1 ]]; then
    lvm_deletion
  elif [[ $result -eq 2 ]]; then
    luks_deletion 
  elif [[ $result -eq 3 ]]; then
    luks_deletion
    lvm_deletion
  fi
}

lvm_deletion() {

  while true; do
    read -p "[?] - Do you want to wipe any present LVM? [Y/n] " response
    local response="${response:-Y}"
    jump
    case "$response" in
      [yY])
        lvremove -f -y /dev/mapper/VG_Archlinux-* &> /dev/null
        vgremove -f -y VG_Archlinux &> /dev/null
        pvremove -f -y $(pvscan | head -1 | awk '{ print $2 }') &> /dev/null
        printf "${C_WHITE}> ${SUC} ${C_PINK} LVM deleted.${NO_FORMAT}"
        jump
        break
        ;;
      [nN])
        printf "${C_WHITE}> ${WARN} ${C_PINK} No LVM will be deleted.${NO_FORMAT}"
        jump
        break
        ;;
      *)
        invalid_answer
        ;;
    esac
  done
}

luks_deletion() {

  while true; do
    read -p "[?] - Do you want to close any present LUKS partition? [Y/n] " response
    local response="${response:-Y}"
    printf "\n"
    case "$response" in
      [yY])
        cryptsetup close root &> /dev/null
        printf "${C_WHITE}> ${SUC} ${C_PINK} LUKS partition closed.${NO_FORMAT}"
        break
        ;;
      [nN])
        printf "${C_WHITE}> ${WARN} ${C_PINK} No LUKS parititon will be closed.${NO_FORMAT}"
        break
        ;;
      *)
        invalid_answer
        ;;
    esac
  done
  jump
}