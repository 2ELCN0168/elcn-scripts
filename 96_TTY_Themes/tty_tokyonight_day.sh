# Theme generated using: https://ari.lt/page/ttytheme
# Installation: Just add these lines to your ~/.bashrc

__tty_theme() {
    [ "$TERM" = 'linux' ] || return # Only run in a TTY

    printf "\e]P0d7d7d9" # black         rgb(215, 215, 217)  #d7d7d9
    printf "\e]P18d4350" # red           rgb(141, 67, 80)    #8d4350
    printf "\e]P233635c" # green         rgb(51, 99, 92)     #33635c
    printf "\e]P38f5f14" # brown         rgb(143, 95, 20)    #8f5f14
    printf "\e]P4104a6f" # blue          rgb(16, 74, 111)    #104a6f
    printf "\e]P5655981" # magenta       rgb(101, 89, 129)   #655981
    printf "\e]P634558b" # cyan          rgb(52, 85, 139)    #34558b
    printf "\e]P7cbcdd0" # light_gray    rgb(203, 205, 208)  #cbcdd0
    printf "\e]P82b2d42" # gray          rgb(43, 45, 66)     #2b2d42
    printf "\e]P98d4350" # bold_red      rgb(141, 67, 80)    #8d4350
    printf "\e]PA33635c" # bold_green    rgb(51, 99, 92)     #33635c
    printf "\e]PB8f5f14" # bold_yellow   rgb(143, 95, 20)    #8f5f14
    printf "\e]PC104a6f" # bold_blue     rgb(16, 74, 111)    #104a6f
    printf "\e]PD655981" # bold_magenta  rgb(101, 89, 129)   #655981
    printf "\e]PE34558b" # bold_cyan     rgb(52, 85, 139)    #34558b
    printf "\e]PF2b2d42" # bold_white    rgb(43, 45, 66)     #2b2d42

    clear # To fix the background
}

__tty_theme
