# Theme generated using: https://ari.lt/page/ttytheme
# Installation: Just add these lines to your ~/.bashrc

__tty_theme() {
    [ "$TERM" = 'linux' ] || return # Only run in a TTY

    printf "\e]P01c1a23" # black         rgb(28, 26, 35)     #1c1a23
    printf "\e]P1ceb5a7" # red           rgb(206, 181, 167)  #ceb5a7
    printf "\e]P2eaf7cf" # green         rgb(234, 247, 207)  #eaf7cf
    printf "\e]P3ebefbf" # brown         rgb(235, 239, 191)  #ebefbf
    printf "\e]P4adaabf" # blue          rgb(173, 170, 191)  #adaabf
    printf "\e]P592828d" # magenta       rgb(146, 130, 141)  #92828d
    printf "\e]P6aab6bf" # cyan          rgb(170, 182, 191)  #aab6bf
    printf "\e]P7c6cbd0" # light_gray    rgb(198, 203, 208)  #c6cbd0
    printf "\e]P86d6f75" # gray          rgb(109, 111, 117)  #6d6f75
    printf "\e]P9f0e9e5" # bold_red      rgb(240, 233, 229)  #f0e9e5
    printf "\e]PAf7fcee" # bold_green    rgb(247, 252, 238)  #f7fcee
    printf "\e]PBfafbef" # bold_yellow   rgb(250, 251, 239)  #fafbef
    printf "\e]PCdddce5" # bold_blue     rgb(221, 220, 229)  #dddce5
    printf "\e]PDbdb3b9" # bold_magenta  rgb(189, 179, 185)  #bdb3b9
    printf "\e]PEdce1e5" # bold_cyan     rgb(220, 225, 229)  #dce1e5
    printf "\e]PFffffff" # bold_white    rgb(255, 255, 255)  #ffffff

    clear # To fix the background
}

__tty_theme
