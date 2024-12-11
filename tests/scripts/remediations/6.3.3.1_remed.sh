#!/bin/bash

# Create or edit the audit rules file with the relevant rules
sudo bash -c 'printf "%s\n" "-w /etc/sudoers -p wa -k scope" "-w /etc/sudoers.d -p wa -k scope" > /etc/audit/rules.d/50-scope.rules'

# Merge and load the rules into the active configuration
sudo augenrules --load

# Check if a reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
else
    printf "Rules have been loaded successfully without requiring a reboot\n"
fi

