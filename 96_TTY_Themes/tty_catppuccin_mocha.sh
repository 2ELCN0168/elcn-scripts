# Theme generated using: https://ari.lt/page/ttytheme
# Installation: Just add these lines to your ~/.bashrc

__tty_theme() {
    [ "$TERM" = 'linux' ] || return # Only run in a TTY

    printf "\e]P01e1e2e" # black         rgb(30, 30, 46)     #1e1e2e
    printf "\e]P1f38ba8" # red           rgb(243, 139, 168)  #f38ba8
    printf "\e]P2a6e3a1" # green         rgb(166, 227, 161)  #a6e3a1
    printf "\e]P3fab387" # brown         rgb(250, 179, 135)  #fab387
    printf "\e]P489b4fa" # blue          rgb(137, 180, 250)  #89b4fa
    printf "\e]P5cba6f7" # magenta       rgb(203, 166, 247)  #cba6f7
    printf "\e]P694e2d5" # cyan          rgb(148, 226, 213)  #94e2d5
    printf "\e]P79399b2" # light_gray    rgb(147, 153, 178)  #9399b2
    printf "\e]P8585b70" # gray          rgb(88, 91, 112)    #585b70
    printf "\e]P9eba0ac" # bold_red      rgb(235, 160, 172)  #eba0ac
    printf "\e]PAa6e3a1" # bold_green    rgb(166, 227, 161)  #a6e3a1
    printf "\e]PBf9e2af" # bold_yellow   rgb(249, 226, 175)  #f9e2af
    printf "\e]PCb4befe" # bold_blue     rgb(180, 190, 254)  #b4befe
    printf "\e]PDf5c2e7" # bold_magenta  rgb(245, 194, 231)  #f5c2e7
    printf "\e]PE89dceb" # bold_cyan     rgb(137, 220, 235)  #89dceb
    printf "\e]PFcdd6f4" # bold_white    rgb(205, 214, 244)  #cdd6f4

    clear # To fix the background
}

__tty_theme
