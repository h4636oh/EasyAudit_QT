#!/bin/bash

# Command to search for lines starting with 'linux' in grub.cfg and filter out lines not containing 'audit_backlog_limit='
result=$(find /boot -type f -name 'grub.cfg' -exec grep -Ph -- '^\h*linux' {} + | grep -Pv 'audit_backlog_limit=\d+\b')

# Check if any lines are returned
if [ -z "$result" ]; then
    echo "No lines found without 'audit_backlog_limit='."
else
    echo "Warning: The following lines do not contain 'audit_backlog_limit=':"
    echo "$result"
    exit 1
fi

