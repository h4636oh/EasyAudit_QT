#!/bin/bash

# Check if avahi-daemon is installed
if dpkg-query -s avahi-daemon &>/dev/null; then
    echo "avahi-daemon is installed"
    
    # Check if avahi-daemon.socket and avahi-daemon.service are enabled
    enabled_services=$(systemctl is-enabled avahi-daemon.socket avahi-daemon.service 2>/dev/null | grep 'enabled')
    if [ -n "$enabled_services" ]; then
        echo "avahi-daemon.socket or avahi-daemon.service is enabled:"
        echo "$enabled_services"
        exit 1
    else
        echo "avahi-daemon.socket and avahi-daemon.service are not enabled"
    fi

    # Check if avahi-daemon.socket and avahi-daemon.service are active
    active_services=$(systemctl is-active avahi-daemon.socket avahi-daemon.service 2>/dev/null | grep '^active')
    if [ -n "$active_services" ]; then
        echo "avahi-daemon.socket or avahi-daemon.service is active:"
        echo "$active_services"
        exit 1
    else
        echo "avahi-daemon.socket and avahi-daemon.service are not active"
    fi
else
    echo "avahi-daemon is not installed"
fi

