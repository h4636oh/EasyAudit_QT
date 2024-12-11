#!/usr/bin/env bash

# Verify that /home is mounted with the correct options
mount_check=$(findmnt -kn /home)

expected_output="/home /dev/sdb ext4 rw,nosuid,nodev,noexec,relatime,seclabel"

if [[ "$mount_check" == "$expected_output" ]]; then
    echo "OK: /home is mounted with the correct options."
else
    echo "Warning: /home is not mounted with the expected options:"
    echo "$mount_check"
    exit 1
fi

