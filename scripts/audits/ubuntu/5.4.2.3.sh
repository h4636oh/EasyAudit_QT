#!/bin/bash

# Command to check for groups with GID 0
output=$(awk -F: '$3=="0"{print $1":"$3}' /etc/group)

# Check if only "root" is returned
if [[ "$output" == "root:0" ]]; then
    echo "Only the root group has GID 0."
else
    if [[ -n "$output" ]]; then
        echo "Groups with GID 0:"
        echo "$output"
        echo "Warning: Only the root group should have GID 0. Please review the groups listed above."
    else
        echo "No groups found with GID 0."
    fi
fi

