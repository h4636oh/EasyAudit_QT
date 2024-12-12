#!/usr/bin/env bash

echo "Auditing PermitRootLogin setting..."

# Check the current PermitRootLogin setting in sshd configuration
root_login_setting=$(sshd -T | grep -i permitrootlogin)

# Display the current PermitRootLogin setting
if [[ -n "$root_login_setting" ]]; then
    echo "Current setting: $root_login_setting"
else
    echo "PermitRootLogin setting not found in sshd configuration."
    exit 1
fi

# Extract the value (yes/no/prohibit-password/forced-commands-only)
current_value=$(echo "$root_login_setting" | awk '{print $2}')

# Verify if PermitRootLogin is set to 'no'
if [[ "$current_value" == "no" ]]; then
    echo "Audit passed: PermitRootLogin is correctly set to 'no'."
else
    echo "Audit failed: PermitRootLogin is set to '$current_value' (should be 'no')."
    exit 1
fi

# Check for Match block overrides for user 'sshuser'
echo -e "\nChecking PermitRootLogin for user 'sshuser' (if Match blocks are used)..."
match_root_login=$(sshd -T -C user=sshuser | grep -i permitrootlogin)

if [[ -n "$match_root_login" ]]; then
    echo "Match block setting for sshuser: $match_root_login"
    match_value=$(echo "$match_root_login" | awk '{print $2}')
    if [[ "$match_value" == "no" ]]; then
        echo "Match block audit passed: PermitRootLogin is correctly set to 'no' for sshuser."
    else
        echo "Match block audit failed: PermitRootLogin is set to '$match_value' (should be 'no') for sshuser."
        exit 1
    fi
else
    echo "No Match block override for user 'sshuser'."
    exit 1
fi