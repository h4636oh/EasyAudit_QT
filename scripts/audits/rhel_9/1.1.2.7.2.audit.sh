#!/bin/bash

# Audit Script for verifying the nodev mount option on /var/log/audit
# Exit 0: Audit passes (nodev option is set)
# Exit 1: Audit fails (nodev option is not set)

# Function to check if /var/log/audit is a separate partition
check_partition() {
    local partition_count
    partition_count=$(findmnt -knR /var/log/audit | grep -c '^')
    
    if [ "$partition_count" -eq 0 ]; then
        echo "No separate partition for /var/log/audit found."
        echo "Please ensure there is a separate partition for /var/log/audit and then run this script again."
        exit 1
    fi
}

# Check if nodev option is set for /var/log/audit
audit_nodev_option() {
    local nodev_check
    nodev_check=$(findmnt -kn /var/log/audit | grep -v nodev)

    if [ -n "$nodev_check" ]; then
        echo "/var/log/audit partition does not have the nodev option set."
        echo "Please add 'nodev' to the /etc/fstab entry for /var/log/audit."
        exit 1
    else
        echo "The nodev option is set on /var/log/audit partition."
        exit 0
    fi
}

# Main script execution
check_partition
audit_nodev_option