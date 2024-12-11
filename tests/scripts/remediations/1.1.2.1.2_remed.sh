#!/usr/bin/env bash

# Check if /tmp is a separate partition
tmp_partition=$(findmnt -kn /tmp)

if [[ -n "$tmp_partition" ]]; then
    # Add nodev to the fourth field in /etc/fstab for /tmp partition
    echo "Editing /etc/fstab to add nodev option for /tmp partition..."
    sudo sed -i 's|\(/tmp.*defaults.*\)|\1,nodev|' /etc/fstab

    # Remount /tmp with the configured options
    echo "Remounting /tmp with the configured options..."
    sudo mount -o remount /tmp

    echo "The /tmp partition has been remounted with the nodev option."
else
    echo "No separate partition found for /tmp."
fi

