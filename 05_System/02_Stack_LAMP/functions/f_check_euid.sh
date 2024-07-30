check_euid() {

        if [[ $EUID -ne 0 ]]; then
                echo -e "${C_RED} THIS SCRIPT MUST BE EXECUTED AS ROOT. EXITING WITH ERROR CODE 1.${NO_FORMAT}"
                exit 1
        else
                echo -e "${C_GREEN}USER IS ROOT. CONTINUING.${NO_FORMAT}"
        fi
}
