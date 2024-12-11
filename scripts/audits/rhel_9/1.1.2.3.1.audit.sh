#!/bin/bash

# This script audits whether the /home directory is mounted on a separate partition.
# It checks the output of findmnt command and verifies if /home is mounted.

# Run the command to check the mount points
mount_details=$(findmnt -kn /home)

# Check if the output from findmnt indicates /home is mounted
if echo "$mount_details" | grep -q "^/home "; then
    echo "Audit Passed: /home is mounted on a separate partition."
    exit 0
else
    echo "Audit Failed: /home is not mounted on a separate partition."
    echo "Please ensure a separate partition for /home is configured."
    exit 1
fi

