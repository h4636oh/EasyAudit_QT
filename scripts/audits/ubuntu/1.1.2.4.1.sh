#!/usr/bin/env bash

# Verify that /var is mounted with the correct options
mount_check=$(findmnt -kn /var)

expected_output="/var /dev/sdb ext4 rw,nosuid,nodev,noexec,relatime,seclabel"

if [[ "$mount_check" == "$expected_output" ]]; then
    echo "OK: /var is mounted with the correct options."
else
    echo "Warning: /var is not mounted with the expected options:"
    echo "$mount_check"
    exit 1
fi

