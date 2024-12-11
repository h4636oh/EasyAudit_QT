#!/usr/bin/env bash

# Define the desired maximum days for passwords
MAX_DAYS=365

echo "Updating PASS_MAX_DAYS in /etc/login.defs to $MAX_DAYS..."
if grep -qP '^\h*PASS_MAX_DAYS\h+\d+\b' /etc/login.defs; then
    sed -i "s/^\h*PASS_MAX_DAYS\h\+\d\+/PASS_MAX_DAYS $MAX_DAYS/" /etc/login.defs
else
    echo "PASS_MAX_DAYS $MAX_DAYS" >> /etc/login.defs
fi

echo "Updated /etc/login.defs:"
grep -Pi '^\h*PASS_MAX_DAYS\h+\d+\b' /etc/login.defs

echo
echo "Updating non-compliant users in /etc/shadow to max days of $MAX_DAYS..."
awk -F: -v max_days="$MAX_DAYS" '($2 ~ /^\$.+\$/) {if ($5 > max_days || $5 < 1) system("chage --maxdays " max_days " " $1)}' /etc/shadow

echo "Verification of user settings:"
awk -F: '($2~/^\$.+\$/) {if($5 > 365 || $5 < 1) print "Non-compliant user: " $1 " | PASS_MAX_DAYS: " $5}' /etc/shadow

if [ $? -eq 0 ]; then
    echo "Remediation completed. All users should now be compliant."
else
    echo "Some users may still be non-compliant. Review manually."
fi