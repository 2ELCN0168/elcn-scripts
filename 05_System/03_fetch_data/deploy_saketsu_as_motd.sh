#! /bin/bash

function _colors()
{
        R='\033[91m' # RED
        G='\033[92m' # GREEN
        Y='\033[93m' # YELLOW
        B='\033[94m' # BLUE
        P='\033[95m' # PINK
        C='\033[96m' # CYAN
        N='\033[0m'  # 1RESET

        INFO="${C}[>]${N}"
        WARN="${Y}[%]${N}"
        ERR="${R}[!]${N}"
}

function main()
{
        _colors

        if [[ "${EUID}" -ne 0 ]]; then
                printf "%b" "${ERR} This script must be executed as root.\n\n"
                exit 1
        fi

        printf "%b" "${INFO} Welcome, this script will clone the repository "
        printf "%b" "'2ELCN0168/saketsu-data-fetch and create a systemd timer "
        printf "%b" "+ service to update automatically the ${P}/etc/motd${N} "
        printf "%b" "file with the result of ${R}Saketsu${N}.\n\n"

        printf "%b" "Do you want to continue? [Y/n] -> "

        while true; do
                read -r ans
                : "${ans:=Y}"
                printf "%b" "\n"

                if [[ "${ans}" =~ ^[yY]$ ]]; then
                        break
                elif [[ "${ans}" =~ ^[nN]$ ]]; then
                        return
                else
                        printf "%b" "${WARN} Invalid answer.\n\n"
                fi
        done

        git clone "https://github.com/2ELCN0168/saketsu-data-fetch" \
        "/usr/local/src/saketsu-data-fetch" 

        ln -sf "/usr/local/src/saketsu-data-fetch/saketsu-modern-edition.sh" \
        "/usr/local/bin/saketsu-modern-edition.sh"


        printf "%b" "${INFO} Creating ${P}/etc/systemd/system/update-motd.timer"
        printf "%b" "${N}.\n"

        cat <<-EOF > "/etc/systemd/system/update-motd.timer"
        [Unit]
        Description=Timer for update-motd.service

        [Timer]
        OnCalendar=*-*-* *:*:00
        Persistent=true

        [Install]
        WantedBy=timers.target
EOF

        printf "%b" "${INFO} Creating ${P}/etc/systemd/system/update-motd."
        printf "%b" "service${N}.\n"

        cat <<-EOF > "/etc/systemd/system/update-motd.service"
        [Unit]
        Description=Automatically update /etc/motd

        [Service]
        Type=oneshot
        ExecStart=bash -c '/usr/local/bin/saketsu-modern-edition.sh -dn > /etc/motd'
EOF

        systemctl daemon-reload

        printf "%b" "${INFO} Enabling ${P}update-motd.timer${N}.\n\n"

        systemctl enable --now update-motd.timer
        systemctl start update-motd.service

        printf "%b" "${INFO} The script is finished.\n\n"
}

main
