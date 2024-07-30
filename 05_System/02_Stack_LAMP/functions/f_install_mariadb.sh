install_mariadb() {

        if [[ $OS_TYPE == 'ARCHLINUX' ]]; then
                echo -e "> ${B_CYAN} Installing mariadb. ${NO_FORMAT}\n"
                ${PK_INSTALL} mariadb 
        elif [[ $OS_TYPE == 'RHEL' || $OS_TYPE == 'DEBIAN' ]]; then
                echo -e "> ${B_RED} Installing HTTPD. ${NO_FORMAT}\n"
                ${PK_INSTALL} mariadb-server
        fi
}
