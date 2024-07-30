secure_mariadb() {

        clear
        echo

        if [[ $OS_TYPE == 'ARCHLINUX' ]]; then
                echo -e "> ${B_CYAN} Launching mariadb-secure-installation. ${NO_FORMAT}\n"
                mariadb-secure-installation 
        elif [[ $OS_TYPE == 'RHEL' || $OS_TYPE == 'DEBIAN' ]]; then
                echo -e "> ${B_RED} Launching mariadb-secure-installation. ${NO_FORMAT}\n"
                mysql_secure_installation
        fi
}
