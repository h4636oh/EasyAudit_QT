#!/bin/bash

# This script audits the CUPS service based on the specified requirements.
# It checks whether the CUPS package is installed and if the cups.socket and cups.service are disabled and inactive.

# Check if the CUPS package is installed.
if rpm -q cups &> /dev/null; then
    echo "The CUPS package is installed."

    # If the package is installed, check if the service and socket are enabled.
    if systemctl is-enabled cups.socket cups.service &> /dev/null; then
        echo "The cups.socket or cups.service is enabled. Please disable and mask these if CUPS is not needed."
        exit 1
    fi

    # Check if the service and socket are active.
    if systemctl is-active cups.socket cups.service &> /dev/null; then
        echo "The cups.socket or cups.service is active. Please ensure they are inactive if CUPS is not needed."
        exit 1
    fi
else
    echo "The CUPS package is not installed."
fi

# Manual check prompt for ensuring dependent packages are approved and that stopping and masking services meet local policy.
echo "Please ensure that if CUPS is a dependency, the dependent packages are approved by local site policy."
echo "Also, ensure that stopping and masking the service and/or socket meets local site policy."

exit 0