#!/usr/bin/env bash

# Verify that the noexec mount option is set for /tmp if it exists as a separate partition
mount_check=$(findmnt -kn /tmp | grep -v noexec)

if [[ -z "$mount_check" ]]; then
    echo "OK: The noexec mount option is set for /tmp."
else
    echo "Warning: The noexec mount option is not set for /tmp."
    echo "$mount_check"
    exit 1
fi

