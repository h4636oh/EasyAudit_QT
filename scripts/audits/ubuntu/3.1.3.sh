#!/bin/bash

# Check if bluez package is installed
if dpkg-query -s bluez &>/dev/null; then
    echo "bluez is installed"
else
    echo "bluez is not installed"
fi

# Check if bluetooth.service is enabled
if systemctl is-enabled bluetooth.service 2>/dev/null | grep -q 'enabled'; then
    echo "bluetooth.service is enabled"
    exit 1
else
    echo "bluetooth.service is not enabled"
fi

# Check if bluetooth.service is active
if systemctl is-active bluetooth.service 2>/dev/null | grep -q '^active'; then
    echo "bluetooth.service is active"
    exit 1
else
    echo "bluetooth.service is not active"
fi

