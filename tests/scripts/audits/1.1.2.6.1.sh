#!/usr/bin/env bash

# Verify that /var/log is mounted with the correct options
mount_check=$(findmnt -kn /var/log)

expected_output="/var/log /dev/sdb ext4 rw,nosuid,nodev,noexec,relatime,seclabel"

if [[ "$mount_check" == "$expected_output" ]]; then
    echo "OK: /var/log is mounted with the correct options."
else
    echo "Warning: /var/log is not mounted with the expected options:"
    echo "$mount_check"
    exit 1
fi

