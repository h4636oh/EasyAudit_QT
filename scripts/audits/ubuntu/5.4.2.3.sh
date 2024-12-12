awk -F: '$3=="0"{print $1":"$3}' /etc/group
root:0