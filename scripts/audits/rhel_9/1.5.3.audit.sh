#!/usr/bin/env bash

# This script audits if ProcessSizeMax is set to 0 in /etc/systemd/coredump.conf or a file in the /etc/systemd/coredump.conf.d/ directory.
# It exits with status 0 if the audit passes, or with status 1 if it fails.

# Variable to store the audit result
audit_fail=0

# List of expected parameters
expected_param="ProcessSizeMax=0"

# Function to check if ProcessSizeMax is set to 0 in a given config file
check_process_size_max() {
    local config_file="$1"
    # Use systemd-analyze to extract the effective configuration
    effective_value=$(systemd-analyze cat-config "$config_file" | awk -F= '/^\s*ProcessSizeMax/ {print $2}' | xargs)

    if [ "$effective_value" == "0" ]; then
        echo "PASS: ProcessSizeMax is correctly set to 0 in $config_file"
    else
        echo "FAIL: ProcessSizeMax is set to $effective_value in $config_file, expected 0"
        audit_fail=1
    fi
}

# Checking main coredump configuration file
check_process_size_max "/etc/systemd/coredump.conf"

# Check any additional configuration files in /etc/systemd/coredump.conf.d/
for config_file in /etc/systemd/coredump.conf.d/*.conf; do
    [ -e "$config_file" ] || continue
    check_process_size_max "$config_file"
done

# Final audit result
if [ "$audit_fail" -eq 1 ]; then
    echo "Audit failed."
    exit 1
else
    echo "Audit passed."
    exit 0
fi