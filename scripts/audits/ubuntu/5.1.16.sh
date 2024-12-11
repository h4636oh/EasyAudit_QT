#!/usr/bin/env bash

# Run sshd test command to check MaxAuthTries setting
echo "Auditing MaxAuthTries setting..."
max_auth_tries=$(sshd -T | grep -Pi '^maxauthtries')

# Display the current setting
if [[ -n "$max_auth_tries" ]]; then
    echo "Current setting: $max_auth_tries"
else
    echo "MaxAuthTries setting not found in sshd configuration."
    exit 1
fi

# Verify if MaxAuthTries is 4 or less
max_value=$(echo "$max_auth_tries" | awk '{print $2}')
if [[ "$max_value" -le 4 ]]; then
    echo "Audit passed: MaxAuthTries is set to $max_value (4 or less)."
else
    echo "Audit failed: MaxAuthTries is set to $max_value (greater than 4)."
fi

# Check for Match block if required for a specific user
echo -e "\nChecking MaxAuthTries for user 'sshuser' (if Match blocks are used)..."
match_max_auth=$(sshd -T -C user=sshuser | grep -Pi '^maxauthtries')
if [[ -n "$match_max_auth" ]]; then
    echo "Match block setting: $match_max_auth"
else
    echo "No Match block override for user 'sshuser'."
    exit 1
fi