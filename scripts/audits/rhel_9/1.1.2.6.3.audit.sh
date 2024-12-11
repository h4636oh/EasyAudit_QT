#!/bin/bash

# Script to audit the nosuid option on the /var/log partition
# This script checks if the nosuid option is set on a separate /var/log partition

# Function to check if nosuid is set on /var/log
audit_nosuid_option() {
    # Find the mount point for /var/log and check for nosuid option
    if findmnt -kn /var/log | grep -v nosuid &> /dev/null; then
        echo "Audit failed: The nosuid option is NOT set on /var/log partition."
        # Exit with status 1 indicating audit failure
        exit 1
    else
        echo "Audit passed: The nosuid option is set on /var/log partition."
        # Exit with status 0 indicating audit success
        exit 0
    fi
}

# Check if /var/log is mounted on a separate partition
if findmnt /var/log &> /dev/null; then
    # Separate partition exists, perform audit
    audit_nosuid_option
else
    # No separate partition found, inform user
    echo "Manual check required: /var/log is not on a separate partition."
    echo "Please ensure that /var/log is on a separate partition and check the nosuid option manually."
    # Exit with status 1 as audit cannot be performed
    exit 1
fi

