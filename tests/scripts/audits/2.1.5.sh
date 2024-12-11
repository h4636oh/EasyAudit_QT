#!/bin/bash

# Check if dnsmasq is installed
if dpkg-query -s dnsmasq &>/dev/null; then
    echo "dnsmasq is installed"
    
    # Check if dnsmasq.service is enabled
    enabled_service=$(systemctl is-enabled dnsmasq.service 2>/dev/null | grep 'enabled')
    if [ -n "$enabled_service" ]; then
        echo "dnsmasq.service is enabled"
        exit 1
    else
        echo "dnsmasq.service is not enabled"
    fi

    # Check if dnsmasq.service is active
    active_service=$(systemctl is-active dnsmasq.service 2>/dev/null | grep '^active')
    if [ -n "$active_service" ]; then
        echo "dnsmasq.service is active"
        exit 1
    else
        echo "dnsmasq.service is not active"
    fi
else
    echo "dnsmasq is not installed"
fi

