#!/bin/bash

# Audit Script for Ensuring Separate Partition for /var/log/audit

# This script checks if /var/log/audit is mounted on a separate partition
# Exits 0 if /var/log/audit is on a separate partition, otherwise exits 1.

# Define the expected mount point options
EXPECTED_OPTIONS="rw,nosuid,nodev,noexec"

# Command to check the mounted filesystems
MOUNTED_OUTPUT=$(findmnt -kn /var/log/audit)

# Extract the actual mount point and options if it exists
ACTUAL_MOUNT=$(echo "$MOUNTED_OUTPUT" | awk '{print $1}')
ACTUAL_OPTIONS=$(echo "$MOUNTED_OUTPUT" | awk -F' ' '{print $4}')

# Audit check
echo "Auditing /var/log/audit partition setup..."

if [ -n "$ACTUAL_MOUNT" ]; then
    # Verify that the actual options match the expected options
    if [[ "$ACTUAL_OPTIONS" == *"$EXPECTED_OPTIONS"* ]]; then
        echo "PASSED: /var/log/audit is mounted with the appropriate options on a separate partition."
        exit 0
    else
        echo "FAILED: /var/log/audit is not mounted with the appropriate mount options."
        echo "Actual mount options are: $ACTUAL_OPTIONS"
        exit 1
    fi
else
    echo "FAILED: /var/log/audit is not on a separate partition."
    exit 1
fi