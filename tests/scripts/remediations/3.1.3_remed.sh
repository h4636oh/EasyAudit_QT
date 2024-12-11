#!/bin/bash

# Stop bluetooth.service
systemctl stop bluetooth.service

# Check if bluez package is installed
if dpkg-query -s bluez &>/dev/null; then
    # Remove bluez package
    apt purge -y bluez
    echo "bluez package removed"
else
    echo "bluez package is not installed, skipping removal"
fi

# Check if bluez package is required as a dependency
if dpkg-query -s bluez &>/dev/null; then
    # Stop and mask bluetooth.service if bluez is required
    systemctl stop bluetooth.service
    systemctl mask bluetooth.service
    echo "bluetooth.service stopped and masked"
else
    echo "bluez is not required as a dependency, skipping stop and mask for bluetooth.service"
fi

