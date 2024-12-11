#!/bin/bash

# This script audits the presence and status of the autofs package and service.
# It checks if the autofs package is installed and if the autofs service is enabled or active.
# Note: It does not perform any remediation steps.

# Check if the autofs package is installed
if rpm -q autofs &> /dev/null; then
    echo "autofs package is installed."

    # Since the package is installed, check if the service is enabled
    if systemctl is-enabled autofs.service 2>/dev/null | grep -q 'enabled'; then
        echo "autofs.service is enabled. Manual review required."
        exit 1
    fi

    # Check if the service is active
    if systemctl is-active autofs.service 2>/dev/null | grep -q '^active'; then
        echo "autofs.service is active. Manual review required."
        exit 1
    fi

    echo "autofs package is installed but service is not enabled nor active. Ensure this meets local site policy."
    exit 0
else
    echo "autofs package is not installed."
    exit 0
fi
