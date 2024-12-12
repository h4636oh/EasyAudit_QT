dpkg-query -s ufw &>/dev/null && echo "ufw is installed"
# Nothing should be returned
# -OR-
# Run the following commands to verify ufw is disabled and ufw.service is not enabled:
# ufw status
# # Status: inactive
# systemctl is-enabled ufw.service
# # masked