#!/bin/bash

# Function to stop and mask service
stop_and_mask_service() {
    echo "Stopping and masking snmpd.service..."
    systemctl stop snmpd.service
    systemctl mask snmpd.service
    echo "snmpd.service stopped and masked."
}

# Check if snmpd is installed
if dpkg-query -s snmpd &>/dev/null; then
    echo "snmpd is installed"
    echo "Stopping snmpd.service..."
    systemctl stop snmpd.service

    # Attempt to purge the snmpd package
    echo "Attempting to purge snmpd..."
    if apt purge -y snmpd; then
        echo "snmpd package purged successfully."
    else
        echo "Failed to purge snmpd package. It may be required by dependencies."
        stop_and_mask_service
    fi
else
    echo "snmpd is not installed."
fi

