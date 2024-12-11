#!/usr/bin/env bash

# Verify that the nodev mount option is set for /var if it exists as a separate partition
mount_check=$(findmnt -kn /var | grep -v 'nodev')

if [[ -z "$mount_check" ]]; then
    echo "OK: The nodev mount option is set for /var."
else
    echo "Warning: The nodev mount option is not set for /var."
    echo "$mount_check"
    exit 1
fi

