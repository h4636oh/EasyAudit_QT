#!/usr/bin/env bash

# Verify that the nosuid mount option is set for /dev/shm if it exists as a separate partition
mount_check=$(findmnt -kn /dev/shm | grep -v 'nosuid')

if [[ -z "$mount_check" ]]; then
    echo "OK: The nosuid mount option is set for /dev/shm."
else
    echo "Warning: The nosuid mount option is not set for /dev/shm."
    echo "$mount_check"
    exit 1
fi

