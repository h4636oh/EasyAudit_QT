#!/bin/bash

# Command to check for accounts with UID 0
output=$(awk -F: '($3 == 0) { print $1 }' /etc/passwd)

# Check if only "root" is returned
if [[ "$output" == "root" ]]; then
    echo "Only the root account has UID 0."
else
    echo "Accounts with UID 0:"
    echo "$output"
    echo "Warning: Only the root account should have UID 0. Please review the accounts listed above."
    exit 1
fi

