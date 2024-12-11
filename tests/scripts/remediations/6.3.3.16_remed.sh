#!/usr/bin/env bash

# Set the minimum user ID to filter for successful and unsuccessful attempts to use the setfacl command
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

if [ -n "${UID_MIN}" ]; then
    # Create or edit the audit rules file with the relevant rules
    sudo bash -c "printf '
-a always,exit -F path=/usr/bin/setfacl -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k perm_chng
' >> /etc/audit/rules.d/50-perm_chng.rules"
    echo "Audit rules have been added to /etc/audit/rules.d/50-perm_chng.rules"
else
    echo "ERROR: Variable 'UID_MIN' is unset."
    exit 1
fi

# Merge and load the rules into the active configuration
sudo augenrules --load

# Check if a reboot is required
if [[ $(auditctl -s | grep 'enabled') =~ '2' ]]; then
    printf "Reboot required to load rules\n"
else
    printf "Rules have been loaded successfully without requiring a reboot\n"
fi

