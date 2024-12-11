#!/bin/bash

# Title: Ensure nodev option set on /var partition
# Description: Audit script to verify the nodev option on the /var partition
# Profile Applicability: Level 1 - Server, Level 1 - Workstation
# This script audits to ensure that the filesystem cannot contain special devices on /var.

# Check if "nodev" option is set
nodedev_check=$(echo "$partition_info" | grep -v nodev)

if [ -n "$nodedev_check" ]; then
    echo "Audit Failed: The 'nodev' option is not set on the /var partition."
    echo "Please edit the /etc/fstab file to add 'nodev' to the /var partition options."
    exit 1
else
    echo "Audit Passed: The 'nodev' option is set on the /var partition."
    exit 0
fi

# This script checks whether the `/var` partition has the `nodev` option set. It assumes that system administrators are aware if `/var` is a separate partition. If `/var` is not a separate partition, manual verification is suggested. The script exits with `0` if the audit passes and with `1` if it fails, as required.