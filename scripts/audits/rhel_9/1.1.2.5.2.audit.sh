#!/bin/bash

# Description:
# This script audits the /var/tmp filesystem to ensure that the nodev mount option is set.
# It is intended for automated checks on servers and workstations with separate /var/tmp partitions.
# Script will exit 0 if the audit passes and 1 if it fails.

# Check if a separate partition exists for /var/tmp
partition_exists=$(findmnt -k -n -o TARGET | grep -w "/var/tmp")

if [ -z "$partition_exists" ]; then
    echo "No separate partition exists for /var/tmp. Manual check might be required."
    exit 1
fi

# Verify that the nodev option is set for the /var/tmp partition
nodev_option_set=$(findmnt -kn /var/tmp | grep -v nodev)

if [ -n "$nodev_option_set" ]; then
    echo "Audit Failed: The nodev option is NOT set on the /var/tmp partition."
    echo "Please edit the /etc/fstab file to include 'nodev' for the /var/tmp partition, and remount it."
    exit 1
else
    echo "Audit Passed: The nodev option is set on the /var/tmp partition."
    exit 0
fi

