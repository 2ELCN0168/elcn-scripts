check_installations() {

        echo

        if [[ $OS_TYPE == 'ARCHLINUX' ]]; then
                if httpd -v &> /dev/null; then
                        echo -e "${C_GREEN}Apache is installed.${NO_FORMAT}"
                else
                        echo -e "${C_RED}Apache is not installed.${NO_FORMAT}"
                fi

                if php -v &> /dev/null; then
                        echo -e "${C_GREEN}PHP is installed.${NO_FORMAT}"
                else
                        echo -e "${C_RED}PHP is not installed.${NO_FORMAT}"
                fi

                if mariadb --version &> /dev/null; then
                        echo -e "${C_GREEN}MariaDB is installed.${NO_FORMAT}"
                else
                        echo -e "${C_RED}MariaDB is not installed.${NO_FORMAT}"
                fi

        elif [[ $OS_TYPE == 'DEBIAN' ]]; then
                if apache -v &> /dev/null; then
                        echo -e "${C_GREEN}Apache is installed.${NO_FORMAT}"
                else
                        echo -e "${C_RED}Apache is not installed.${NO_FORMAT}"
                fi

                if php -v &> /dev/null; then
                        echo -e "${C_GREEN}PHP is installed.${NO_FORMAT}"
                else
                        echo -e "${C_RED}PHP is not installed.${NO_FORMAT}"
                fi

                if mariadb --version &> /dev/null; then
                        echo -e "${C_GREEN}MariaDB is installed.${NO_FORMAT}"
                else
                        echo -e "${C_RED}MariaDB is not installed.${NO_FORMAT}"
                fi
        elif [[ $OS_TYPE == 'RHEL' ]]; then
                if httpd -v &> /dev/null; then
                        echo -e "${C_GREEN}Apache is installed.${NO_FORMAT}"
                else
                        echo -e "${C_RED}Apache is not installed.${NO_FORMAT}"
                fi

                if php -v &> /dev/null; then
                        echo -e "${C_GREEN}PHP is installed.${NO_FORMAT}"
                else
                        echo -e "${C_RED}PHP is not installed.${NO_FORMAT}"
                fi

                if mariadb --version &> /dev/null; then
                        echo -e "${C_GREEN}MariaDB is installed.${NO_FORMAT}"
                else
                        echo -e "${C_RED}MariaDB is not installed.${NO_FORMAT}"
                fi

        fi
}
