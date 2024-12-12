#!/bin/bash

# Command to check for users with primary GID 0, excluding sync, shutdown, halt, and operator
output=$(awk -F: '($1 !~ /^(sync|shutdown|halt|operator)/ && $4=="0") {print $1":"$4}' /etc/passwd)

# Check if only "root" is returned
if [[ "$output" == "root:0" ]]; then
    echo "Only the root account has primary GID 0."
else
    if [[ -n "$output" ]]; then
        echo "Accounts with primary GID 0:"
        echo "$output"
        echo "Warning: Only the root account should have primary GID 0, except for sync, shutdown, halt, and operator. Please review the accounts listed above."
    else
        echo "No accounts found with primary GID 0, other than the allowed exceptions."
        exit 1
    fi
fi

