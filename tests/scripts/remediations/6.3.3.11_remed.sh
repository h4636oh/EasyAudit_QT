#!/usr/bin/env bash

# Create or edit the audit rules file with the relevant rules
sudo bash -c 'printf "
-w /var/run/utmp -p wa -k session
-w /var/log/wtmp -p wa -k session
-w /var/log/btmp -p wa -k session
" > /etc/audit/rules.d/50-session.rules'

echo "Audit rules have been added to /etc/audit/rules.d/50-session.rules"

# Merge and load the rules into the active configuration
sudo augenrules --load

# Check if a reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
else
    printf "Rules have been loaded successfully without requiring a reboot\n"
fi

