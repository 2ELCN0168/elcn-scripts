#! /bin/bash

# Creator: 2ELCN0168
# Last updated on: 2024-12-20
# License: Free for personnal use only

function _colors()
{
        R='\033[91m' # RED
        G='\033[92m' # GREEN
        Y='\033[93m' # YELLOW
        B='\033[94m' # BLUE
        P='\033[95m' # PINK
        C='\033[96m' # CYAN
        N='\033[0m'  # RESET
}

function _help()
{
        printf "Get system informations.\n"
        printf "${C}Usage:${N}\n"
        printf "${Y} -h ${N}     Display help\n"
}

function main()
{
        LIMIT=50

        opt_c=0 # No colored output
        opt_h=0 # Display help
        opt_q=0 # Quiet mode

        while getopts ":hc" opt; do
                case "${opt}" in
                        c) opt_c=1 ;;
                        h|?) opt_h=1;;
                esac
        done

        [[ "${opt_c}" -ne 1 ]] && _colors
        [[ "${opt_h}" -eq 1 ]] && _help && exit 0
        
        display_ip
}

function display_ip()
{
        local ip=""
        local ip6=""

}

main "${@}"
