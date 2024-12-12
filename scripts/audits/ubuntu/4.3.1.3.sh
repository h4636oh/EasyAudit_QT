dpkg-query -s ufw &>/dev/null && echo "ufw is installed"
# Nothing should be returned.
# - OR -
# Run the following command to verify ufw is disabled:
# ufw status
# Status: inactive
systemctl is-enabled ufw