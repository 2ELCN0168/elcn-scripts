create_themes() {

  mkdir -p /boot/EFI/refind/themes
  git clone https://github.com/catppuccin/refind /boot/EFI/refind/themes/catppuccin &> /dev/null

  local choice=0

  while true; do
    printf "==THEMES============"
    jump
    printf "${C_WHITE}[0] - ${C_WHITE}Catppuccin latte (light)${NO_FORMAT}\n"
    printf "${C_WHITE}[1] - ${C_CYAN}Catppuccin mocha (dark)${NO_FORMAT} [default] \n"
    printf "${C_WHITE}[2] - ${NO_FORMAT}Keep default TTY colors"
    jump
    printf "====================\n"
    
    read -p "[?] - Which theme do you prefer for your TTY? " response
    local response=${response:-1}
    case "$response" in
      [0])
        echo include themes/catppuccin/latte.conf >> /boot/EFI/refind/refind.conf
        choice=0
        break
        ;;
      [1])
        echo include themes/catppuccin/mocha.conf >> /boot/EFI/refind/refind.conf
        choice=1
        break
        ;;
      [2])
        rm -rf /boot/EFI/refind/themes/catppuccin &> /dev/null
        choice=2
        break
        ;;
      *)
        invalid_answer
        ;;
    esac
  done

  mkdir /etc/tty_themes.d

  if [[ $choice -eq 0 ]]; then
    echo "source /etc/tty_themes.d/tty_catppuccin_latte.sh" >> /etc/skel/.bashrc
    echo "source /etc/tty_themes.d/tty_catppuccin_latte.sh" >> /etc/skel/.zshrc 
    echo "source /etc/tty_themes.d/tty_catppuccin_latte.sh" >> /root/.bashrc
    echo "source /etc/tty_themes.d/tty_catppuccin_latte.sh" >> /root/.zshrc
    cat << EOF > /etc/tty_themes.d/tty_catppuccin_latte.sh
    __tty_theme() {
    [ "\$TERM" = 'linux' ] || return # Only run in a TTY

    printf "\e]P0eff1f5" # black         rgb(239, 241, 245)  #eff1f5
    printf "\e]P1d20f39" # red           rgb(210, 15, 57)    #d20f39
    printf "\e]P240a02b" # green         rgb(64, 160, 43)    #40a02b
    printf "\e]P3df8e1d" # brown         rgb(223, 142, 29)   #df8e1d
    printf "\e]P41e66f5" # blue          rgb(30, 102, 245)   #1e66f5
    printf "\e]P58839ef" # magenta       rgb(136, 57, 239)   #8839ef
    printf "\e]P6179299" # cyan          rgb(23, 146, 153)   #179299
    printf "\e]PF4c4f69" # light_gray    rgb(76, 79, 105)    #4c4f69
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
EOF
  elif [[ $choice -eq 1 ]]; then
    echo "source /etc/tty_themes.d/tty_catppuccin_mocha.sh" >> /etc/skel/.bashrc >> /root/.bashrc
    echo "source /etc/tty_themes.d/tty_catppuccin_mocha.sh" >> /etc/skel/.zshrc >> /root/.bashrc
    echo "source /etc/tty_themes.d/tty_catppuccin_mocha.sh" >> /root/.bashrc
    echo "source /etc/tty_themes.d/tty_catppuccin_mocha.sh" >> /root/.zshrc
    cat << EOF > /etc/tty_themes.d/tty_catppuccin_mocha.sh
    __tty_theme() {
    [ "\$TERM" = 'linux' ] || return # Only run in a TTY

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
EOF
  elif [[ $choice -eq 2 ]]; then
    continue
  fi

  

}