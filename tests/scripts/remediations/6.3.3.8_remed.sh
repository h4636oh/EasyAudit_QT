#!/usr/bin/env bash

# Create or edit the audit rules file with the relevant rules
sudo bash -c 'printf "
-w /etc/group -p wa -k identity
-w /etc/passwd -p wa -k identity
-w /etc/gshadow -p wa -k identity
-w /etc/shadow -p wa -k identity
-w /etc/security/opasswd -p wa -k identity
-w /etc/nsswitch.conf -p wa -k identity
-w /etc/pam.conf -p wa -k identity
-w /etc/pam.d -p wa -k identity
" > /etc/audit/rules.d/50-identity.rules'

echo "Audit rules have been added to /etc/audit/rules.d/50-identity.rules"

# Merge and load the rules into the active configuration
sudo augenrules --load

# Check if a reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
else
    printf "Rules have been loaded successfully without requiring a reboot\n"
fi

