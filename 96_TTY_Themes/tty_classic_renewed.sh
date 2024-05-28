# Theme generated using: https://ari.lt/page/ttytheme
# Installation: Just add these lines to your ~/.bashrc

__tty_theme() {
    [ "$TERM" = 'linux' ] || return # Only run in a TTY

    printf "\e]P02f302c" # black         rgb(47, 48, 44)     #2f302c
    printf "\e]P1952834" # red           rgb(149, 40, 52)    #952834
    printf "\e]P247933a" # green         rgb(71, 147, 58)    #47933a
    printf "\e]P399642b" # brown         rgb(153, 100, 43)   #99642b
    printf "\e]P4234564" # blue          rgb(35, 69, 100)    #234564
    printf "\e]P57736ba" # magenta       rgb(119, 54, 186)   #7736ba
    printf "\e]P6479faa" # cyan          rgb(71, 159, 170)   #479faa
    printf "\e]P7aaaaaa" # light_gray    rgb(170, 170, 170)  #aaaaaa
    printf "\e]P8555555" # gray          rgb(85, 85, 85)     #555555
    printf "\e]P9ff6380" # bold_red      rgb(255, 99, 128)   #ff6380
    printf "\e]PA96ff59" # bold_green    rgb(150, 255, 89)   #96ff59
    printf "\e]PBffff73" # bold_yellow   rgb(255, 255, 115)  #ffff73
    printf "\e]PC7494c7" # bold_blue     rgb(116, 148, 199)  #7494c7
    printf "\e]PDff75ff" # bold_magenta  rgb(255, 117, 255)  #ff75ff
    printf "\e]PE8cffff" # bold_cyan     rgb(140, 255, 255)  #8cffff
    printf "\e]PFffffff" # bold_white    rgb(255, 255, 255)  #ffffff

    clear # To fix the background
}

__tty_theme
