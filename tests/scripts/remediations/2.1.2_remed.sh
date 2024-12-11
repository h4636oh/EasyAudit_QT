#!/bin/bash

# Function to stop and mask services
stop_and_mask_services() {
    echo "Stopping and masking avahi-daemon.socket and avahi-daemon.service..."
    systemctl stop avahi-daemon.socket avahi-daemon.service
    systemctl mask avahi-daemon.socket avahi-daemon.service
    echo "Services stopped and masked."
}

# Check if avahi-daemon is installed
if dpkg-query -s avahi-daemon &>/dev/null; then
    echo "avahi-daemon is installed"
    echo "Stopping avahi-daemon.socket and avahi-daemon.service..."
    systemctl stop avahi-daemon.socket avahi-daemon.service

    # Attempt to purge the avahi-daemon package
    echo "Attempting to purge avahi-daemon..."
    if apt purge -y avahi-daemon; then
        echo "avahi-daemon package purged successfully."
    else
        echo "Failed to purge avahi-daemon package. It may be required by dependencies."
        stop_and_mask_services
    fi
else
    echo "avahi-daemon is not installed."
fi

