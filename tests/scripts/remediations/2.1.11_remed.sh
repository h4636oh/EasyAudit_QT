#!/bin/bash

# Function to stop and mask services
stop_and_mask_services() {
    echo "Stopping and masking cups.socket and cups.service..."
    systemctl stop cups.socket cups.service
    systemctl mask cups.socket cups.service
    echo "cups.socket and cups.service stopped and masked."
}

# Check if cups is installed
if dpkg-query -s cups &>/dev/null; then
    echo "cups is installed"
    echo "Stopping cups.socket and cups.service..."
    systemctl stop cups.socket cups.service

    # Attempt to purge the cups package
    echo "Attempting to purge cups..."
    if apt purge -y cups; then
        echo "cups package purged successfully."
    else
        echo "Failed to purge cups package. It may be required by dependencies."
        stop_and_mask_services
    fi
else
    echo "cups is not installed."
fi

