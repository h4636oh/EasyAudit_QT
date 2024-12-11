#!/usr/bin/env bash

# Define the configuration files to check
files=(
    "/etc/pam.d/common-auth"
    "/etc/pam.d/common-account"
)

# Define the expected patterns
declare -A expected_patterns=(
    ["/etc/pam.d/common-auth"]="auth requisite pam_faillock.so preauth\nauth [default=die] pam_faillock.so authfail"
    ["/etc/pam.d/common-account"]="account required pam_faillock.so"
)

echo "Auditing pam_faillock.so configuration..."

# Iterate over the files and check for pam_faillock.so
for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "Checking $file..."
        result=$(grep -P -- '\bpam_faillock\.so\b' "$file")

        if [[ $? -eq 0 ]]; then
            echo "Found pam_faillock.so in $file:"
            echo "$result"
            
            # Verify the configuration matches the expected pattern
            expected="${expected_patterns[$file]}"
            if echo "$result" | grep -qP "$expected"; then
                echo "Configuration matches expected for $file."
            else
                echo "WARNING: Configuration does not match expected for $file."
                echo "Expected:"
                echo -e "$expected"
                echo "Found:"
                echo "$result"
            fi
        else
            echo "ERROR: pam_faillock.so not found in $file!"
            exit 1
        fi
    else
        echo "ERROR: $file does not exist!"
        exit 1
    fi
    echo
done

echo "Audit completed."