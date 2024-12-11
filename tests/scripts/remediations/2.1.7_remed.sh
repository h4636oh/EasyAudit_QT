#!/bin/bash

# Function to stop and mask service
stop_and_mask_service() {
    echo "Stopping and masking slapd.service..."
    systemctl stop slapd.service
    systemctl mask slapd.service
    echo "slapd.service stopped and masked."
}

# Check if slapd is installed
if dpkg-query -s slapd &>/dev/null; then
    echo "slapd is installed"
    echo "Stopping slapd.service..."
    systemctl stop slapd.service

    # Attempt to purge the slapd package
    echo "Attempting to purge slapd..."
    if apt purge -y slapd; then
        echo "slapd package purged successfully."
    else
        echo "Failed to purge slapd package. It may be required by dependencies."
        stop_and_mask_service
    fi
else
    echo "slapd is not installed."
fi

