#!/bin/bash

# Command to verify the root user's password is set
output=$(passwd -S root | awk '$2 ~ /^P/ {print "User: \"" $1 "\" Password is set"}')

# Check if the output is as expected
if [[ -n "$output" ]]; then
    echo "$output"
else
    echo "The root user's password is not set."
    exit 1
fi

