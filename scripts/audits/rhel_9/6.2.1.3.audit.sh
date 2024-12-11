#!/bin/bash

# Audit Script: Ensuring journald log file rotation configuration
# Profile Applicability:
# - Level 1 - Server
# - Level 1 - Workstation

# Description:
# - This script audits the journald configuration to ensure log file rotation
#   is set according to the organization's site policy.

# Variables
CONFIG_FILE="/etc/systemd/journald.conf"
CONFIG_DIR="/etc/systemd/journald.conf.d"
AUDIT_COMMAND="systemd-analyze cat-config systemd/journald.conf"
LOG_ROTATION_KEYS="SystemMaxUse|SystemKeepFree|RuntimeMaxUse|RuntimeKeepFree|MaxFileSec"

# Check if 'systemd-analyze' command is available
if ! command -v systemd-analyze &> /dev/null; then
    echo "systemd-analyze command is required but not installed. Please install systemd-analyze."
    exit 1
fi

# Prompt user to manually review configuration
echo "Please manually review the following configuration files:"
echo "- $CONFIG_FILE"
echo "- Any files ending in .conf in the directory $CONFIG_DIR/"
echo "Ensure that log rotation parameters align with your site policy."
echo "Parameters to check include: SystemMaxUse, SystemKeepFree, RuntimeMaxUse, RuntimeKeepFree, MaxFileSec."

# Run the audit command to extract current log rotation settings
echo "Running audit command to extract current log rotation settings..."
OUTPUT=$($AUDIT_COMMAND | grep -E "$LOG_ROTATION_KEYS")

# Display extracted settings to the user
echo "Current journald log file rotation settings:"
echo "$OUTPUT"

# Check if all required settings are shown and prompt if not
REQUIRED_KEYS=("SystemMaxUse=" "SystemKeepFree=" "RuntimeMaxUse=" "RuntimeKeepFree=" "MaxFileSec=")

for key in "${REQUIRED_KEYS[@]}"; do
    if ! echo "$OUTPUT" | grep -q "$key"; then
        echo "Missing or unconfigured parameter: $key - Please verify manually."
        echo "Audit failed due to missing configuration. Please check your configuration settings."
        exit 1
    fi
done

# If all checks passed
echo "All required log rotation settings are present. Please ensure they meet your site policy requirements."
exit 0


### Comments:
# - The script audits the `journald` configuration for log file rotation parameters.
# - It checks if the `systemd-analyze` command is available for use.
# - It prompts the user to manually review critical configuration files.
# - It uses regular expressions to verify the presence of required keys in the configuration output.
# - The script exits with a status of `1` if any key is missing, or `0` if all keys are present, aligning with the desired audit result.