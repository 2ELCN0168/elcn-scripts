install_apache() {

        if [[ $OS_TYPE == 'DEBIAN' || $OS_TYPE == 'ARCHLINUX' ]]; then
                echo -e "> ${B_RED} Installing Apache2. ${NO_FORMAT}\n"
                ${PK_INSTALL} apache
        elif [[ $OS_TYPE == 'RHEL' ]]; then
                echo -e "> ${B_RED} Installing HTTPD. ${NO_FORMAT}\n"
                ${PK_INSTALL} httpd
        fi
}
