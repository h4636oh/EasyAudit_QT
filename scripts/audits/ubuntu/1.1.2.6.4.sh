#!/usr/bin/env bash

# Verify that the noexec mount option is set for /var/log if it exists as a separate partition
mount_check=$(findmnt -kn /var/log | grep -v 'noexec')

if [[ -z "$mount_check" ]]; then
    echo "OK: The noexec mount option is set for /var/log."
else
    echo "Warning: The noexec mount option is not set for /var/log."
    echo "$mount_check"
    exit 1
fi

