#!/bin/bash

# Function to stop and mask the service
stop_and_mask_service() {
    echo "Stopping and masking smbd.service..."
    systemctl stop smbd.service
    systemctl mask smbd.service
    echo "smbd.service stopped and masked."
}

# Check if samba is installed
if dpkg-query -s samba &>/dev/null; then
    echo "samba is installed"
    echo "Stopping smbd.service..."
    systemctl stop smbd.service

    # Attempt to purge the samba package
    echo "Attempting to purge samba..."
    if apt purge -y samba; then
        echo "samba package purged successfully."
    else
        echo "Failed to purge samba package. It may be required by dependencies."
        stop_and_mask_service
    fi
else
    echo "samba is not installed."
fi

