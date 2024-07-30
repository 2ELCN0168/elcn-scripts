install_mariadb() {
        
        echo

        if [[ $OS_TYPE == 'ARCHLINUX' ]]; then
                echo -e "> ${B_CYAN} Installing mariadb. ${NO_FORMAT}\n"
                ${PK_INSTALL} --noconfirm mariadb 
                mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
                sleep 2
                systemcl enable --now mariadb
        elif [[ $OS_TYPE == 'RHEL' || $OS_TYPE == 'DEBIAN' ]]; then
                echo -e "> ${B_RED} Installing mariadb-server. ${NO_FORMAT}\n"
                ${PK_INSTALL} -y mariadb-server
                systemctl enable --now mariadb-server
        fi
}
