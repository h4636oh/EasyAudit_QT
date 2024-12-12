#!/usr/bin/env bash

echo "Auditing MaxSessions setting..."

# Check the current MaxSessions value in sshd configuration
max_sessions=$(sshd -T | grep -i maxsessions)

# Display the current MaxSessions setting
if [[ -n "$max_sessions" ]]; then
    echo "Current setting: $max_sessions"
else
    echo "MaxSessions setting not found in sshd configuration."
    exit 1
fi

# Extract the numerical value
current_value=$(echo "$max_sessions" | awk '{print $2}')

# Verify if MaxSessions is 10 or less
if [[ "$current_value" -le 10 ]]; then
    echo "Audit passed: MaxSessions is set to $current_value (10 or less)."
else
    echo "Audit failed: MaxSessions is set to $current_value (greater than 10)."
    exit 1
fi

# Search configuration files for invalid MaxSessions values (greater than 10)
echo -e "\nChecking for invalid MaxSessions entries in configuration files..."
invalid_entries=$(grep -Psi -- '^\h*MaxSessions\h+\"?(1[1-9]|[2-9][0-9]|[1-9][0-9][0-9]+)\b' /etc/ssh/sshd_config /etc/ssh/sshd_config.d/*.conf 2>/dev/null)

if [[ -z "$invalid_entries" ]]; then
    echo "No invalid MaxSessions settings found in configuration files."
else
    echo "Invalid MaxSessions settings found:"
    echo "$invalid_entries"
    exit 1
fi

# Check for Match block overrides if needed
echo -e "\nChecking MaxSessions for user 'sshuser' (if Match blocks are used)..."
match_max_sessions=$(sshd -T -C user=sshuser | grep -i maxsessions)
if [[ -n "$match_max_sessions" ]]; then
    echo "Match block setting for sshuser: $match_max_sessions"
else
    echo "No Match block override for user 'sshuser'."
    exit 1
fi