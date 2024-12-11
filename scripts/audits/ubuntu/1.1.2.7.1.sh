#!/usr/bin/env bash

# Verify that /var/log/audit is mounted with the correct options
mount_check=$(findmnt -kn /var/log/audit)

expected_output="/var/log/audit /dev/sdb ext4 rw,nosuid,nodev,noexec,relatime,seclabel"

if [[ "$mount_check" == "$expected_output" ]]; then
    echo "OK: /var/log/audit is mounted with the correct options."
else
    echo "Warning: /var/log/audit is not mounted with the expected options:"
    echo "$mount_check"
    exit 1
fi

