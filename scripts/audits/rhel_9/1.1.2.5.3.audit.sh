#!/bin/bash

# Script to audit that the 'nosuid' option is set on the /var/tmp partition
# Exit 1 if audit fails, exit 0 if it passes
# This script should be run with appropriate permissions to read the mount configuration

# Function to check if nosuid is set on /var/tmp
audit_nosuid_on_var_tmp() {
    # Using findmnt to filter /var/tmp and check if nosuid option is not set
    local mount_output
    mount_output=$(findmnt -kn /var/tmp | grep -v nosuid)

    if [ -n "$mount_output" ]; then
        echo "Audit Failed: 'nosuid' option is not set on /var/tmp partition."
        echo "Manual Action Required: Configure the /etc/fstab file and add 'nosuid' to the /var/tmp partition options."
        # Exit with status 1 indicating failure
        exit 1
    else
        echo "Audit Passed: 'nosuid' option is correctly set on /var/tmp partition."
        # Exit with status 0 indicating success
        exit 0
    fi
}

# Make sure that /var/tmp is a separate partition before auditing
if findmnt -kn /var/tmp > /dev/null; then
    audit_nosuid_on_var_tmp
else
    echo "/var/tmp is not a separate partition. Audit is not applicable."
    # Exit with status 0 because the requirement is not applicable
    exit 0
fi
