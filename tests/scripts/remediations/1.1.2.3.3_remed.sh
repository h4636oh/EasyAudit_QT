#!/usr/bin/env bash

# Check if /home is a separate partition
home_partition=$(findmnt -kn /home)

if [[ -n "$home_partition" ]]; then
    # Add nosuid to the fourth field in /etc/fstab for /home partition
    echo "Editing /etc/fstab to add nosuid option for /home partition..."
    sudo sed -i 's|\(/home.*defaults.*\)|\1,nosuid|' /etc/fstab

    # Remount /home with the configured options
    echo "Remounting /home with the configured options..."
    sudo mount -o remount /home

    echo "The /home partition has been remounted with the nosuid option."
else
    echo "No separate partition found for /home."
fi

