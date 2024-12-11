#!/usr/bin/env bash

# Verify that the noexec mount option is set for /var/tmp if it exists as a separate partition
mount_check=$(findmnt -kn /var/tmp | grep -v 'noexec')

if [[ -z "$mount_check" ]]; then
    echo "OK: The noexec mount option is set for /var/tmp."
else
    echo "Warning: The noexec mount option is not set for /var/tmp."
    echo "$mount_check"
    exit 1
fi

