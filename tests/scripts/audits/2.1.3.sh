#!/bin/bash

# Check if isc-dhcp-server is installed
if dpkg-query -s isc-dhcp-server &>/dev/null; then
    echo "isc-dhcp-server is installed"
    
    # Check if isc-dhcp-server.service and isc-dhcp-server6.service are enabled
    enabled_services=$(systemctl is-enabled isc-dhcp-server.service isc-dhcp-server6.service 2>/dev/null | grep 'enabled')
    if [ -n "$enabled_services" ]; then
        echo "isc-dhcp-server.service or isc-dhcp-server6.service is enabled:"
        echo "$enabled_services"
        exit 1
    else
        echo "isc-dhcp-server.service and isc-dhcp-server6.service are not enabled"
    fi

    # Check if isc-dhcp-server.service and isc-dhcp-server6.service are active
    active_services=$(systemctl is-active isc-dhcp-server.service isc-dhcp-server6.service 2>/dev/null | grep '^active')
    if [ -n "$active_services" ]; then
        echo "isc-dhcp-server.service or isc-dhcp-server6.service is active:"
        echo "$active_services"
        exit 1
    else
        echo "isc-dhcp-server.service and isc-dhcp-server6.service are not active"
    fi
else
    echo "isc-dhcp-server is not installed"
fi

