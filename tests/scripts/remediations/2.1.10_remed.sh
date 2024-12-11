#!/bin/bash

# Function to stop and mask service
stop_and_mask_service() {
    echo "Stopping and masking ypserv.service..."
    systemctl stop ypserv.service
    systemctl mask ypserv.service
    echo "ypserv.service stopped and masked."
}

# Check if ypserv is installed
if dpkg-query -s ypserv &>/dev/null; then
    echo "ypserv is installed"
    echo "Stopping ypserv.service..."
    systemctl stop ypserv.service

    # Attempt to purge the ypserv package
    echo "Attempting to purge ypserv..."
    if apt purge -y ypserv; then
        echo "ypserv package purged successfully."
    else
        echo "Failed to purge ypserv package. It may be required by dependencies."
        stop_and_mask_service
    fi
else
    echo "ypserv is not installed."
fi

