install_php() {

         echo

        if [[ $OS_TYPE == 'ARCHLINUX' ]]; then
                echo -e "> ${B_CYAN} Installing php. ${NO_FORMAT}\n"
                ${PK_INSTALL} --noconfirm php
                sleep 2
                sed -i 's/^;extension=pdo_mysql/extension=pdo_mysql/' /etc/php/php.ini
                sed -i 's/^;extension=mysqli/extension=mysqli/' /etc/php/php.ini
                systemcl enable --now php
        elif [[ $OS_TYPE == 'DEBIAN' ]]; then
                echo -e "> ${B_RED} Installing php. ${NO_FORMAT}\n"
                ${PK_INSTALL} -y php libapache2-mod-php php-mysql php-cli
        elif [[ $OS_TYPE == 'RHEL' ]];then
                echo -e "> ${B_RED} Installing php. ${NO_FORMAT}\n"
                ${PK_INSTALL} -y epel-release
                ${PK_INSTALL} -y php-cli php php-cli php-fpm php-mysqlnd
        fi
                systemctl enable --now php
