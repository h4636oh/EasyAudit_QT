#!/bin/bash

# Script to audit if /var is mounted on a separate partition
# The script does not remediate, it only audits.
# Exits 0 if the requirement is met, exits 1 if it is not.

# Check if /var is mounted on a separate partition
output=$(findmnt -kn /var)

# Check the output for the presence of /var mount details
if [[ "$output" == *"/var"* ]]; then
    echo "/var is mounted on a separate partition."
    exit 0
else
    echo "/var is NOT mounted on a separate partition. Please verify manually."
    exit 1
fi

### Script Details and Assumptions:
# - The script uses the `findmnt` command to check if `/var` is mounted separately.
# - It assumes that the presence of `/var` in the `findmnt` output indicates that the directory is indeed on a separate partition.
# - The script exits with `0` if `/var` is properly mounted, and with `1` if it is not, aligning with audit-only requirements.