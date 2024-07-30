pmanager_detector() {
        
        export OS_TYPE=
        export PK_INSTALL=

        if apt --version &> /dev/null; then
                echo -e "> ${B_RED} DEBIAN BASED SYSTEM DETECTED, APT WILL BE USED. ${NO_FORMAT}\n"
                OS_TYPE=DEBIAN
                PK_INSTALL="apt install"
        elif dnf --version &> /dev/null; then
                echo -e "> ${B_RED} RHEL BASED SYSTEM DETECTED, DNF WILL BE USED. ${NO_FORMAT}\n"
                OS_TYPE=RHEL
                PK_INSTALL="dnf install"
        elif pacman --version &> /dev/null; then
                echo -e "> ${B_CYAN} ARCHLINUX BASED SYSTEM DETECTED, PACMAN WILL BE USED. ${NO_FORMAT}\n"
                OS_TYPE=ARCHLINUX
                PK_INSTALL="pacman -S"
        fi
}
