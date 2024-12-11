#!/usr/bin/env bash

# Verify that the nodev mount option is set for /dev/shm if it exists as a separate partition
mount_check=$(findmnt -kn /dev/shm | grep -v 'nodev')

if [[ -z "$mount_check" ]]; then
    echo "OK: The nodev mount option is set for /dev/shm."
else
    echo "Warning: The nodev mount option is not set for /dev/shm."
    echo "$mount_check"
    exit 1
fi

