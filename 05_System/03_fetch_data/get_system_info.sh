#! /bin/bash

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

function main()
{
        _colors

        # Must be executed as root.
        if [[ "${EUID}" -ne 0 ]]; then
                printf "%b" "${R}This script must be executed as root.${N}\n"
                printf "%b" "Use '-h' to display the help menu.\n"
                exit 1
        fi

        # Options declarations.
        local opt_a opt_h opt_n opt_s opt_u

        opt_a=0 # All
        opt_e=0 # Export the output 
        opt_h=0 # Help
        opt_n=0 # Network
        opt_s=0 # Services
        opt_S=0 # System
        opt_u=0 # Users

        while getopts "ahnsSu" opt; do
                case "${opt}" in
                        a) opt_a=1 ;;
                        e) opt_e=1 ;;
                        h) opt_h=1 ;;
                        n) opt_n=1 ;;
                        s) opt_s=1 ;;
                        S) opt_S=1 ;;
                        u) opt_u=1 ;;
                esac
        done

        # Display the help menu.
        if [[ "${opt_h}" -eq 1 ]]; then
                _help
                exit 0
        fi

        # Users informations
        if [[ "${opt_u}" -eq 1 ]]; then
                get_users_informations "1"
                get_group_informations
        fi

        # System informations
        if [[ "${opt_s}" -eq 1 ]]; then
                get_users_informations "0"
        fi
}

function _help()
{
        printf "%b" "This script gives informations about the system.\n"

        printf "%b" "  -a          Get all informations\n"
        printf "%b" "  -e          Export the output to JSON\n"
        printf "%b" "  -h          Display this help\n"
        printf "%b" "  -n          Get network informations\n"
        printf "%b" "  -s          Get services informations\n"
        printf "%b" "  -S          Get system informations\n"
        printf "%b" "  -u          Get users informations\n\n"
}

function get_users_informations()
{
        local passwd_file="/etc/passwd"

        # Account type : 0 = system | 1 = users.
        local account_type="${1}"
        
        while IFS=':' read -r _user _ _uid _ _; do
                if [[ "${_uid}" -lt 1000 && "${account_type}" -eq 0 
                || "${_uid}" -eq 65534 && "${account_type}" -eq 0 ]]; then
                        printf "%b%5d" "${R}System user: ${C} " "${_uid}"
                        printf "%b" "${N} : ${Y}${_user}${N}\n"
                fi

                if [[ "${_uid}" -ge 1000 && "${_uid}" -ne 65534 && 
                "${account_type}" -eq 1 ]]; then
                        printf "%b%5d" "${G}User: ${C} " "${_uid}"
                        printf "%b" "${N} : ${Y}${_user}${N}\n"
                fi
        done < "${passwd_file}"
}

function get_group_informations()
{
        local passwd_file="/etc/passwd"

        while IFS=':' read -r _group _ _gid users_in_group; do
                if [[ -z "${users_in_group}" ]]; then
                        continue
                fi
                printf "%b" "${Y}Group: ${C}${_group}${N} -> ${P}users: "
                printf "%b" "${B}${users_in_group}${N}\n"
        done < "${group_file}"
}

main "${@}"
