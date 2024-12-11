#!/usr/bin/env bash

# Check if /tmp is a separate partition
tmp_partition=$(findmnt -kn /tmp)

if [[ -n "$tmp_partition" ]]; then
    # Add nosuid to the fourth field in /etc/fstab for /tmp partition
    echo "Editing /etc/fstab to add nosuid option for /tmp partition..."
    sudo sed -i 's|\(/tmp.*defaults.*\)|\1,nosuid|' /etc/fstab

    # Remount /tmp with the configured options
    echo "Remounting /tmp with the configured options..."
    sudo mount -o remount /tmp

    echo "The /tmp partition has been remounted with the nosuid option."
else
    echo "No separate partition found for /tmp."
fi

