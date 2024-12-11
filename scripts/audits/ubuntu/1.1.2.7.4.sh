#!/usr/bin/env bash

# Verify that the noexec mount option is set for /var/log/audit if it exists as a separate partition
mount_check=$(findmnt -kn /var/log/audit | grep -v 'noexec')

if [[ -z "$mount_check" ]]; then
    echo "OK: The noexec mount option is set for /var/log/audit."
else
    echo "Warning: The noexec mount option is not set for /var/log/audit."
    echo "$mount_check"
    exit 1
fi

