#!/bin/bash

# Function to stop and mask services
stop_and_mask_services() {
    echo "Stopping and masking apache2.socket, apache2.service, and nginx.service..."
    systemctl stop apache2.socket apache2.service nginx.service
    systemctl mask apache2.socket apache2.service nginx.service
    echo "apache2.socket, apache2.service, and nginx.service stopped and masked."
}

# Check if apache2 or nginx are installed
if dpkg-query -s apache2 &>/dev/null || dpkg-query -s nginx &>/dev/null; then
    echo "apache2 or nginx is installed"
    echo "Stopping apache2.socket, apache2.service, and nginx.service..."
    systemctl stop apache2.socket apache2.service nginx.service

    # Attempt to purge the apache2 and nginx packages
    echo "Attempting to purge apache2 and nginx..."
    if apt purge -y apache2 nginx; then
        echo "apache2 and nginx packages purged successfully."
    else
        echo "Failed to purge apache2 and/or nginx packages. They may be required by dependencies."
        stop_and_mask_services
    fi
else
    echo "Neither apache2 nor nginx are installed."
fi

