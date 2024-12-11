#!/usr/bin/env bash

# Verify that the nosuid mount option is set for /var/log if it exists as a separate partition
mount_check=$(findmnt -kn /var/log | grep -v 'nosuid')

if [[ -z "$mount_check" ]]; then
    echo "OK: The nosuid mount option is set for /var/log."
else
    echo "Warning: The nosuid mount option is not set for /var/log."
    echo "$mount_check"
    exit 1
fi

