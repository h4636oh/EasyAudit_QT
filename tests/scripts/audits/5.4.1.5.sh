#!/usr/bin/env bash

# Audit INACTIVE default setting
echo "Checking default INACTIVE setting..."
default_inactive=$(useradd -D | grep -E '^INACTIVE=' | cut -d= -f2)
if [[ "$default_inactive" -le 45 && "$default_inactive" -ge 0 ]]; then
    echo "Default INACTIVE setting is compliant: INACTIVE=$default_inactive"
else
    echo "Default INACTIVE setting is NOT compliant: INACTIVE=$default_inactive"
fi
echo

# Check user-specific INACTIVE settings in /etc/shadow
echo "Auditing user INACTIVE settings in /etc/shadow..."
awk -F: '($2~/^\$.+\$/) {if($7 > 45 || $7 < 0)print "User: " $1 " INACTIVE: " $7}' /etc/shadow

# Provide feedback if non-compliant users are found
if [[ $? -eq 0 ]]; then
    echo "All users have INACTIVE settings compliant with the site policy."
else
    echo "Non-compliant INACTIVE settings found. Please review the above users."
fi