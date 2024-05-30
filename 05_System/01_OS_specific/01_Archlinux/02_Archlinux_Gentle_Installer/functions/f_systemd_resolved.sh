systemd_resolved() {

  printf "${C_WHITE}> ${INFO} ${C_WHITE}systemctl ${C_GREEN}enable${C_WHITE} systemd-resolved.${NO_FORMAT}"
  jump
  systemctl enable systemd-resolved &> /dev/null
  ln -sf /run/systemd/resolve/stub-resolv.conf /mnt/etc/resolv.conf

  
  printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Changing DNS to ${C_PINK}1.1.1.1 and 9.9.9.9${NO_FORMAT}."
  jump
  echo "DNS=1.1.1.1#cloudflare-dns.com" >> /mnt/etc/systemd/resolved.conf
  echo "FallbackDNS=9.9.9.9#dns.quad9.net" >> /mnt/etc/systemd/resolved.conf

  printf "${C_WHITE}> ${INFO} ${NO_FORMAT}Enabling ${C_PINK}DNSoverTLS${NO_FORMAT}."
  jump
  echo "DNSOverTLS=yes" >> /mnt/etc/systemd/resolved.conf
}