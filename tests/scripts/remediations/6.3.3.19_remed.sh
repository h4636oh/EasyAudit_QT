#!/usr/bin/env bash

# Set the minimum user ID to filter for kernel module modifications
UID_MIN=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

if [ -n "${UID_MIN}" ]; then
    # Create or edit the audit rules file with the relevant rules
    sudo bash -c "printf '
-a always,exit -F arch=b64 -S init_module,finit_module,delete_module -F auid>=${UID_MIN} -F auid!=unset -k kernel_modules
-a always,exit -F path=/usr/bin/kmod -F perm=x -F auid>=${UID_MIN} -F auid!=unset -k kernel_modules
' >> /etc/audit/rules.d/50-kernel_modules.rules"
    echo "Audit rules have been added to /etc/audit/rules.d/50-kernel_modules.rules"
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

