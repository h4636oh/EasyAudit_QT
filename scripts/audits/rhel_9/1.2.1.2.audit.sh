#!/bin/bash

# Audit Script for Ensuring gpgcheck is Globally Activated

# Function to check the global gpgcheck setting in /etc/dnf/dnf.conf
check_global_gpgcheck() {
    echo "Checking global gpgcheck setting in /etc/dnf/dnf.conf..."
    if grep -Pi --quiet '^\\h*gpgcheck\\h*=\\h*(1|true|yes)\\b' /etc/dnf/dnf.conf; then
        echo "Global gpgcheck is correctly set."
    else
        echo "Global gpgcheck is not set correctly. Please ensure gpgcheck is set to 1, true, or yes in /etc/dnf/dnf.conf."
        return 1
    fi
}

# Function to check gpgcheck settings in all repo files under /etc/yum.repos.d/
check_repo_gpgcheck() {
    echo "Checking gpgcheck settings in /etc/yum.repos.d/..."
    INVALID_ENTRIES=$(grep -Pris -- '^\\h*gpgcheck\\h*=\\h*(0|[2-9]|[1-9][0-9]+|false|no)\\b' /etc/yum.repos.d/)
    
    if [ -z "$INVALID_ENTRIES" ]; then
        echo "No invalid gpgcheck settings found in /etc/yum.repos.d/."
    else
        echo "Invalid gpgcheck settings found in the following files:"
        echo "$INVALID_ENTRIES"
        echo "Please ensure all gpgcheck settings in /etc/yum.repos.d/ are set to 1, true, or yes."
        return 1
    fi
}

# Perform the audit
check_global_gpgcheck
GLOBAL_CHECK_RESULT=$?

check_repo_gpgcheck
REPO_CHECK_RESULT=$?

# Determine overall audit result
if [ $GLOBAL_CHECK_RESULT -eq 0 ] && [ $REPO_CHECK_RESULT -eq 0 ]; then
    echo "Audit passed. gpgcheck is properly configured globally and in all repo files."
    exit 0
else
    echo "Audit failed. Please address the above issues."
    exit 1
fi

# This script performs an audit to ensure that the `gpgcheck` setting is correctly configured both globally in `/etc/dnf/dnf.conf` and in all repository files under `/etc/yum.repos.d/`. If the audit fails, it instructs the user on how to correct the configuration without making changes automatically.