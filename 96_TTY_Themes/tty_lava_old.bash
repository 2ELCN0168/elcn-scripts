# Theme generated using: https://ari.lt/page/ttytheme
# Installation: Just add these lines to your ~/.bashrc

__tty_theme() {
    [ "$TERM" = 'linux' ] || return # Only run in a TTY

    printf "\e]P00e1428" # black         rgb(14, 20, 40)     #0e1428
    printf "\e]P1d95d39" # red           rgb(217, 93, 57)    #d95d39
    printf "\e]P2f18805" # green         rgb(241, 136, 5)    #f18805
    printf "\e]P3f0a202" # brown         rgb(240, 162, 2)    #f0a202
    printf "\e]P47b9e89" # blue          rgb(123, 158, 137)  #7b9e89
    printf "\e]P58d7b9e" # magenta       rgb(141, 123, 158)  #8d7b9e
    printf "\e]P6699b96" # cyan          rgb(105, 155, 150)  #699b96
    printf "\e]P7a09793" # light_gray    rgb(160, 151, 147)  #a09793
    printf "\e]P8676260" # gray          rgb(103, 98, 96)    #676260
    printf "\e]P9d95d39" # bold_red      rgb(217, 93, 57)    #d95d39
    printf "\e]PAf18805" # bold_green    rgb(241, 136, 5)    #f18805
    printf "\e]PBf0a202" # bold_yellow   rgb(240, 162, 2)    #f0a202
    printf "\e]PC7b9e89" # bold_blue     rgb(123, 158, 137)  #7b9e89
    printf "\e]PD8d7b9e" # bold_magenta  rgb(141, 123, 158)  #8d7b9e
    printf "\e]PE699b96" # bold_cyan     rgb(105, 155, 150)  #699b96
    printf "\e]PFffffff" # bold_white    rgb(255, 255, 255)  #ffffff

    clear # To fix the background
}

__tty_theme
