#!/usr/bin/env bash

# Define the required warning age
REQUIRED_WARN_AGE=7

echo "Remediating PASS_WARN_AGE in /etc/login.defs..."

# Backup the original file
cp /etc/login.defs /etc/login.defs.bak

# Set PASS_WARN_AGE to the required value
if grep -qPi '^\h*PASS_WARN_AGE\h+\d+\b' /etc/login.defs; then
    sed -ri 's/^\h*PASS_WARN_AGE\h+\d+\b/PASS_WARN_AGE '"$REQUIRED_WARN_AGE"'/' /etc/login.defs
else
    echo "PASS_WARN_AGE $REQUIRED_WARN_AGE" >> /etc/login.defs
fi

echo "PASS_WARN_AGE in /etc/login.defs set to $REQUIRED_WARN_AGE."
echo

echo "Updating PASS_WARN_AGE for users in /etc/shadow..."
awk -F: '($2~/^\$.+\$/) {if($6 < '"$REQUIRED_WARN_AGE"') system ("chage --warndays '"$REQUIRED_WARN_AGE"' " $1)}' /etc/shadow

echo "Remediation completed."