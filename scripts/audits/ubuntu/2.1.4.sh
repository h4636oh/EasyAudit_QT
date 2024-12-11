#!/bin/bash

# Check if bind9 is installed
if dpkg-query -s bind9 &>/dev/null; then
    echo "bind9 is installed"
    
    # Check if bind9.service is enabled
    enabled_service=$(systemctl is-enabled bind9.service 2>/dev/null | grep 'enabled')
    if [ -n "$enabled_service" ]; then
        echo "bind9.service is enabled"
        exit 1
    else
        echo "bind9.service is not enabled"
    fi

    # Check if bind9.service is active
    active_service=$(systemctl is-active bind9.service 2>/dev/null | grep '^active')
    if [ -n "$active_service" ]; then
        echo "bind9.service is active"
        exit 1
    else
        echo "bind9.service is not active"
    fi
else
    echo "bind9 is not installed"
fi

