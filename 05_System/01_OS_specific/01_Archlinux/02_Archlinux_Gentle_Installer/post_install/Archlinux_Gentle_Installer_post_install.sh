#! /bin/bash

source_files() {

    local f_path="/post_install/functions"

    #source ./c_config.sh
    source $f_path/f_formatting.sh
    source $f_path/f_greetings_pi.sh
    source $f_path/f_configs.sh
    source $f_path/f_install_bootloader.sh
    source $f_path/f_theming.sh
    source $f_path/f_pacman_hooks.sh
    source $f_path/f_install_frw.sh
    source $f_path/f_paru.sh
    source $f_path/f_ending.sh
}

# SOURCE FILES
source_files

# START SECOND PART
greetings_pi

# CHANGE MULTIPLE CONFIG FILES
make_config

# INSTALL BOOTLOADER
install_bootloader

# PACMAN HOOKS CREATION
create_pacman_hooks

# INSTALL FIREWALL + SSHGUARD
install_frw

# THEMING
create_themes

# INSTALL PARU
install_paru
systemctl enable systemd-resolved &> /dev/null
# ENDING
ending

#rm -rf /post_install