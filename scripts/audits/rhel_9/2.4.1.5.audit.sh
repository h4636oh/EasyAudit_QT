#!/bin/bash

# This script audits the permissions and ownership of the /etc/cron.weekly directory.
# It ensures that the directory is owned by root and has the appropriate permissions.

# Check if cron is installed
if ! command -v cron &> /dev/null; then
    echo "cron is not installed on this system."
    exit 0
fi

# Capture the output of the stat command for /etc/cron.weekly
dir_status=$(stat -Lc 'Access: (%a/%A) Uid: (%u/%U) Gid: (%g/%G)' /etc/cron.weekly)

# Desired permissions and ownership
required_access="700"
required_uid="0"
required_gid="0"

# Extract actual permissions and ownership values
actual_access=$(echo "$dir_status" | awk -F'[()]' '{print $2 + 0}')
actual_uid=$(echo "$dir_status" | awk -F'[()]' '{print $4 + 0}')
actual_gid=$(echo "$dir_status" | awk -F'[()]' '{print $6 + 0}')

# Audit check
if [ "$actual_access" == "$required_access" ] && [ "$actual_uid" == "$required_uid" ] && [ "$actual_gid" == "$required_gid" ]; then
    echo "Audit passed: /etc/cron.weekly has the correct permissions and ownership."
    exit 0
else
    echo "Audit failed: /etc/cron.weekly does not have the correct permissions or ownership."
    echo "Current settings: Access: $actual_access, Uid: $actual_uid, Gid: $actual_gid"
    echo "Please manually set ownership to root:root and permissions to 700 using the following commands:"
    echo "sudo chown root:root /etc/cron.weekly/"
    echo "sudo chmod 700 /etc/cron.weekly/"
    exit 1
fi
