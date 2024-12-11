#!/bin/bash

# Function to stop and mask service
stop_and_mask_service() {
    echo "Stopping and masking autofs.service..."
    systemctl stop autofs.service
    systemctl mask autofs.service
    echo "autofs.service stopped and masked."
}

# Check if autofs is installed
if dpkg-query -s autofs &>/dev/null; then
    echo "autofs is installed"
    echo "Stopping autofs.service..."
    systemctl stop autofs.service

    # Attempt to purge the autofs package
    echo "Attempting to purge autofs..."
    if apt purge -y autofs; then
        echo "autofs package purged successfully."
    else
        echo "Failed to purge autofs package. It may be required by dependencies."
        stop_and_mask_service
    fi
else
    echo "autofs is not installed."
fi

