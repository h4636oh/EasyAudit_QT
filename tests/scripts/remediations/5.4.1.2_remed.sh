#!/usr/bin/env bash

# Define the minimum days for password changes
MIN_DAYS=1

echo "Setting PASS_MIN_DAYS in /etc/login.defs..."
if grep -Pi '^\h*PASS_MIN_DAYS\h+\d+\b' /etc/login.defs > /dev/null; then
    sudo sed -i "s/^\h*PASS_MIN_DAYS\h\+\d\+/PASS_MIN_DAYS $MIN_DAYS/" /etc/login.defs
    echo "PASS_MIN_DAYS updated to $MIN_DAYS in /etc/login.defs."
else
    echo "PASS_MIN_DAYS $MIN_DAYS" | sudo tee -a /etc/login.defs
    echo "PASS_MIN_DAYS added with value $MIN_DAYS in /etc/login.defs."
fi

echo
echo "Updating PASS_MIN_DAYS for users in /etc/shadow..."
awk -F: '($2~/^\$.+\$/) {if($4 < 1) system ("chage --mindays '"$MIN_DAYS"' " $1)}' /etc/shadow

echo "Remediation completed."