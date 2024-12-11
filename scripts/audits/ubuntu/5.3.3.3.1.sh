#!/usr/bin/env bash

# Audit script to verify pwhistory remember option in /etc/pam.d/common-password

echo "Starting audit for pwhistory remember option..."

# Check if /etc/pam.d/common-password exists
if [ ! -f /etc/pam.d/common-password ]; then
    echo "Error: /etc/pam.d/common-password does not exist. This file is not present on your system."
    exit 2
fi

# Print the contents of /etc/pam.d/common-password for debugging
echo "Contents of /etc/pam.d/common-password:"
cat /etc/pam.d/common-password

# Run the grep command to check if remember=<N> is present and its value is 24 or more
grep_result=$(grep -Psi 'pam_pwhistory\.so.*remember=[0-9]+' /etc/pam.d/common-password)

# If no matching result is found, return an error message
if [ -z "$grep_result" ]; then
    echo "Error: No pwhistory line found or remember option is missing."
    exit 3
else
    echo "Matching line found in /etc/pam.d/common-password:"
    echo "$grep_result"
    
    # Extract the remember value and check if it's 24 or more
    remember_value=$(echo "$grep_result" | grep -oP 'remember=\K\d+')
    
    if [ "$remember_value" -ge 24 ]; then
        echo "pwhistory remember value is $remember_value, which meets the required threshold."
    else
        echo "pwhistory remember value is $remember_value, which is below the required threshold of 24."
        exit 4
    fi
fi

echo "Audit completed."
exit 0
