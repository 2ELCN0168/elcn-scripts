install_apache() {

        if [[ $OS_TYPE == 'ARCHLINUX' ]]; then
                echo -e "> ${B_CYAN} Installing Apache2. ${NO_FORMAT}\n"
                ${PK_INSTALL} --noconfirm apache
                systemctl enable --now httpd
        elif [[ $OS_TYPE == 'DEBIAN' ]]; then
                echo -e "> ${B_RED} Installing Apache2. ${NO_FORMAT}\n"
                ${PK_INSTALL} -y apache
                systemctl enable --now apache
        elif [[ $OS_TYPE == 'RHEL' ]]; then
                echo -e "> ${B_RED} Installing HTTPD. ${NO_FORMAT}\n"
                ${PK_INSTALL} -y httpd
                systemctl enable --now httpd
        fi
}
