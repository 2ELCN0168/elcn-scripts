# Theme generated using: https://ari.lt/page/ttytheme
# Installation: Just add these lines to your ~/.bashrc

__tty_theme() {
    [ "$TERM" = 'linux' ] || return # Only run in a TTY

    printf "\e]P01a1821" # black         rgb(26, 24, 33)     #1a1821
    printf "\e]P1f38da8" # red           rgb(243, 141, 168)  #f38da8
    printf "\e]P2a7e4a1" # green         rgb(167, 228, 161)  #a7e4a1
    printf "\e]P3f9e2af" # brown         rgb(249, 226, 175)  #f9e2af
    printf "\e]P488b3fa" # blue          rgb(136, 179, 250)  #88b3fa
    printf "\e]P5f5c1e7" # magenta       rgb(245, 193, 231)  #f5c1e7
    printf "\e]P695e2d6" # cyan          rgb(149, 226, 214)  #95e2d6
    printf "\e]P7b9c4de" # light_gray    rgb(185, 196, 222)  #b9c4de
    printf "\e]P86d6f75" # gray          rgb(109, 111, 117)  #6d6f75
    printf "\e]P9f38da8" # bold_red      rgb(243, 141, 168)  #f38da8
    printf "\e]PAa7e4a1" # bold_green    rgb(167, 228, 161)  #a7e4a1
    printf "\e]PBf9e2af" # bold_yellow   rgb(249, 226, 175)  #f9e2af
    printf "\e]PC88b3fa" # bold_blue     rgb(136, 179, 250)  #88b3fa
    printf "\e]PDf5c1e7" # bold_magenta  rgb(245, 193, 231)  #f5c1e7
    printf "\e]PE95e2d6" # bold_cyan     rgb(149, 226, 214)  #95e2d6
    printf "\e]PFfffffb" # bold_white    rgb(255, 255, 251)  #fffffb

    clear # To fix the background
}

__tty_theme
