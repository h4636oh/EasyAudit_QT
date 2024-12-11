#!/bin/bash

# Script to audit if the TFTP client is installed on the system
# This script checks for the presence of the TFTP package and exits
# with a status code indicating whether the package is installed.
# It does NOT perform any remedial actions, only audits as specified.

# Check if the TFTP package is installed
package_check=$(rpm -q tftp)

# Analyze the result of the package query
if [[ "$package_check" == "package tftp is not installed" ]]; then
    echo "Audit passed: TFTP client is not installed."
    exit 0
else
    echo "Audit failed: TFTP client is installed."
    exit 1
fi

