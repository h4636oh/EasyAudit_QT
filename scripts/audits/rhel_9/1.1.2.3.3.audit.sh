#!/bin/bash

# This script audits the /home partition to ensure the nosuid option is set.
# It checks if a separate partition exists for /home and verifies the nosuid option.

# Function to check if /home is a separate partition with nosuid option.
audit_nosuid_option() {
    if findmnt -kn /home &>/dev/null; then
        # /home is a separate partition, check if nosuid is set
        if findmnt -kn /home | grep -v "nosuid" &>/dev/null; then
            echo "Audit failed: The nosuid option is not set on the /home partition."
            exit 1
        else
            echo "Audit passed: The nosuid option is correctly set on the /home partition."
            exit 0
        fi
    else
        echo "/home is not a separate partition, manual verification required."
        echo "Please ensure that if /home becomes a separate partition, the nosuid option is configured."
        exit 1
    fi
}

# Call the audit function
audit_nosuid_option
