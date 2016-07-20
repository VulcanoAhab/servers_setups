
#install fail2bain
echo "[•] Starting fail2bain instalation"
sudo apt-get install fail2ban

# -------- set up firewall
sudo iptables-restore ipv4_only_ssh
sudo ip6tables-restore ipv6_close
sudo service iptables restart