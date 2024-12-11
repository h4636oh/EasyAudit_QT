#!/bin/bash

# This script audits the 'space_left_action' and 'admin_space_left_action' settings
# in the /etc/audit/auditd.conf file to ensure they are configured correctly.

# Verify space_left_action is set to email, exec, single, or halt
space_left_action_check=$(grep -P -- '^\h*space_left_action\h*=\h*(email|exec|single|halt)\b' /etc/audit/auditd.conf)
admin_space_left_action_check=$(grep -P -- '^\h*admin_space_left_action\h*=\h*(single|halt)\b' /etc/audit/auditd.conf)

# Function to prompt user manual checks if required
prompt_manual_check() {
    echo "Please manually verify the auditd settings for:"
    echo "- space_left_action: ensure it is set to email, exec, single, or halt"
    echo "- admin_space_left_action: ensure it is set to single or halt"
}

# Check the output of the first command
if [[ -z $space_left_action_check ]]; then
    echo "Audit failed: space_left_action is not correctly set."
    prompt_manual_check
    exit 1
fi

# Check the output of the second command
if [[ -z $admin_space_left_action_check ]]; then
    echo "Audit failed: admin_space_left_action is not correctly set."
    prompt_manual_check
    exit 1
fi

# If all checks are passed
echo "Audit passed: Both space_left_action and admin_space_left_action are correctly set."
exit 0
```