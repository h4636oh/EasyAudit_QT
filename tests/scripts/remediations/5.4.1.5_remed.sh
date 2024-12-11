#!/usr/bin/env bash

# Set default INACTIVE period to 45 days
echo "Setting default INACTIVE period to 45 days..."
useradd -D -f 45
if [[ $? -eq 0 ]]; then
    echo "Default INACTIVE period set to 45 days successfully."
else
    echo "Failed to set default INACTIVE period."
    exit 1
fi
echo

# Update INACTIVE period for existing users
echo "Updating INACTIVE period for users with non-compliant settings..."
awk -F: '($2~/^\$.+\$/) {if($7 > 45 || $7 < 0)system ("chage --inactive 45 " $1)}' /etc/shadow

# Verify changes
echo
echo "Re-auditing user INACTIVE settings in /etc/shadow..."
awk -F: '($2~/^\$.+\$/) {if($7 > 45 || $7 < 0)print "User: " $1 " INACTIVE: " $7}' /etc/shadow

if [[ $? -eq 0 ]]; then
    echo "All users now have compliant INACTIVE settings."
else
    echo "Some users still have non-compliant settings. Please investigate further."
fi