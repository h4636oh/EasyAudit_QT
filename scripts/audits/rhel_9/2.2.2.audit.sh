#!/bin/bash

# Description: This script audits if the openldap-clients package is installed on the system.
# It is intended for Level 2 Servers and Workstations as a security measure to reduce the potential attack surface.
# It checks whether the LDAP client is present and exits with status 1 if it is; otherwise, it exits with 0.
# No remediation is performed by this script.

# Checking the presence of the openldap-clients package
audit_ldap_client() {
    if rpm -q openldap-clients &> /dev/null; then
        echo "Audit Failed: The openldap-clients package is installed."
        exit 1
    else
        echo "Audit Passed: The openldap-clients package is not installed."
        exit 0
    fi
}

# Run the audit function
audit_ldap_client

# This script checks if the `openldap-clients` package is installed on the system using the `rpm` command. If the package is found, it outputs a failed audit message and exits with a status of 1. If the package is not installed, it outputs a successful audit message and exits with a status of 0, adhering to the requirements of only performing an audit without remediation.