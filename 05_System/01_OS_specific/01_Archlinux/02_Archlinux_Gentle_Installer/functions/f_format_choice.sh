# FUNCTION(S)
# ---
# This function format the boot partition to FAT32 and then call other functions,
# depending on the filesystem the user chose, and even if they chose to use LUKS.
# ---

source ./functions/f_luks_handling.sh

format_partitions() {

  # FORMATTING DONE
  printf "${C_WHITE}> ${INFO} ${C_CYAN}Formatting ${boot_part} to FAT32.${NO_FORMAT}"
  jump
  
  if mkfs.fat -F 32 -n ESP ${boot_part} &> /dev/null; then
    printf "${C_WHITE}> ${SUC} ${C_GREEN}Successfully formatted ${boot_part} to FAT32.${NO_FORMAT}"
    jump
  else
    printf "${C_WHITE}> ${ERR} ${C_RED}Error during formatting ${boot_part} to FAT32.${NO_FORMAT}"
    jump
    exit 1
  fi

  if [[ $wantEncrypted -eq 1 ]]; then
    luks_handling
  fi

  case "$filesystem" in
    BTRFS)
      btrfs_handling
      ;;
    XFS|EXT4)
      fs_handling
      ;;
    *)
      exit 1
      ;;
  esac
}