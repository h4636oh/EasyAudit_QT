#!/bin/bash

# Check if ypserv is installed
if dpkg-query -s ypserv &>/dev/null; then
    echo "ypserv is installed"
    
    # Check if ypserv.service is enabled
    if systemctl is-enabled ypserv.service 2>/dev/null | grep 'enabled'; then
        echo "ypserv.service is enabled"
        exit 1
    else
        echo "ypserv.service is not enabled"
    fi

    # Check if ypserv.service is active
    if systemctl is-active ypserv.service 2>/dev/null | grep '^active'; then
        echo "ypserv.service is active"
        exit 1
    else
        echo "ypserv.service is not active"
    fi
else
    echo "ypserv is not installed"
fi

