#!/usr/bin/env bash

# Define the configuration files to check
files=(
    "/etc/pam.d/common-account"
    "/etc/pam.d/common-session"
    "/etc/pam.d/common-auth"
    "/etc/pam.d/common-password"
)

# Define the expected patterns
declare -A expected_patterns=(
    ["/etc/pam.d/common-account"]="account [success=1 new_authtok_reqd=done default=ignore] pam_unix.so"
    ["/etc/pam.d/common-session"]="session required pam_unix.so"
    ["/etc/pam.d/common-auth"]="auth [success=2 default=ignore] pam_unix.so try_first_pass"
    ["/etc/pam.d/common-password"]="password [success=1 default=ignore] pam_unix.so obscure use_authtok try_first_pass yescrypt"
)

echo "Auditing pam_unix.so configuration..."

# Iterate over the files and check for pam_unix.so
for file in "${files[@]}"; do
    if [[ -f "$file" ]]; then
        echo "Checking $file..."
        result=$(grep -P -- '\bpam_unix\.so\b' "$file")

        if [[ $? -eq 0 ]]; then
            echo "PASS: pam_unix.so found in $file."
            
            # Verify the line matches the expected pattern
            expected="${expected_patterns[$file]}"
            if [[ "$result" == *"$expected"* ]]; then
                echo "PASS: Configuration matches expected: $expected"
            else
                echo "FAIL: Configuration does not match expected for $file."
                echo "Expected: $expected"
                echo "Found: $result"
            fi
        else
            echo "FAIL: pam_unix.so not found in $file."
        fi
    else
        echo "FAIL: $file does not exist!"
    fi
    echo
done

echo "Audit completed."
