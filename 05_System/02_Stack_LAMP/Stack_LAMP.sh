#! /bin/bash

source_files() {
        
        local f_path="./functions"

        source ./config/c_config.sh
        source ./config/c_formatting.sh

        source ${f_path}/f_starting.sh
        source ${f_path}/f_check_euid.sh
        source ${f_path}/f_pmanager_detector.sh
        source ${f_path}/f_install_apache.sh
        source ${f_path}/f_install_mariadb.sh
        source ${f_path}/f_install_php.sh
        source ${f_path}/f_secure_mariadb.sh
        source ${f_path}/f_check_installations.sh
        source ${f_path}/f_ending.sh
}

__main() {
        source_files

        # BEGINNING
        starting

        # VERIFY IF USER IS ROOT
        check_euid

        # DETECT PACKAGE MANAGER
        pmanager_detector

        # INSTALL APACHE
        install_apache

        # INSTALL MARIADB
        install_mariadb

        # INSTALL PHP + MODULES
        install_php

        # SECURE MARIADB
        secure_mariadb

        # CHECK INSTALLATIONS
        check_installations

        # ENDING
        ending
}

__main
