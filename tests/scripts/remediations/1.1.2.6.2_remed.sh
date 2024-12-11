#!/usr/bin/env bash

# Check if /var/log is a separate partition
var_log_partition=$(findmnt -kn /var/log)

if [[ -n "$var_log_partition" ]]; then
    # Add nodev to the fourth field in /etc/fstab for /var/log partition
    echo "Editing /etc/fstab to add nodev option for /var/log partition..."
    sudo sed -i 's|\(/var/log.*defaults.*\)|\1,nodev|' /etc/fstab

    # Remount /var/log with the configured options
    echo "Remounting /var/log with the configured options..."
    sudo mount -o remount /var/log

    echo "The /var/log partition has been remounted with the nodev option."
else
    echo "No separate partition found for /var/log."
fi

