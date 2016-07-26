
#install fail2bain
echo "[•] Starting fail2bain instalation"
apt-get install fail2ban

# -------- set up firewall
iptables-restore ipv4_only_ssh
ip6tables-restore ipv6_close
