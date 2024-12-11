#!/bin/bash

# Function to stop and mask services
stop_and_mask_services() {
    echo "Stopping and masking rpcbind.socket and rpcbind.service..."
    systemctl stop rpcbind.socket rpcbind.service
    systemctl mask rpcbind.socket rpcbind.service
    echo "rpcbind.socket and rpcbind.service stopped and masked."
}

# Check if rpcbind is installed
if dpkg-query -s rpcbind &>/dev/null; then
    echo "rpcbind is installed"
    echo "Stopping rpcbind.socket and rpcbind.service..."
    systemctl stop rpcbind.socket rpcbind.service

    # Attempt to purge the rpcbind package
    echo "Attempting to purge rpcbind..."
    if apt purge -y rpcbind; then
        echo "rpcbind package purged successfully."
    else
        echo "Failed to purge rpcbind package. It may be required by dependencies."
        stop_and_mask_services
    fi
else
    echo "rpcbind is not installed."
fi

