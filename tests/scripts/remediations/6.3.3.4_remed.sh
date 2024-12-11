#!/bin/bash

# Create or edit the audit rules file with the relevant rules
sudo bash -c 'printf "
-a always,exit -F arch=b64 -S adjtimex,settimeofday,clock_settime -k time-change
-a always,exit -F arch=b32 -S adjtimex,settimeofday,clock_settime -k time-change
-w /etc/localtime -p wa -k time-change
" > /etc/audit/rules.d/50-time-change.rules'

echo "Audit rules have been added to /etc/audit/rules.d/50-time-change.rules"

# Merge and load the rules into the active configuration
sudo augenrules --load

# Check if a reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
else
    printf "Rules have been loaded successfully without requiring a reboot\n"
fi

