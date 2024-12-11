#!/usr/bin/env bash

# Verify that the nodev mount option is set for /var/tmp if it exists as a separate partition
mount_check=$(findmnt -kn /var/tmp | grep -v 'nodev')

if [[ -z "$mount_check" ]]; then
    echo "OK: The nodev mount option is set for /var/tmp."
else
    echo "Warning: The nodev mount option is not set for /var/tmp."
    echo "$mount_check"
    exit 1
fi

