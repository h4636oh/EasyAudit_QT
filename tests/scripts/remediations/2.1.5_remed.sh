#!/bin/bash

# Function to stop and mask service
stop_and_mask_service() {
    echo "Stopping and masking dnsmasq.service..."
    systemctl stop dnsmasq.service
    systemctl mask dnsmasq.service
    echo "dnsmasq.service stopped and masked."
}

# Check if dnsmasq is installed
if dpkg-query -s dnsmasq &>/dev/null; then
    echo "dnsmasq is installed"
    echo "Stopping dnsmasq.service..."
    systemctl stop dnsmasq.service

    # Attempt to purge the dnsmasq package
    echo "Attempting to purge dnsmasq..."
    if apt purge -y dnsmasq; then
        echo "dnsmasq package purged successfully."
    else
        echo "Failed to purge dnsmasq package. It may be required by dependencies."
        stop_and_mask_service
    fi
else
    echo "dnsmasq is not installed."
fi

