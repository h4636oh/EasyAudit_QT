#!/usr/bin/env bash

# Define the minimum expected audit_backlog_limit value
minimum_backlog_limit="8192"

# Extract the current audit_backlog_limit value from /etc/default/grub
current_backlog_limit=$(grep -Po '^\s*GRUB_CMDLINE_LINUX="[^"]*\baudit_backlog_limit=\d+\b' /etc/default/grub | grep -oP '\d+$')

# Check if the audit_backlog_limit is set
if [[ -z "$current_backlog_limit" ]]; then
    echo "Fail: audit_backlog_limit is not set in /etc/default/grub."
    exit 1
fi

# Check if the current backlog limit is greater than or equal to the minimum required value
if [[ "$current_backlog_limit" -ge "$minimum_backlog_limit" ]]; then
    echo "Pass: audit_backlog_limit is correctly set to $current_backlog_limit, which is >= $minimum_backlog_limit."
    exit 0
else
    echo "Fail: audit_backlog_limit is set to $current_backlog_limit, which is less than $minimum_backlog_limit."
    exit 1
fi
