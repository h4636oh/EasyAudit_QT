#!/bin/bash

# Script to audit the access permissions of /etc/motd.
# This script checks if /etc/motd exists and compares its permissions to the specified requirements.
# It exits with 0 if the requirements are met, otherwise it exits with 1.

check_motd_permissions() {
    # Check if /etc/motd exists
    if [ -e /etc/motd ]; then
        # Fetch the current permissions, UID, and GID of /etc/motd
        permissions=$(stat -Lc '%a' /etc/motd)
        uid=$(stat -Lc '%u' /etc/motd)
        gid=$(stat -Lc '%g' /etc/motd)

        # Validate the permissions, UID, and GID
        if [[ "$permissions" -le 644 && "$uid" -eq 0 && "$gid" -eq 0 ]]; then
            echo "Audit passed: /etc/motd has acceptable permissions and ownership."
            exit 0
        else
            echo "Audit failed:"
            echo "- Permissions of /etc/motd: $permissions (expected: 644 or less restrictive)"
            echo "- UID of /etc/motd: $uid (expected: 0/root)"
            echo "- GID of /etc/motd: $gid (expected: 0/root)"
            exit 1
        fi
    else
        echo "Audit passed: /etc/motd does not exist."
        exit 0
    fi
}

# Run the audit function
check_motd_permissions