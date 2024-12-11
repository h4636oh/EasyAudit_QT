#!/bin/bash

# Check if xinetd is installed
if dpkg-query -s xinetd &>/dev/null; then
    echo "xinetd is installed"
    
    # Check if xinetd.service is enabled
    if systemctl is-enabled xinetd.service 2>/dev/null | grep 'enabled'; then
        echo "xinetd.service is enabled"
        exit 1
    else
        echo "xinetd.service is not enabled"
    fi

    # Check if xinetd.service is active
    if systemctl is-active xinetd.service 2>/dev/null | grep '^active'; then
        echo "xinetd.service is active"
        exit 1
    else
        echo "xinetd.service is not active"
    fi
else
    echo "xinetd is not installed"
fi

