install_mariadb() {
        
        echo

        if [[ $OS_TYPE == 'ARCHLINUX' ]]; then
                echo -e "> ${B_CYAN} Installing mariadb. ${NO_FORMAT}\n"
                ${PK_INSTALL} mariadb 
                mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
                systemcl enable --now mariadb
        elif [[ $OS_TYPE == 'RHEL' || $OS_TYPE == 'DEBIAN' ]]; then
                echo -e "> ${B_RED} Installing HTTPD. ${NO_FORMAT}\n"
                ${PK_INSTALL} mariadb-server
                systemctl enable --now mariadb-server
        fi
}
