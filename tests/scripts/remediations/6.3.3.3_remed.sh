#!/bin/bash

# Get the sudo log file path
SUDO_LOG_FILE=$(grep -r logfile /etc/sudoers* | sed -e 's/.*logfile=//;s/,? .*//' -e 's/"//g')

# Check if the SUDO_LOG_FILE variable is set
if [ -n "${SUDO_LOG_FILE}" ]; then
    # Create or edit the audit rules file with the relevant rules
    sudo bash -c "printf '\n-w ${SUDO_LOG_FILE} -p wa -k sudo_log_file\n' >> /etc/audit/rules.d/50-sudo.rules"
    echo "Audit rules have been added to /etc/audit/rules.d/50-sudo.rules"
else
    echo "ERROR: Variable 'SUDO_LOG_FILE' is unset."
fi

# Merge and load the rules into the active configuration
sudo augenrules --load

# Check if a reboot is required
if [[ $(auditctl -s | grep "enabled") =~ "2" ]]; then
    printf "Reboot required to load rules\n"
else
    printf "Rules have been loaded successfully without requiring a reboot\n"
fi

