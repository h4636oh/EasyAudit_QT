#!/bin/bash

# Script to audit permissions and ownership of /etc/cron.monthly directory

# Check if cron is installed
if ! command -v cron >/dev/null 2>&1; then
    echo "Cron is not installed on this system."
    exit 0
fi

# Get the file status of /etc/cron.monthly
file_status=$(stat -Lc 'Access: (%a/%A) Uid: (%u/%U) Gid: (%g/%G)' /etc/cron.monthly 2>/dev/null)

# Check if the directory exists and retrieve its current permissions and ownership
if [ -z "$file_status" ]; then
    echo "/etc/cron.monthly directory does not exist."
    exit 0  # Not applicable as no such directory exists
else
    # Parse the permissions and ownership from stat command
    permissions=$(echo "$file_status" | awk -F'[()]' '{print $2 + 0}')
    uid=$(echo "$file_status" | awk '{print $4}' | cut -d'/' -f1)
    gid=$(echo "$file_status" | awk '{print $6}' | cut -d'/' -f1)

    # Check for correct permissions and ownership
    if [ "$permissions" == "700" ] && [ "$uid" == "0" ] && [ "$gid" == "0" ]; then
        echo "Audit Passed: Correct permissions and ownership on /etc/cron.monthly."
        exit 0
    else
        echo "Audit Failed: Incorrect permissions or ownership on /etc/cron.monthly."
        echo "Permissions: $permissions, Uid: $uid, Gid: $gid"
        exit 1
    fi
fi
