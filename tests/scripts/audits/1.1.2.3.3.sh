#!/usr/bin/env bash

# Verify that the nosuid mount option is set for /home if it exists as a separate partition
mount_check=$(findmnt -kn /home | grep -v nosuid)

if [[ -z "$mount_check" ]]; then
    echo "OK: The nosuid mount option is set for /home."
else
    echo "Warning: The nosuid mount option is not set for /home."
    echo "$mount_check"
    exit 1
fi

