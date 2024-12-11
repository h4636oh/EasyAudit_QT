#!/usr/bin/env bash

# Verify that the nodev mount option is set for /var/log if it exists as a separate partition
mount_check=$(findmnt -kn /var/log | grep -v 'nodev')

if [[ -z "$mount_check" ]]; then
    echo "OK: The nodev mount option is set for /var/log."
else
    echo "Warning: The nodev mount option is not set for /var/log."
    echo "$mount_check"
    exit 1
fi

