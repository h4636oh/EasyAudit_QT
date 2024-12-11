#!/usr/bin/env bash

# Audit script to verify that the enforce_for_root option is enabled in pwquality configuration files.

echo "Starting audit for enforce_for_root option..."

# 1. Check for enforce_for_root in pwquality configuration files
echo "Checking for enforce_for_root in /etc/security/pwquality.conf and /etc/security/pwquality.conf.d/..."

# Search for enforce_for_root in pwquality configuration files under /etc/security/
grep -Psi '^\h*enforce_for_root\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf

# If enforce_for_root is not found, print a message
if ! grep -Psi '^\h*enforce_for_root\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf; then
    echo "enforce_for_root is not enabled in any pwquality configuration file."
else
    echo "enforce_for_root is enabled in the following configuration files:"
    grep -Psi '^\h*enforce_for_root\b' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/*.conf
fi

echo "Audit completed. Please review the output for any discrepancies."