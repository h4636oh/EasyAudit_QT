#!/bin/bash

# This script audits SSH configuration to ensure specific user/group access restrictions are applied.

# Execute the SSHD configuration test
output=$(sshd -T | grep -Pi -- '^\h*(allow|deny)(users|groups)\h+\H+')

# Requirement: The output should match one of the conditions
echo "Checking SSH access configuration..."
if echo "$output" | grep -q -E '^(allowusers |allowgroups |denyusers |denygroups )'; then
    echo "Audit passed: SSH access restrictions are configured."
    exit 0
else
    echo "Audit failed: No SSH access restrictions found."
    echo "Please configure SSH access restrictions by editing /etc/ssh/sshd_config"
    echo "Add one of the following directives according to your policy:"
    echo "- AllowUsers <userlist>"
    echo "- AllowGroups <grouplist>"
    echo "- DenyUsers <userlist>"
    echo "- DenyGroups <grouplist>"
    echo "Ensure settings are specified before any 'Include' or 'Match' statements."
    exit 1
fi

# Comment on Assumptions:
# - This script assumes the `sshd -T` command outputs correctly formatted configuration lines.
# - The script checks whether any of the required SSH directives (`AllowUsers`, `AllowGroups`, `DenyUsers`, `DenyGroups`) are present in the SSH configuration.
# - It prompts the user to make necessary changes to `/etc/ssh/sshd_config` manually if the audit fails.