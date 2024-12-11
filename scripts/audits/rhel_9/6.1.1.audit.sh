#!/bin/bash

# Audit Script for Verifying Installation of AIDE

echo "Starting audit to verify if AIDE is installed..."

# Check if AIDE is installed using rpm
aide_status=$(rpm -q aide)

# Evaluate the audit result
if [[ $aide_status == "package aide is not installed" ]]; then
    echo "Audit Failed: AIDE is not installed."
    echo "Please install AIDE using the following command: sudo dnf install aide"
    exit 1
else
    echo "$aide_status"
    echo "Audit Passed: AIDE is installed."
    exit 0
fi


# Note:
# The script checks if the AIDE package is installed on the system using `rpm -q aide`.
# If the package is not installed, it alerts the user to install AIDE and exits with status 1.
# If installed, it confirms the presence of AIDE and exits with status 0.