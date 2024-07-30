### COLOR VARIABLES

export C_RED="\033[91m"
export C_GREEN="\033[92m"
export C_CYAN="\033[96m"
export C_YELLOW="\033[93m"
export C_PINK="\033[95m"
export C_WHITE="\033[97m"

export B_RED="\033[41;30m"
export B_GREEN="\033[42;30m"
export B_CYAN="\033[46;30m"
export B_YELLOW="\033[43;30m"
export B_PINK="\033[45;30m"
export B_WHITE="\033[47;30m"

# End of the color sequence
export NO_FORMAT="\033[0m"

### MESSAGE TYPES

export INFO="${C_WHITE}[${C_CYAN}INFO${C_WHITE}]${NO_FORMAT}"
export WARN="${C_WHITE}[${C_YELLOW}WARNING${C_WHITE}]${NO_FORMAT}"
export ERR="${C_WHITE}[${C_RED}ERROR${C_WHITE}]${NO_FORMAT}"
export SUC="${C_WHITE}[${C_GREEN}SUCCESS${C_WHITE}]${NO_FORMAT}"
