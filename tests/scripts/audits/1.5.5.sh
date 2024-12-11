#!/bin/bash

# Check if Apport is installed
if dpkg-query -s apport &> /dev/null; then
    echo "Apport is installed"

    # Check if Apport is enabled
    if grep -q '^enabled\h*=\h*[1]\b' /etc/default/apport; then
        echo "Apport is enabled"
        exit 1
    else
        echo "Apport is not enabled"
    fi

    # Check if Apport service is active
    if systemctl is-active apport.service; then
        echo "Apport service is active"
        exit 1
    else
        echo "Apport service is not active"
    fi
else
    echo "Apport is not installed"
fi
