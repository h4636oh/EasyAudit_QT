#!/usr/bin/env bash

# Verify that /dev/shm is mounted with the correct options
mount_check=$(findmnt -kn /dev/shm)

expected_output="/dev/shm tmpfs tmpfs rw,nosuid,nodev,noexec,relatime,seclabel"

if [[ "$mount_check" == "$expected_output" ]]; then
    echo "OK: /dev/shm is mounted with the correct options."
else
    echo "Warning: /dev/shm is not mounted with the expected options:"
    echo "$mount_check"
    exit 1
fi

