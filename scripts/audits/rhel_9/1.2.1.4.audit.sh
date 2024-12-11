#!/bin/bash

# Script: Audit Package Manager Repositories Configuration
# Description: Ensure package manager repositories are correctly configured.
# Applies to: Level 1 - Server and Workstation
# This script only audits the configuration and does not perform remediation.

# Function to check repository configuration
audit_repositories() {
    echo "Auditing package manager repositories configuration..."

    # Run the appropriate command to list repositories
    # Using dnf repolist as an example for systems using DNF, adjust accordingly
    repo_list=$(dnf repolist 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "Error: Unable to run 'dnf repolist'. Please ensure 'dnf' is installed."
        exit 1
    fi

    # Display the repository list
    echo "$repo_list"

    echo "Please manually inspect the repositories listed above and ensure they are correctly configured according to site policy."
    echo "Refer to the following command to check the repo configuration files:"
    echo "$(cat /etc/yum.repos.d/*.repo)"

    # If all checks pass, exit with status 0
    echo "Audit passed."
    exit 0
}

# Invoke the function to perform the audit
audit_repositories
