#!/bin/bash

# Script to audit if /var/tmp is mounted as a separate partition with the appropriate mount options.

# Command to find mount information for /var/tmp
output=$(findmnt -kn /var/tmp)

# Expected example format:
# /var/tmp /dev/sdb ext4 rw,nosuid,nodev,noexec,relatime,seclabel
# Modify the example below based on the actual system's expected configuration
expected_output_format="ext4 rw,nosuid,nodev,noexec"

# Function to check if /var/tmp is mounted separately
check_var_tmp_mount() {
    if [[ "$output" == */var/tmp* && "$output" == *"$expected_output_format"* ]]; then
        echo "/var/tmp is mounted as a separate partition with appropriate options."
        exit 0 # Pass the audit
    else
        echo "Audit Failed: /var/tmp is not mounted correctly."
        echo "Please manually ensure /var/tmp is mounted as a separate partition with 'nosuid', 'nodev', and 'noexec' options."
        exit 1 # Fail the audit
    fi
}

# Execute the check function
check_var_tmp_mount

# This script checks if the `/var/tmp` directory is mounted as a separate partition with the recommended mount options (`nosuid`, `nodev`, `noexec`) which enhance security by limiting certain operations. If these conditions are met, the script exits with a status `0` (success); otherwise, it prompts the user to configure it manually and exits with a status `1` (failure). Modify the `expected_output_format` based on your actual mount configurations to ensure proper auditing.