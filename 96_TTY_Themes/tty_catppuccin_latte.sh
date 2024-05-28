# Theme generated using: https://ari.lt/page/ttytheme
# Installation: Just add these lines to your ~/.bashrc

__tty_theme() {
    [ "$TERM" = 'linux' ] || return # Only run in a TTY

    printf "\e]P0eff1f5" # black         rgb(239, 241, 245)  #eff1f5
    printf "\e]P1d20f39" # red           rgb(210, 15, 57)    #d20f39
    printf "\e]P240a02b" # green         rgb(64, 160, 43)    #40a02b
    printf "\e]P3df8e1d" # brown         rgb(223, 142, 29)   #df8e1d
    printf "\e]P41e66f5" # blue          rgb(30, 102, 245)   #1e66f5
    printf "\e]P58839ef" # magenta       rgb(136, 57, 239)   #8839ef
    printf "\e]P6179299" # cyan          rgb(23, 146, 153)   #179299
    printf "\e]P7bcc0cc" # light_gray    rgb(188, 192, 204)  #bcc0cc
    printf "\e]P86c6f85" # gray          rgb(108, 111, 133)  #6c6f85
    printf "\e]P9e64553" # bold_red      rgb(230, 69, 83)    #e64553
    printf "\e]PA40a02b" # bold_green    rgb(64, 160, 43)    #40a02b
    printf "\e]PBdf8e1d" # bold_yellow   rgb(223, 142, 29)   #df8e1d
    printf "\e]PC04a5e5" # bold_blue     rgb(4, 165, 229)    #04a5e5
    printf "\e]PDea76cb" # bold_magenta  rgb(234, 118, 203)  #ea76cb
    printf "\e]PE209fb5" # bold_cyan     rgb(32, 159, 181)   #209fb5
    printf "\e]PF4c4f69" # bold_white    rgb(76, 79, 105)    #4c4f69

    clear # To fix the background
}

__tty_theme
