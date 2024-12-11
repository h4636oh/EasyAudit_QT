#!/usr/bin/env bash

# Check if /dev/shm is a separate partition
shm_partition=$(findmnt -kn /dev/shm)

if [[ -n "$shm_partition" ]]; then
    # Add nosuid to the fourth field in /etc/fstab for /dev/shm partition
    echo "Editing /etc/fstab to add nosuid option for /dev/shm partition..."
    sudo sed -i 's|\(/dev/shm.*defaults.*\)|\1,nosuid|' /etc/fstab

    # Remount /dev/shm with the configured options
    echo "Remounting /dev/shm with the configured options..."
    sudo mount -o remount /dev/shm

    echo "The /dev/shm partition has been remounted with the nosuid option."
else
    echo "No separate partition found for /dev/shm."
fi

