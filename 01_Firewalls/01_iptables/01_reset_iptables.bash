#!/bin/bash

########################################

# Color variables beginnings

C_RED="\033[31"
C_GREEN="\033[32"
C_CYAN="\033[36m"
C_YELLOW="\033[33m"

# End of the color sequence

NO_FORMAT="\033[0m"

########################################

check_iptables() {
	echo -e "> Checking if IPtables is installed... <"
	if ! iptables --version 1>/dev/null; then
		echo -e "\033[1;31m/!\\ IPtables is not installed! Aborting. /!\\ ${NO_FORMAT}"
	else
		echo -e "\033[1;36m- IPtables is installed...${NO_FORMAT}"
	fi
}

########################################

ask_confirmation() {
	read -p "This will reset IPtables, continue? [N/y] " response
	response=${response:-N}
	case "$response" in
		[yY])
			echo -e "\n\033[1;7;33m###### /!\\ Resetting IPtables... /!\\ ###### ${NO_FORMAT} \n "
			;;
		[nN])	
			echo -e "> Aborting. \n"
			exit 0
			;;
		*)
			echo -e "\n/!\\ Press Y or N. /!\\ "
			ask_confirmation
			;;
	esac

}

########################################

reset_iptables() {
	sudo bash -c '
		
		echo -e "> Flushing all filtering rules (iptables -F)"
		iptables -F

		echo -e "> Deleting all custom chains (iptables -X)"
		iptables -X

		echo -e "> Flushing all NAT table rules (iptables -t nat -F)"
		iptables -t nat -F

		echo -e "> Deleting all custom chains in NAT table (iptables -t nat -X)"
		iptables -t nat -X

		echo -e "> Flushing all MANGLE table rules (iptables -t mangle -F)"
		iptables -t mangle -F

		echo -e "> Deleting all custom chains in MANGLE table (iptables -t mangle -X)"
		iptables -t mangle -X

		echo -e "> Flushing all RAW table rules (iptables -t raw -F)"
		iptables -t raw -F

		echo -e "> Deleting all custom chains in RAW table (iptables -t raw -X)"
		iptables -t raw -X

		echo -e "> Flushing all SECURITY table rules (iptables -t security -F)"
		iptables -t security -F

		echo -e "> Deleting all custom chains in SECURITY table (iptables -t security -X)"
		iptables -t security -X

		echo -e "> Setting default policy for INPUT chain to ACCEPT (iptables -P INPUT ACCEPT)"
		iptables -P INPUT ACCEPT

		echo -e "> Setting default policy for FORWARD chain to ACCEPT (iptables -P FORWARD ACCEPT)"
		iptables -P FORWARD ACCEPT

		echo -e "> Setting default policy for OUTPUT chain to ACCEPT (iptables -P OUTPUT ACCEPT)"
		iptables -P OUTPUT ACCEPT
		'
		
		echo -e "\n\033[1;7;36m>> IPTABLES HAS BEEN SUCCESSFULLY RESET TO ITS DEFAULT PARAMETERS. EXITING. <<${NO_FORMAT}"
}

########################################

echo -e "\033[1;7;33m...IPTABLES RESET SCRIPT...${NO_FORMAT}"
echo -e "\033[7;36mThis script will restore iptables to its default configuration with no restrictive rules at all.${NO_FORMAT}"

check_iptables
ask_confirmation
reset_iptables
