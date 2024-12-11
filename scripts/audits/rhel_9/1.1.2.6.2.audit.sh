#!/bin/bash

# Title: 1.1.2.6.2 Ensure nodev option set on /var/log partition (Automated)
# Description: The nodev mount option specifies that the filesystem cannot contain special devices.
# Rationale: /var/log should not contain special devices; ensuring nodev prevents their creation.

# Function to check if /var/log is a separate partition
is_separate_partition() {
    findmnt --target /var/log --noheadings | grep -q '^/var/log'
}

# Audit function to ensure nodev option is set on /var/log
audit_nodev_option() {
    local result
    result=$(findmnt -kn /var/log | grep -v nodev)

    if [ -z "$result" ]; then
        echo "Audit Passed: 'nodev' option is set on /var/log."
        exit 0
    else
        echo "Audit Failed: 'nodev' option is NOT set on /var/log."
        exit 1
    fi
}

# Main script execution
if is_separate_partition; then
    echo "/var/log is a separate partition."
    audit_nodev_option
else
    echo "/var/log is not a separate partition. Please ensure to manually verify and set 'nodev' if applicable."
    exit 1
fi

