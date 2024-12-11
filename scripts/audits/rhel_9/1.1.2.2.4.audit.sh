#!/bin/bash

# Script to audit whether the noexec option is set on /dev/shm partition.
# According to the description: "The noexec mount option specifies that the filesystem cannot contain executable binaries."
# Exit 0 if audit passes; exit 1 if audit fails.

# Check if /dev/shm is mounted with the noexec option
if findmnt -kn /dev/shm | grep -q 'noexec'; then
    echo "Pass: The noexec option is set on /dev/shm."
    exit 0
else
    echo "Fail: The noexec option is NOT set on /dev/shm."
    echo "Please manually edit the /etc/fstab to add the noexec option and remount /dev/shm."
    exit 1
fi

# This script checks if the `/dev/shm` partition is mounted with the `noexec` option as specified. If `noexec` is not set, it prompts the user to make manual changes to the `/etc/fstab` file and remount the partition. It adheres to the requirement for the script to audit without making changes automatically.