#!/bin/bash

# Function to stop and mask services
stop_and_mask_services() {
    echo "Stopping and masking isc-dhcp-server.service and isc-dhcp-server6.service..."
    systemctl stop isc-dhcp-server.service isc-dhcp-server6.service
    systemctl mask isc-dhcp-server.service isc-dhcp-server6.service
    echo "Services stopped and masked."
}

# Check if isc-dhcp-server is installed
if dpkg-query -s isc-dhcp-server &>/dev/null; then
    echo "isc-dhcp-server is installed"
    echo "Stopping isc-dhcp-server.service and isc-dhcp-server6.service..."
    systemctl stop isc-dhcp-server.service isc-dhcp-server6.service

    # Attempt to purge the isc-dhcp-server package
    echo "Attempting to purge isc-dhcp-server..."
    if apt purge -y isc-dhcp-server; then
        echo "isc-dhcp-server package purged successfully."
    else
        echo "Failed to purge isc-dhcp-server package. It may be required by dependencies."
        stop_and_mask_services
    fi
else
    echo "isc-dhcp-server is not installed."
fi

