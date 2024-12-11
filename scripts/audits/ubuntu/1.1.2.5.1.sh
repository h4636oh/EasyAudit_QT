#!/usr/bin/env bash

# Verify that /var/tmp is mounted with the correct options
mount_check=$(findmnt -kn /var/tmp)

expected_output="/var/tmp /dev/sdb ext4 rw,nosuid,nodev,noexec,relatime,seclabel"

if [[ "$mount_check" == "$expected_output" ]]; then
    echo "OK: /var/tmp is mounted with the correct options."
else
    echo "Warning: /var/tmp is not mounted with the expected options:"
    echo "$mount_check"
i   exit 1
fi

