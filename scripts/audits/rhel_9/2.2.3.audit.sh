#!/bin/bash

# Title: Audit for NIS Client Installation
# Profile Applicability: 
# • Level 1 - Server
# • Level 1 - Workstation
# Description: 
# The Network Information Service (NIS), formerly known as Yellow Pages, 
# is a client-server directory service protocol used to distribute system configuration files. 
# The NIS client (ypbind) was used to bind a machine to an NIS server and receive the distributed configuration files.
# Rationale:
# The NIS service is inherently an insecure system vulnerable to DOS attacks, 
# buffer overflows, and has poor authentication for querying NIS maps.

# Audit: Verify that the ypbind package is not installed.

# Run the following command to verify that the ypbind package is not installed:
if rpm -q ypbind &> /dev/null; then
    echo "Audit Failed: NIS client (ypbind) is installed on the system."
    exit 1
else
    echo "Audit Passed: NIS client (ypbind) is not installed on the system."
    exit 0
fi

# Notes:
# The script checks for the presence of the ypbind package.
# If installed, it exits with status 1 indicating the audit has failed.
# If not installed, it exits with status 0 indicating the audit has passed.
# This script does not perform remediation; it is only for auditing purposes.