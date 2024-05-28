# Theme generated using: https://ari.lt/page/ttytheme
# Installation: Just add these lines to your ~/.bashrc

__tty_theme() {
    [ "$TERM" = 'linux' ] || return # Only run in a TTY

    printf "\e]P024273a" # black         rgb(36, 39, 58)     #24273a
    printf "\e]P1ed8796" # red           rgb(237, 135, 150)  #ed8796
    printf "\e]P2a6da95" # green         rgb(166, 218, 149)  #a6da95
    printf "\e]P3eed49f" # brown         rgb(238, 212, 159)  #eed49f
    printf "\e]P48aadf4" # blue          rgb(138, 173, 244)  #8aadf4
    printf "\e]P5c6a0f6" # magenta       rgb(198, 160, 246)  #c6a0f6
    printf "\e]P68bd5ca" # cyan          rgb(139, 213, 202)  #8bd5ca
    printf "\e]P7939ab7" # light_gray    rgb(147, 154, 183)  #939ab7
    printf "\e]P86e738d" # gray          rgb(110, 115, 141)  #6e738d
    printf "\e]P9f0c6c6" # bold_red      rgb(240, 198, 198)  #f0c6c6
    printf "\e]PAa6da95" # bold_green    rgb(166, 218, 149)  #a6da95
    printf "\e]PBf4dbd6" # bold_yellow   rgb(244, 219, 214)  #f4dbd6
    printf "\e]PCb7bdf8" # bold_blue     rgb(183, 189, 248)  #b7bdf8
    printf "\e]PDf5bde6" # bold_magenta  rgb(245, 189, 230)  #f5bde6
    printf "\e]PE91d7e3" # bold_cyan     rgb(145, 215, 227)  #91d7e3
    printf "\e]PFcad3f5" # bold_white    rgb(202, 211, 245)  #cad3f5

    clear # To fix the background
}

__tty_theme
