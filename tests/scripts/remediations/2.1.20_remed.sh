#!/bin/bash

# Check if xserver-common is installed
if dpkg-query -s xserver-common &>/dev/null; then
    echo "xserver-common is installed"
    echo "Removing xserver-common package..."
    apt purge -y xserver-common
    echo "xserver-common package removed successfully."
else
    echo "xserver-common is not installed."
fi

