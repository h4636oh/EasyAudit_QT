#!/usr/bin/env bash

# Audit script to verify pwhistory remember option in /etc/pam.d/common-password

echo "Starting audit for pwhistory remember option..."

# Run the grep command to check if remember=<N> is present and its value is 24 or more
grep_result=$(grep -Psi '^\h*password\h+[^#\n\r]+\h+pam_pwhistory\.so\h+([^#\n\r]+\h+)?remember=\d+\b' /etc/pam.d/common-password)

# If no matching result is found, return an error message
if [ -z "$grep_result" ]; then
    echo "Error: No pwhistory line found or remember option is missing."
else
    echo "Matching line found in /etc/pam.d/common-password:"
    echo "$grep_result"
    
    # Extract the remember value and check if it's 24 or more
    remember_value=$(echo "$grep_result" | grep -oP 'remember=\K\d+')
    
    if [ "$remember_value" -ge 24 ]; then
        echo "pwhistory remember value is $remember_value, which meets the required threshold."
    else
        echo "pwhistory remember value is $remember_value, which is below the required threshold of 24."
    fi
fi

echo "Audit completed."