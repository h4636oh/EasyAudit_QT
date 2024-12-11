#!/bin/bash

# Define expected values
expected_permissions="0600"
expected_uid="0"
expected_gid="0"

# Get current file stats
file_stats=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /boot/grub/grub.cfg)

# Parse the stats
current_permissions=$(echo "$file_stats" | awk '{print $2}' | tr -d '()')
current_uid=$(echo "$file_stats" | awk '{print $4}' | tr -d '()')
current_gid=$(echo "$file_stats" | awk '{print $6}' | tr -d '()')

# Verify the values
if [[ "$current_permissions" == "$expected_permissions" && "$current_uid" == "$expected_uid" && "$current_gid" == "$expected_gid" ]]; then
    echo "File permissions, UID, and GID are correctly set."
else
    echo "File permissions, UID, or GID are incorrect."
    echo "Current values: Permissions: $current_permissions, UID: $current_uid, GID: $current_gid"
    exit 1
fi

