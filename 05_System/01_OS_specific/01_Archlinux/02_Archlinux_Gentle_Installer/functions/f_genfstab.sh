gen_fstab() {

  # Generate /etc/fstab of the new system
  jump
  printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Generating ${C_PINK}/mnt/etc/fstab${NO_FORMAT} file."
  jump
  if genfstab -U /mnt >> /mnt/etc/fstab; then
    printf "${C_WHITE}> ${SUC} ${NO_FORMAT}Generated ${C_PINK}/mnt/etc/fstab${NO_FORMAT} file."
  else
    printf "${C_WHITE}> ${WARN} ${NO_FORMAT}Failed to generate ${C_PINK}/mnt/etc/fstab${NO_FORMAT} file."
  fi

  jump
}