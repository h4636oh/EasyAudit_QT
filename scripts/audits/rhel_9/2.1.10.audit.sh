#!/bin/bash

# This script audits the presence and status of the ypserv package and service
# It does not modify or remove anything, complying with auditing-only requirements.

# Check if ypserv package is installed
if rpm -q ypserv &>/dev/null; then
    echo "ypserv package is installed."
    # Check if the ypserv.service is enabled
    if systemctl is-enabled ypserv.service 2>/dev/null | grep -q 'enabled'; then
        echo "ypserv.service is enabled."
        echo "Audit result: FAIL"
        exit 1
    fi
    
    # Check if the ypserv.service is active
    if systemctl is-active ypserv.service 2>/dev/null | grep -q '^active'; then
        echo "ypserv.service is active."
        echo "Audit result: FAIL"
        exit 1
    fi
    
    echo "ypserv package is installed but service is masked or not running."
    echo "Please ensure the dependent package is approved by local site policy."
    echo "Ensure stopping and masking the service and/or socket meets local site policy."
else
    echo "ypserv package is not installed."
fi

# If we reached here, the audit passed
echo "Audit result: PASS"
exit 0