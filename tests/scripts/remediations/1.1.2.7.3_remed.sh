#!/usr/bin/env bash

# Check if /var/log/audit is a separate partition
var_log_audit_partition=$(findmnt -kn /var/log/audit)

if [[ -n "$var_log_audit_partition" ]]; then
    # Add nosuid to the fourth field in /etc/fstab for /var/log/audit partition
    echo "Editing /etc/fstab to add nosuid option for /var/log/audit partition..."
    sudo sed -i 's|\(/var/log/audit.*defaults.*\)|\1,nosuid|' /etc/fstab

    # Remount /var/log/audit with the configured options
    echo "Remounting /var/log/audit with the configured options..."
    sudo mount -o remount /var/log/audit

    echo "The /var/log/audit partition has been remounted with the nosuid option."
else
    echo "No separate partition found for /var/log/audit."
fi

