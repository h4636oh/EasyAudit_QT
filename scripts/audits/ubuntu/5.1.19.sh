#!/usr/bin/env bash

echo "Auditing PermitEmptyPasswords setting..."

# Check the current PermitEmptyPasswords setting in sshd configuration
empty_pw_setting=$(sshd -T | grep -i permitemptypasswords)

# Display the current PermitEmptyPasswords setting
if [[ -n "$empty_pw_setting" ]]; then
    echo "Current setting: $empty_pw_setting"
else
    echo "PermitEmptyPasswords setting not found in sshd configuration."
    exit 1
fi

# Extract the value (yes/no)
current_value=$(echo "$empty_pw_setting" | awk '{print $2}')

# Verify if PermitEmptyPasswords is set to 'no'
if [[ "$current_value" == "no" ]]; then
    echo "Audit passed: PermitEmptyPasswords is correctly set to 'no'."
else
    echo "Audit failed: PermitEmptyPasswords is set to '$current_value' (should be 'no')."
    exit 1
fi

# Check for Match block overrides for user 'sshuser'
echo -e "\nChecking PermitEmptyPasswords for user 'sshuser' (if Match blocks are used)..."
match_pw_setting=$(sshd -T -C user=sshuser | grep -i permitemptypasswords)

if [[ -n "$match_pw_setting" ]]; then
    echo "Match block setting for sshuser: $match_pw_setting"
    match_value=$(echo "$match_pw_setting" | awk '{print $2}')
    if [[ "$match_value" == "no" ]]; then
        echo "Match block audit passed: PermitEmptyPasswords is correctly set to 'no' for sshuser."
    else
        echo "Match block audit failed: PermitEmptyPasswords is set to '$match_value' (should be 'no') for sshuser."
        exit 1
    fi
else
    echo "No Match block override for user 'sshuser'."
    exit 1
fi