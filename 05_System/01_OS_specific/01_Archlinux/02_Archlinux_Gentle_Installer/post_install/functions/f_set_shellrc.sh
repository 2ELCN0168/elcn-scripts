set_bashrc() {

  echo "PS1='\[\e[93m\][\[\e[97;1m\]\u\[\e[0;93m\]@\[\e[97m\]\h\[\e[93m\]]\[\e[91m\][\w]\[\e[93m\](\t)\[\e[0m\] \[\e[97m\]\$\[\e[0m\] '" >> /etc/skel/.bashrc
  echo "alias ll='command ls -lh --color=auto'" >> /etc/skel/.bashrc
  echo "alias ls='command ls --color=auto'" >> /etc/skel/.bashrc
  echo "alias ip='command ip -color=auto'" >> /etc/skel/.bashrc
  echo "alias grep='grep --color=auto'" >> /etc/skel/.bashrc

  if [[ $nKorea -eq 1 ]]; then
    echo "alias fastfetch='fastfetch --logo redstaros'" >> /etc/skel/.bashrc
  fi

  cp /etc/skel/.bashrc /root

}

set_zshrc() {

  echo "# Lines configured by zsh-newuser-install" > /etc/skel/.zshrc
  echo "HISTFILE=~/.histfile" >> /etc/skel/.zshrc
  echo "HISTSIZE=1000" >> /etc/skel/.zshrc
  echo "SAVEHIST=1000" >> /etc/skel/.zshrc
  echo "bindkey -e" >> /etc/skel/.zshrc
  echo "# End of lines configured by zsh-newuser-install" >> /etc/skel/.zshrc
  
  echo "" >> /etc/skel/.zshrc
  echo "# PLUGINS #" >> /etc/skel/.zshrc
  echo "" >> /etc/skel/.zshrc
  
  echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> /etc/skel/.zshrc
  echo "source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> /etc/skel/.zshrc
  echo 'PROMPT="%F{red}[%f%B%F{white}%n%f%b%F{red}@%f%F{white}%m%f%F{red}:%f%B%~%b%F{red}]%f(%F{red}%*%f)%F{red}%#%f "' >> /etc/skel/.zshrc
  
  echo "" >> /etc/skel/.zshrc
  echo "# ALIASES #" >> /etc/skel/.zshrc
  echo "" >> /etc/skel/.zshrc

  echo "alias ll='command ls -lh --color=auto'" >> /etc/skel/.zshrc
  echo "alias ls='command ls --color=auto'" >> /etc/skel/.zshrc
  echo "alias ip='command ip -color=auto'" >> /etc/skel/.zshrc
  echo "alias grep='grep --color=auto'" >> /etc/skel/.zshrc
  if [[ $nKorea -eq 1 ]]; then
    echo "alias fastfetch='fastfetch --logo redstaros'" >> /etc/skel/.zshrc
  fi

  cp /etc/skel/.zshrc /root
}