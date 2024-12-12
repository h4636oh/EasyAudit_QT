dpkg-query -s iptables &>/dev/null && echo "iptables is installed"
dpkg-query -s iptables-persistent &>/dev/null && echo "iptables-persistent
is installed"