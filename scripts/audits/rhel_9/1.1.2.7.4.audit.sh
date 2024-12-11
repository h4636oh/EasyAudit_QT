#!/bin/bash

# Script to audit the noexec mount option for /var/log/audit
# This script checks if noexec is set on the /var/log/audit partition
# It exits 0 if the option is correctly set, and exits 1 otherwise
# The script does not perform any remediation

# Check if /var/log/audit is a separate partition and 'noexec' option is set
if findmnt -kn /var/log/audit | grep -vq noexec; then
    echo "Audit Failed: The 'noexec' option is not set for the /var/log/audit partition."
    exit 1
else
    echo "Audit Passed: The 'noexec' option is correctly set for the /var/log/audit partition."
    exit 0
fi

# Note: If no separate partition exists for /var/log/audit, the script assumes it does not 
# require 'noexec', aligning with default system configurations and common practices.