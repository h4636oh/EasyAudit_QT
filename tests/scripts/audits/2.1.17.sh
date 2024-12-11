#!/bin/bash

# Check if squid is installed
if dpkg-query -s squid &>/dev/null; then
    echo "squid is installed"
    
    # Check if squid.service is enabled
    if systemctl is-enabled squid.service 2>/dev/null | grep 'enabled'; then
        echo "squid.service is enabled"
        exit 1
    else
        echo "squid.service is not enabled"
    fi

    # Check if squid.service is active
    if systemctl is-active squid.service 2>/dev/null | grep '^active'; then
        echo "squid.service is active"
        exit 1
    else
        echo "squid.service is not active"
    fi
else
    echo "squid is not installed"
fi

