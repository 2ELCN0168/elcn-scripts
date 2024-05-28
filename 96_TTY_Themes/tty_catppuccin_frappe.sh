# Theme generated using: https://ari.lt/page/ttytheme
# Installation: Just add these lines to your ~/.bashrc

__tty_theme() {
    [ "$TERM" = 'linux' ] || return # Only run in a TTY

    printf "\e]P0303446" # black         rgb(48, 52, 70)     #303446
    printf "\e]P1e78284" # red           rgb(231, 130, 132)  #e78284
    printf "\e]P2a6d189" # green         rgb(166, 209, 137)  #a6d189
    printf "\e]P3e5c890" # brown         rgb(229, 200, 144)  #e5c890
    printf "\e]P48caaee" # blue          rgb(140, 170, 238)  #8caaee
    printf "\e]P5ca9ee6" # magenta       rgb(202, 158, 230)  #ca9ee6
    printf "\e]P681c8be" # cyan          rgb(129, 200, 190)  #81c8be
    printf "\e]P7949cbb" # light_gray    rgb(148, 156, 187)  #949cbb
    printf "\e]P8626880" # gray          rgb(98, 104, 128)   #626880
    printf "\e]P9ea999c" # bold_red      rgb(234, 153, 156)  #ea999c
    printf "\e]PAa6d189" # bold_green    rgb(166, 209, 137)  #a6d189
    printf "\e]PBf2d5cf" # bold_yellow   rgb(242, 213, 207)  #f2d5cf
    printf "\e]PC85c1dc" # bold_blue     rgb(133, 193, 220)  #85c1dc
    printf "\e]PDf4b8e4" # bold_magenta  rgb(244, 184, 228)  #f4b8e4
    printf "\e]PE99d1db" # bold_cyan     rgb(153, 209, 219)  #99d1db
    printf "\e]PFc6d0f5" # bold_white    rgb(198, 208, 245)  #c6d0f5

    clear # To fix the background
}

__tty_theme
