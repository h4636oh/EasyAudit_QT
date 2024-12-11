#!/usr/bin/env bash

# Check if /var is a separate partition
var_partition=$(findmnt -kn /var)

if [[ -n "$var_partition" ]]; then
    # Add nodev to the fourth field in /etc/fstab for /var partition
    echo "Editing /etc/fstab to add nodev option for /var partition..."
    sudo sed -i 's|\(/var.*defaults.*\)|\1,nodev|' /etc/fstab

    # Remount /var with the configured options
    echo "Remounting /var with the configured options..."
    sudo mount -o remount /var

    echo "The /var partition has been remounted with the nodev option."
else
    echo "No separate partition found for /var."
fi

