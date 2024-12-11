#!/bin/bash

# Check for accounts in /etc/shadow that have empty password fields
echo "Checking for accounts with empty password fields in /etc/shadow..."

# Use awk to find accounts with empty password fields
output=$(awk -F: '($2 == "") { print $1 " does not have a password." }' /etc/shadow)

if [ -z "$output" ]; then
    echo "All accounts have valid passwords."
    exit 0
else
    echo "The following accounts do not have passwords:"
    echo "$output"
    exit 1
fi