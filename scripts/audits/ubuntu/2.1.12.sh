#!/bin/bash

# Check if rpcbind is installed
if dpkg-query -s rpcbind &>/dev/null; then
    echo "rpcbind is installed"
    
    # Check if rpcbind.socket and rpcbind.service are enabled
    enabled_services=$(systemctl is-enabled rpcbind.socket rpcbind.service 2>/dev/null | grep 'enabled')
    if [ -n "$enabled_services" ]; then
        echo "rpcbind.socket or rpcbind.service is enabled:"
        echo "$enabled_services"
        exit 1
    else
        echo "rpcbind.socket and rpcbind.service are not enabled"
    fi

    # Check if rpcbind.socket and rpcbind.service are active
    active_services=$(systemctl is-active rpcbind.socket rpcbind.service 2>/dev/null | grep '^active')
    if [ -n "$active_services" ]; then
        echo "rpcbind.socket or rpcbind.service is active:"
        echo "$active_services"
        exit 1
    else
        echo "rpcbind.socket and rpcbind.service are not active"
    fi
else
    echo "rpcbind is not installed"
fi

