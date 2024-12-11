#!/usr/bin/env bash

# Create or edit the audit rules file with the relevant rules
sudo bash -c 'printf "
-w /etc/apparmor/ -p wa -k MAC-policy
-w /etc/apparmor.d/ -p wa -k MAC-policy
" > /etc/audit/rules.d/50-MAC-policy.rules'

echo "Audit rules have been added to /etc/audit/rules.d/50-MAC-policy.rules"

# Merge and load the rules into the active configuration
sudo augenrules --load

# Check if a reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
else
    printf "Rules have been loaded successfully without requiring a reboot\n"
fi

