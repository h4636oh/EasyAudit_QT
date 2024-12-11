#!/bin/bash

# Audit script to check if the 'nosuid' option is set on the /var/log/audit partition.
# This script will exit with code 0 if the audit passes (nosuid is set),
# and exit with code 1 if the audit fails (nosuid is not set).

# Check if a separate partition exists for /var/log/audit and if 'nosuid' option is set
if findmnt -kn /var/log/audit | grep -v nosuid > /dev/null; then
    echo "FAIL: 'nosuid' option is NOT set on the /var/log/audit partition."
    # The audit failed because the 'nosuid' option is not set. Exit with code 1.
    exit 1
else
    echo "PASS: 'nosuid' option is set on the /var/log/audit partition or no separate partition exists."
    # The audit passed because the 'nosuid' option is set, or there is no separate partition for /var/log/audit.
    exit 0
fi

# Note: If the findmnt command returns nothing, it indicates that 'nosuid' is set, 
# which is the desired and compliant configuration, hence PASS.
