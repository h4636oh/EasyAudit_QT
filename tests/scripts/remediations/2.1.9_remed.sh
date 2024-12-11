#!/bin/bash

# Function to stop and mask service
stop_and_mask_service() {
    echo "Stopping and masking nfs-server.service..."
    systemctl stop nfs-server.service
    systemctl mask nfs-server.service
    echo "nfs-server.service stopped and masked."
}

# Check if nfs-kernel-server is installed
if dpkg-query -s nfs-kernel-server &>/dev/null; then
    echo "nfs-kernel-server is installed"
    echo "Stopping nfs-server.service..."
    systemctl stop nfs-server.service

    # Attempt to purge the nfs-kernel-server package
    echo "Attempting to purge nfs-kernel-server..."
    if apt purge -y nfs-kernel-server; then
        echo "nfs-kernel-server package purged successfully."
    else
        echo "Failed to purge nfs-kernel-server package. It may be required by dependencies."
        stop_and_mask_service
    fi
else
    echo "nfs-kernel-server is not installed."
fi

