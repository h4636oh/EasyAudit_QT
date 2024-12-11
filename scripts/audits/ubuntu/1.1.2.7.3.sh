#!/usr/bin/env bash

# Verify that the nosuid mount option is set for /var/log/audit if it exists as a separate partition
mount_check=$(findmnt -kn /var/log/audit | grep -v 'nosuid')

if [[ -z "$mount_check" ]]; then
    echo "OK: The nosuid mount option is set for /var/log/audit."
else
    echo "Warning: The nosuid mount option is not set for /var/log/audit."
    echo "$mount_check"
    exit 1
fi

