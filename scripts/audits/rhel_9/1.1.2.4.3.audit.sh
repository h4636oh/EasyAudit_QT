#!/bin/bash

# This script audits if the /var partition is mounted with the nosuid option.
# It must not perform any remediation.

# Function to check if nosuid option is set for /var
audit_nosuid_var() {
    # Use findmnt to verify if /var has the nosuid option set
    if findmnt -kn /var | grep -v nosuid &> /dev/null; then
        echo "Audit Failed: /var is NOT mounted with nosuid option."
        return 1
    else
        echo "Audit Passed: /var is mounted with nosuid option."
        return 0
    fi
}

# Main execution starts here
echo "Starting audit for /var partition mount options..."

# Call the audit function
audit_nosuid_var

# Capture the audit result
audit_result=$?

# If audit fails, prompt user to manually verify configuration
if [ $audit_result -eq 1 ]; then
    echo "Please manually verify the /etc/fstab configuration to ensure nosuid option is set for /var."
    exit 1
fi