#!/usr/bin/env bash

# Verify that the nodev mount option is set for /tmp if it exists as a separate partition
mount_check=$(findmnt -kn /tmp | grep -v nodev)

if [[ -z "$mount_check" ]]; then
    echo "OK: The nodev mount option is set for /tmp."
else
    echo "Warning: The nodev mount option is not set for /tmp."
    echo "$mount_check"
    exit 1
fi

