# CREATE PACMAN HOOKS 

b_display_state() {

  jump
  printf "${C_WHITE}> ${INFO} Creating a pacman hook for ${C_WHITE}$1.${NO_FORMAT}"
}

e_display_state() {

  jump
  printf "${C_WHITE}> ${SUC} Created a pacman hook for ${C_WHITE}$1.${NO_FORMAT}"
}

refind_hook() {

  # This hook launches refind-install after a package update.

  if [[ "$bootloader" != 'REFIND' ]]; then
    return 1;
  fi

  local hookName="rEFInd"

  b_display_state "$hookName"

  cat << EOF > /etc/pacman.d/hooks/refind.hook
  [Trigger]
  Operation=Upgrade
  Type=Package
  Target=refind

  [Action]
  Description=Updating rEFInd to ESP...
  When=PostTransaction
  Exec=/usr/bin/refind-install
EOF

  e_display_state "$hookName"
}

bash_zsh_hook() {

  # This hook avoids bash to be uninstalled.
  local hookName="bash and zsh"

  b_display_state "$hookName"

  cat << EOF > /etc/pacman.d/hooks/bash_zsh_no_remove.hook
  [Trigger]
  Operation=Remove
  Type=Package
  Target=bash
  Target=zsh

  [Action]
  Description=CAN'T UNINSTALL BASH/ZSH
  When=PreTransaction
  Exec=/usr/bin/false
  AbortOnFail
EOF

  e_display_state "$hookName"
}

pacman_hook() {

  # This hook avoids bash to be uninstalled.
  local hookName="pacman"

  b_display_state "$hookName"

  cat << EOF > /etc/pacman.d/hooks/pacman_no_remove.hook
  [Trigger]
  Operation=Remove
  Type=Package
  Target=pacman

  [Action]
  Description=CAN'T UNINSTALL PACMAN
  When=PreTransaction
  Exec=/usr/bin/false
  AbortOnFail
EOF

  e_display_state "$hookName"
}

linux_hook() {

  # This hook avoids bash to be uninstalled.
  local hookName="base system (linux)"

  b_display_state "$hookName"

  cat << EOF > /etc/pacman.d/hooks/system_no_remove.hook
  [Trigger]
  Operation=Remove
  Type=Package
  Target=coreutils
  Target=linux
  Target=linux-firmware
  Target=systemd
  Target=base
  Target=base-devel

  [Action]
  Description=CAN'T UNINSTALL BASE SYSTEM
  When=PreTransaction
  Exec=/usr/bin/false
  AbortOnFail
EOF

  e_display_state "$hookName"
}

create_pacman_hooks() {

  if ! ls /etc/pacman.d/hooks; then
    mkdir /etc/pacman.d/hooks &> /dev/null
  fi
  
  refind_hook
  bash_zsh_hook
  pacman_hook
  linux_hook
}