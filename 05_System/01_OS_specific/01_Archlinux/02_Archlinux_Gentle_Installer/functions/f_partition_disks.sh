# FUNCTION(S)
# ---
# This function initiates the partitioning depending on the BIOS mode.
# ---

partition_disk() {

  # FORMATTING DONE
  printf "\n"

  if [[ $UEFI -eq 1 ]]; then
    printf "${C_WHITE}> ${INFO} Creating two partitions for ${C_CYAN}GPT${NO_FORMAT} disk."
    jump

    if parted -s $user_disk mklabel gpt && \
       parted -s $user_disk mkpart primary 1Mib 512Mib && \
       parted -s $user_disk mkpart primary 512Mib 100%; then
      printf "${C_WHITE}> ${SUC} ${C_GREEN}Partitions created successfully for UEFI mode (GPT).${NO_FORMAT}"
      jump
    else
      printf "${C_WHITE}> ${ERR} ${C_RED}Error during partitionning ${user_disk} for UEFI mode (GPT).${NO_FORMAT}"
      jump
      exit 1
    fi

  elif [[ $UEFI -eq 0 ]]; then
    printf "${C_WHITE}> ${INFO} Creating two partitions for MBR disk.${NO_FORMAT}"

    if parted -s $user_disk mklabel msdos && \
       parted -s $user_disk mkpart primary 1Mib 512Mib && \
       parted -s $user_disk mkpart primary 512Mib 100%; then
      printf "${C_WHITE}> ${SUC} ${C_GREEN}Partitions created successfully for BIOS mode (MBR).${NO_FORMAT}"
      jump
    else
      printf "${C_WHITE}> ${ERR} ${C_RED}Error during partitionning ${user_disk} for BIOS mode (MBR).${NO_FORMAT}"
      jump
      exit 1
    fi
  fi
   sleep 1
}