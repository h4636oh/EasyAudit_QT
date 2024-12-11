#!/bin/bash

# Check if nfs-kernel-server is installed
if dpkg-query -s nfs-kernel-server &>/dev/null; then
    echo "nfs-kernel-server is installed"
    
    # Check if nfs-server.service is enabled
    if systemctl is-enabled nfs-server.service 2>/dev/null | grep 'enabled'; then
        echo "nfs-server.service is enabled"
        exit 1
    else
        echo "nfs-server.service is not enabled"
    fi

    # Check if nfs-server.service is active
    if systemctl is-active nfs-server.service 2>/dev/null | grep '^active'; then
        echo "nfs-server.service is active"
        exit 1
    else
        echo "nfs-server.service is not active"
    fi
else
    echo "nfs-kernel-server is not installed"
fi

