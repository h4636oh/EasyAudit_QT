#!/bin/bash

# Function to stop and mask service
stop_and_mask_service() {
    echo "Stopping and masking bind9.service..."
    systemctl stop bind9.service
    systemctl mask bind9.service
    echo "bind9.service stopped and masked."
}

# Check if bind9 is installed
if dpkg-query -s bind9 &>/dev/null; then
    echo "bind9 is installed"
    echo "Stopping bind9.service..."
    systemctl stop bind9.service

    # Attempt to purge the bind9 package
    echo "Attempting to purge bind9..."
    if apt purge -y bind9; then
        echo "bind9 package purged successfully."
    else
        echo "Failed to purge bind9 package. It may be required by dependencies."
        stop_and_mask_service
    fi
else
    echo "bind9 is not installed."
fi

