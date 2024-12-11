#!/usr/bin/env bash

# Verify that the noexec mount option is set for /dev/shm if it exists as a separate partition
mount_check=$(findmnt -kn /dev/shm | grep -v 'noexec')

if [[ -z "$mount_check" ]]; then
    echo "OK: The noexec mount option is set for /dev/shm."
else
    echo "Warning: The noexec mount option is not set for /dev/shm."
    echo "$mount_check"
    exit 1
fi

