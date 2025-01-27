#! /bin/bash

# Created on: 2025-01-24
# Author: 2ELCN0168
# Github: https://github.com/2ELCN0168
# Script function: Auto detect logs and asks the user where to move them.

# INFO:
# Global variables:
# logs_directory
# destination

function _colors()
{
        # Colors and message types initialization.
        R='\033[91m' # RED
        G='\033[92m' # GREEN
        Y='\033[93m' # YELLOW
        B='\033[94m' # BLUE
        P='\033[95m' # PINK
        C='\033[96m' # CYAN
        N='\033[0m'  # RESET

        QS="${N}[${P}?${N}]"
        INFO="${N}[${G}>${N}]"
        WARN="${N}[${Y}#${N}]"
        ERR="${N}[${R}!${N}]"

        function invalid_answer()
        {
                printf "%b" "${WARN} Invalid answer. Try again.\n"
        }
}

function _help()
{
        printf "%b" "This script can move every compressed logs from a "
        printf "%b" "directory to another one.\n"
        printf "%b" "It detects what files are ${B}'.gz'${N} or ${B}'.tar.gz'"
        printf "%b" "${N} then creates a directory where the user want.\n"
        printf "%b" "${R}Root privileges are needed for this script to work"
        printf "%b" "${N}.\n"

        printf "%b" "Usage:\n"
        printf "%b" "  ${C}-d${N}    Dry-run (do nothing)\n"
        printf "%b" "  ${C}-h${N}    Display this help\n"
}

function main()
{
        _colors

        # VARS:
        # Global variables are declared below.

        logs_directory="/var/log"
        destination="${HOME}/transferred-logs"

        # ---- #

        local opt_d=0 # Dry-run

        while getopts "dh" opt; do
                case "${opt}" in
                d) opt_d=1 ;;
                h) _help && exit 0 ;;
                ?) _help && exit 1 ;;
                esac
        done

        # Must be executed as the root user.
        if [[ "${EUID}" -ne 0 ]]; then
                printf "%b" "${ERR} This script must be executed as the root "
                printf "%b" "user, as it moves files owned by him.\n"
                exit 1
        fi

        detect_logs_directory
        detect_destination_directory
        move_logs
}

function detect_logs_directory()
{
        while true; do
                printf "%b" "${QS} The default logs directory is ${P}"
                printf "%b" "${logs_directory}${N}. Is that correct? [Y/n] -> "

                printf "%b" "${Y}"
                read -r answer
                : "${answer:=Y}"
                printf "%b" "${N}\n"

                if [[ "${answer}" =~ ^[nN]$ ]]; then
                        change_logs_directory
                        break
                elif [[ "${answer}" =~ ^[yY]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done
}

function change_logs_directory()
{
        while true; do
                printf "%b" "${QS} Do you want to change the logs directory? "
                printf "%b" "[Y/n/q] -> "

                printf "%b" "${Y}"
                read -r answer
                : "${answer:=Y}"
                printf "%b" "${N}\n"

                if [[ "${answer}" =~ ^[yY]$ ]]; then
                        break
                elif [[ "${answer}" =~ ^[nN]$ ]]; then
                        return
                elif [[ "${answer}" =~ ^[qQ]$ ]]; then
                        exit 0
                else
                        invalid_answer
                fi
        done

        # If previous answer was 'y'.
        while true; do
                printf "%b" "${QS} Type the new path: ${Y}"
                read -r answer
                printf "%b" "${N}\n"

                if [[ -d "${answer}" ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        logs_directory="${answer}"
}

function detect_destination_directory()
{
        while true; do
                printf "%b" "${QS} The destination directory is ${P}"
                printf "%b" "${destination}${N}, is it ok? [Y/n] -> "

                read -r answer
                : "${answer:=Y}"
                printf "%b" "\n"

                if [[ "${answer}" =~ ^[yY]$ ]]; then
                        return
                elif [[ "${answer}" =~ ^[nN]$ ]]; then
                        break
                else
                        invalid_answer
                fi
        done

        # Only if "nN" was typed.
        while true; do
                printf "%b" "${QS} Type the new destination directory: ${Y}"

                read -r answer
                printf "%b" "\n"

                if [[ -d "${answer}" ]]; then
                        destination="${answer}/transferred-logs"
                        break
                else
                        invalid_answer
                fi
        done

        printf "%b" "${INFO} Destination path changed to ${P}${destination}"
        printf "%b" "\n"
}

function move_logs()
{
        local dirs_pathes=()
        local dirs_names=()
        local dir_date

        dir_date="$(date +%Y%m%d)"

        # NOTE:
        # opt_d is for dry-run.

        # Add every directory in $logs_directory + the logs directory itself.
        # Then add only the subdirectory name to $dirs_names for recreation.
        for i in "${logs_directory}/"*; do
                if [[ -d "${i}" ]]; then
                        local dir_name
                        dir_name="$(basename "${i}")"
                        dirs_names+=("${dir_name}")
                        printf "%b" "${INFO} Found directory: ${C}${i}${N}\n"
                        dirs_pathes+=("${i}")
                fi
        done

        printf "%b" "\n"
        dirs_pathes+=("${logs_directory}")

        # Create the directory for logs transfer.
        if [[ "${opt_d}" -eq 0 ]]; then
                if [[ ! -d "${destination}" ]]; then
                        mkdir -p "${destination}" 2> "/dev/null" 2>&1
                fi
        else
                printf "%b" "${INFO} Dry-run: 'Creating ${P}${destination}'"
                printf "%b" "${N}\n"
        fi

        # Create a directory with the date of the transfer.
        if [[ "${opt_d}" -eq 0 ]]; then
                if [[ ! -d "${destination}/${dir_date}" ]]; then
                        mkdir -p "${destination}/${dir_date}" 2> "/dev/null" \
                                2>&1
                fi
        else
                printf "%b" "${INFO} Dry-run: 'Creating ${P}${destination}/"
                printf "%b" "${dir_date}${N}'\n"
        fi

        printf "%b" "\n"

        # Move every file that ends with '.tar.gz' or '.gz'.
        for i in "${dirs_pathes[@]}"; do
                for file in "${i}/"*; do
                        if [[ "${file}" =~ ^.*((.gz)|(.tar.gz))$ ]]; then
                                if [[ "${opt_d}" -eq 0 ]]; then
                                        mv -f "${file}" \
                                                "${destination}/${dir_date}"

                                        printf "%b" "${INFO} Moving ${P}${file}"
                                        printf "%b" "${N} to ${C}${destination}"
                                        printf "%b" "/${dir_date}/${i}${N}\n"
                                else
                                        printf "%b" "${INFO} Dry-run: Moving "
                                        printf "%b" "${P}${file}${N} to ${C}"
                                        printf "%b" "${destination}/${dir_date}"
                                        printf "%b" "${N}\n"
                                fi
                        else
                                continue
                        fi
                        sleep 0.05
                done
        done

        # Print the result.
        if [[ "${opt_d}" -eq 0 ]]; then
                local reclaimed_space
                reclaimed_space="$(du -sh "${destination}/${dir_date}" \
                        2> "/dev/null")"

                printf "%b" "${INFO} Total reclaimed space: ${reclaimed_space}"
                printf "%b" "\n"
        fi
}

main "${@}"
