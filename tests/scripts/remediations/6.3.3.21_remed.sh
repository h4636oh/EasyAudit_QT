#!/usr/bin/env bash

# Merge and load all rules
sudo augenrules --load

# Check if a reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    echo "Reboot required to load rules"
else
    echo "Rules have been loaded successfully without requiring a reboot"
fi

