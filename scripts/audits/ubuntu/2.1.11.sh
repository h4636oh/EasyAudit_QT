#!/bin/bash

# Check if cups is installed
if dpkg-query -s cups &>/dev/null; then
    echo "cups is installed"
    
    # Check if cups.socket and cups.service are enabled
    enabled_services=$(systemctl is-enabled cups.socket cups.service 2>/dev/null | grep 'enabled')
    if [ -n "$enabled_services" ]; then
        echo "cups.socket or cups.service is enabled:"
        echo "$enabled_services"
        exit 1
    else
        echo "cups.socket and cups.service are not enabled"
    fi

    # Check if cups.socket and cups.service are active
    active_services=$(systemctl is-active cups.socket cups.service 2>/dev/null | grep '^active')
    if [ -n "$active_services" ]; then
        echo "cups.socket or cups.service is active:"
        echo "$active_services"
        exit 1
    else
        echo "cups.socket and cups.service are not active"
    fi
else
    echo "cups is not installed"
fi

