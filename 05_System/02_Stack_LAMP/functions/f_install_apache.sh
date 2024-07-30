install_apache() {

        if [[ $OS_TYPE == 'ARCHLINUX' ]]; then
                echo -e "> ${B_CYAN} Installing Apache2. ${NO_FORMAT}\n"
                ${PK_INSTALL} apache
        elif [[ $OS_TYPE == 'DEBIAN' ]]; then
                echo -e "> ${B_RED} Installing Apache2. ${NO_FORMAT}\n"
                ${PK_INSTALL} apache
        elif [[ $OS_TYPE == 'RHEL' ]]; then
                echo -e "> ${B_RED} Installing HTTPD. ${NO_FORMAT}\n"
                ${PK_INSTALL} httpd
        fi
}
