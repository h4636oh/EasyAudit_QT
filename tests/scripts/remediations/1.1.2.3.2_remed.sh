#!/usr/bin/env bash

# Check if /home is a separate partition
home_partition=$(findmnt -kn /home)

if [[ -n "$home_partition" ]]; then
    # Add nodev to the fourth field in /etc/fstab for /home partition
    echo "Editing /etc/fstab to add nodev option for /home partition..."
    sudo sed -i 's|\(/home.*defaults.*\)|\1,nodev|' /etc/fstab

    # Remount /home with the configured options
    echo "Remounting /home with the configured options..."
    sudo mount -o remount /home

    echo "The /home partition has been remounted with the nodev option."
else
    echo "No separate partition found for /home."
fi

