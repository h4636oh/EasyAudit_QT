#!/bin/bash

# Check for accounts in /etc/passwd that do not use shadowed passwords
echo "Checking for accounts without shadowed passwords..."

# Use awk to find accounts without shadowed passwords
output=$(awk -F: '($2 != "x") { print ":User  \"" $1 "\" is not set to shadowed passwords." }' /etc/passwd)

if [ -z "$output" ]; then
    echo "All accounts are using shadowed passwords."
    exit 0
else
    echo "$output"
    exit 1
fi