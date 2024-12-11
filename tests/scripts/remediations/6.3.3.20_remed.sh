#!/usr/bin/env bash

# Add the line '-e 2' to the end of the file /etc/audit/rules.d/99-finalize.rules
sudo bash -c 'printf -- "-e 2\n" >> /etc/audit/rules.d/99-finalize.rules'

echo "Added '-e 2' to /etc/audit/rules.d/99-finalize.rules"

# Merge and load the rules into the active configuration
sudo augenrules --load

# Check if a reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
else
    printf "Rules have been loaded successfully without requiring a reboot\n"
fi

