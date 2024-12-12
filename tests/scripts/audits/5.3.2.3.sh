#!/usr/bin/env bash

# Define the file to check
file="/etc/pam.d/common-password"

# Define the expected pattern
expected_pattern="password requisite pam_pwquality.so retry=3"

echo "Auditing pam_pwquality.so configuration in $file..."

# Check if the file exists
if [[ -f "$file" ]]; then
    echo "Checking $file..."
    
    # Search for pam_pwquality.so in the file
    result=$(grep -P -- '\bpam_pwquality\.so\b' "$file")
    
    if [[ $? -eq 0 ]]; then
        echo "PASS: pam_pwquality.so found in $file."
        
        # Verify if the line matches the expected pattern
        if [[ "$result" == *"$expected_pattern"* ]]; then
            echo "PASS: Configuration matches expected: $expected_pattern"
        else
            echo "FAIL: Configuration does not match expected in $file."
            echo "Expected: $expected_pattern"
            echo "Found: $result"
        fi
    else
        echo "FAIL: pam_pwquality.so not found in $file."
    fi
else
    echo "FAIL: $file does not exist!"
fi

echo "Audit completed."
