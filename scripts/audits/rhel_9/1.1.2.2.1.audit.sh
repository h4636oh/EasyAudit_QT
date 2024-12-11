#!/bin/bash

# Script to audit if /dev/shm is mounted as a separate partition
# Exits with code 0 if the check passes, otherwise exits with 1

# Check if /home is mounted as a separate partition
output=$(findmnt -kn /dev/shm)


if echo "$output" | grep -q "^/dev/shm"; then
    echo "/home is mounted correctly as a separate partition."
    exit 0
else
    echo "Audit failed: /home is not mounted as a separate partition."
    echo "Please ensure that /home is configured as its own file system in /etc/fstab."
    exit 1
fi
