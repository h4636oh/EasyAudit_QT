#!/bin/bash

# Command to search for lines starting with 'linux' in grub.cfg and filter out lines containing 'audit=1'
result=$(find /boot -type f -name 'grub.cfg' -exec grep -Ph -- '^\h*linux' {} + | grep -v 'audit=1')

# Check if any lines are returned
if [ -z "$result" ]; then
    echo "No lines found without 'audit=1'."
else
    echo "Warning: The following lines do not contain 'audit=1':"
    echo "$result"
    exit 1
fi

