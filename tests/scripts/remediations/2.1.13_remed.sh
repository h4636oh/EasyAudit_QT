#!/bin/bash

# Function to stop and mask service
stop_and_mask_service() {
    echo "Stopping and masking rsync.service..."
    systemctl stop rsync.service
    systemctl mask rsync.service
    echo "rsync.service stopped and masked."
}

# Check if rsync is installed
if dpkg-query -s rsync &>/dev/null; then
    echo "rsync is installed"
    echo "Stopping rsync.service..."
    systemctl stop rsync.service

    # Attempt to purge the rsync package
    echo "Attempting to purge rsync..."
    if apt purge -y rsync; then
        echo "rsync package purged successfully."
    else
        echo "Failed to purge rsync package. It may be required by dependencies."
        stop_and_mask_service
    fi
else
    echo "rsync is not installed."
fi

