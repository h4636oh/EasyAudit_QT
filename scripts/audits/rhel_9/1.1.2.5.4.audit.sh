#!/bin/bash

# Purpose: Audit if the noexec option is set on the /var/tmp partition
# This script will exit 0 if the audit passes, and exit 1 if the audit fails.

# Check if there's a separate partition for /var/tmp
if findmnt -kn /var/tmp &> /dev/null; then
    # Check if the noexec option is set
    if findmnt -kn /var/tmp | grep -v 'noexec' &> /dev/null; then
        # noexec option is NOT set, audit fails
        echo "Audit failed: /var/tmp partition exists but noexec option is not set."
        exit 1
    else
        # noexec option is set, audit passes
        echo "Audit passed: /var/tmp partition exists and noexec option is set."
        exit 0
    fi
else
    # No separate partition for /var/tmp, manual verification required
    echo "Manual audit required: No separate partition exists for /var/tmp."
    echo "Please verify manually if /var/tmp is part of another partition."
    exit 0
fi
