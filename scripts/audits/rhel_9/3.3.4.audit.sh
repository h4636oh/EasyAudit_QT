#!/usr/bin/env bash

# This script audits the kernel parameter net.ipv4.icmp_echo_ignore_broadcasts
# ensuring it is set to 1 to prevent potential Smurf attacks.
# It checks both the running configuration and configuration files.

# Define the expected kernel parameter and value
PARAMETER="net.ipv4.icmp_echo_ignore_broadcasts"
EXPECTED_VALUE="1"

# Function to check running configuration
check_running_config() {
    local current_value
    current_value=$(sysctl -n "$PARAMETER")
    
    if [ "$current_value" != "$EXPECTED_VALUE" ]; then
        echo "- $PARAMETER is incorrectly set to $current_value in the running configuration."
        return 1
    else
        echo "- $PARAMETER is correctly set in the running configuration."
    fi
}

# Function to check configuration files
check_config_files() {
    local files_checked=0
    local file_value
    local parameter_found=0

    # Check all relevant configuration files
    for file in /etc/sysctl.conf /etc/sysctl.d/*.conf; do
        if [ -f "$file" ] && grep -q -m1 "^$PARAMETER" "$file"; then
            parameter_found=1
            file_value=$(awk -F= -v param="$PARAMETER" '$1 == param {gsub(/[[:space:]]*/, "", $2); print $2}' "$file")

            if [ "$file_value" == "$EXPECTED_VALUE" ]; then
                echo "- $PARAMETER is correctly set to $EXPECTED_VALUE in $file"
            else
                echo "- $PARAMETER is incorrectly set to $file_value in $file"
                return 1
            fi
            files_checked=1
        fi
    done

    if [ "$parameter_found" -eq 0 ]; then
        echo "- $PARAMETER is not set in any configuration file."
        return 1
    fi

    if [ "$files_checked" -eq 0 ]; then
        echo "- No relevant configuration files were found."
    fi
}

# Run the checks
audit_passed=0

echo "Starting audit of $PARAMETER..."

if ! check_running_config; then
    audit_passed=1
fi

if ! check_config_files; then
    audit_passed=1
fi

# Set the appropriate exit code based on audit results
if [ "$audit_passed" -eq 0 ]; then
    echo "Audit Result: ** PASS **"
    exit 0
else
    echo "Audit Result: ** FAIL **"
    exit 1
fi
