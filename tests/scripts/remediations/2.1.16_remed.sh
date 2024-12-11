#!/bin/bash

# Function to stop and mask service
stop_and_mask_service() {
    echo "Stopping and masking tftpd-hpa.service..."
    systemctl stop tftpd-hpa.service
    systemctl mask tftpd-hpa.service
    echo "tftpd-hpa.service stopped and masked."
}

# Check if tftpd-hpa is installed
if dpkg-query -s tftpd-hpa &>/dev/null; then
    echo "tftpd-hpa is installed"
    echo "Stopping tftpd-hpa.service..."
    systemctl stop tftpd-hpa.service

    # Attempt to purge the tftpd-hpa package
    echo "Attempting to purge tftpd-hpa..."
    if apt purge -y tftpd-hpa; then
        echo "tftpd-hpa package purged successfully."
    else
        echo "Failed to purge tftpd-hpa package. It may be required by dependencies."
        stop_and_mask_service
    fi
else
    echo "tftpd-hpa is not installed."
fi

