#!/bin/bash

# Function to stop and mask service
stop_and_mask_service() {
    echo "Stopping and masking squid.service..."
    systemctl stop squid.service
    systemctl mask squid.service
    echo "squid.service stopped and masked."
}

# Check if squid is installed
if dpkg-query -s squid &>/dev/null; then
    echo "squid is installed"
    echo "Stopping squid.service..."
    systemctl stop squid.service

    # Attempt to purge the squid package
    echo "Attempting to purge squid..."
    if apt purge -y squid; then
        echo "squid package purged successfully."
    else
        echo "Failed to purge squid package. It may be required by dependencies."
        stop_and_mask_service
    fi
else
    echo "squid is not installed."
fi

