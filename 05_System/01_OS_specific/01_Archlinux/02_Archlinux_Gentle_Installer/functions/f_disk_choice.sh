# FUNCTION(S)
# ---
# This function asks the user which disk they want to use.
# It verifies if the input exists and asks again if it doesn't.
# ---

Nask_disk() {

 

    # NEED TO BE REDONE
    while true; do
        lsblk
        read -p "Do you have a NVMe SSD (0) or a HDD (1=default)? (e.g., nvmeXn1 for NVMe SSD or sdX for HDD) -> " diskType
        # Check if disk exists and is not sr0 or loop0
        diskType=${diskType:-1}
        case "$diskType" in
            [0])
                SSD=1
                echo -e "You have a NVMe SSD."
                partitionType="p"
                break
                ;;
            [1])
                HDD=1
                echo -e "You have a HDD or a M.2 SSD."
                break
                ;;
            *)
                echo -e "${C_RED}Not a valid answer.${NO_FORMAT}"
                ;;
        esac
    done

    while true; do
        lsblk
        read -p "Enter the name of the disk to format (e.g., nvmeXn1, sdX (default=sda)) -> " disk
        # Check if disk exists and is not sr0 or loop0
        disk=${disk:-sda}
        if lsblk | grep -q "^$disk" && [[ ! $disk =~ ^(sr0|loop0)$ ]]; then 
            diskToUse="$disk"
            break
        else
            echo -e "${C_RED}Disk not found. Please, enter a valid disk name.${NO_FORMAT}"
        fi
    done

    finalDisk="/dev/${diskToUse}"
    finalPartBoot="/dev/${diskToUse}${partitionType}1"
    finalPartRoot="/dev/${diskToUse}${partitionType}2"
}

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
    printf "====================\n"
    lsblk -d --output NAME | grep -vE 'NAME|sr0|loop0'
    printf "====================\n"
    read -p "Which block device do you want to use? Type it correctly -> " response
    response=${response:-sda}
    
    if [[ -e /dev/$response ]]; then
      disk="$response"
      printf "\n"
      printf "${C_WHITE}> ${INFO} ${NO_FORMAT}The disk to use is ${C_GREEN}/dev/${disk}${NO_FORMAT}"
      jump

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