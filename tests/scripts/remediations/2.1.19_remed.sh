#!/bin/bash

# Function to stop and mask the service
stop_and_mask_service() {
    echo "Stopping and masking xinetd.service..."
    systemctl stop xinetd.service
    systemctl mask xinetd.service
    echo "xinetd.service stopped and masked."
}

# Check if xinetd is installed
if dpkg-query -s xinetd &>/dev/null; then
    echo "xinetd is installed"
    echo "Stopping xinetd.service..."
    systemctl stop xinetd.service

    # Attempt to purge the xinetd package
    echo "Attempting to purge xinetd..."
    if apt purge -y xinetd; then
        echo "xinetd package purged successfully."
    else
        echo "Failed to purge xinetd package. It may be required by dependencies."
        stop_and_mask_service
    fi
else
    echo "xinetd is not installed."
fi

