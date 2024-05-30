# FUNCTION(S)
# ---
# This function asks the user which disk they want to use.
# It verifies if the input exists and asks again if it doesn't.
# ---

disk_choice() {

  export user_disk="" # Former was finalDisk
  export disk=""
  export partitionType=""
  export boot_part="" # Former was finalPartBoot
  export root_part="" # Former was finalPartRoot

  # finalDisk="/dev/${diskToUse}"
  # finalPartBoot="/dev/${diskToUse}${partitionType}1"
  # finalPartRoot="/dev/${diskToUse}${partitionType}2"

  while true; do
    printf "==DISK=============="
    jump
    lsblk -d --output NAME | grep -vE 'NAME|sr0|loop0'
    printf "\n"
    printf "====================\n"
    read -p "Which block device do you want to use? Type it correctly -> " response
    response=${response:-sda}
    
    if [[ -e /dev/$response ]]; then
      disk="$response"
      printf "\n"
      printf "${C_WHITE}> ${INFO} ${NO_FORMAT}The disk to use is ${C_GREEN}/dev/${disk}${NO_FORMAT}"
      printf "\n"

      if [[ $disk =~ nvme... ]]; then 
      partitionType="p"
      fi

      user_disk="/dev/${disk}" # Former was finalDisk
      boot_part="${user_disk}${partitionType}1" # Former was finalPartBoot
      root_part="${user_disk}${partitionType}2" # Former was finalPartRoot
      
      break
    
    else
      printf "\n"
      invalid_answer
      continue
    fi
  done
}