#!/bin/bash

# This script audits to ensure that the system-wide crypto policy is not set to LEGACY.
# It returns exit 0 if the audit passes (i.e., policy is not LEGACY), otherwise exits with status 1.

# Command to check if the system-wide crypto policy is set to LEGACY
grep -Pi '^\h*LEGACY\b' /etc/crypto-policies/config >/dev/null 2>&1 

if [ $? -eq 0 ]; then
    echo "Audit failed: The system-wide crypto policy is set to LEGACY."
    exit 1
else
    echo "Audit passed: The system-wide crypto policy is not set to LEGACY."
    exit 0
fi

# Script Explanation:
# - The script uses `grep` to search for any instances of the word "LEGACY" in the `/etc/crypto-policies/config` file.
# - The `-P` option enables Perl-compatible regular expressions, and `-i` makes the search case insensitive.
# - `^\h*LEGACY\b` ensures that the search term "LEGACY" is found at the beginning of a line with optional whitespace, making the check more precise for policy setting.
# - After running the command, we check the exit status `$?` of `grep`. If it is `0`, it means "LEGACY" was found, indicating a failure in the audit.
# - Accordingly, the script prints a message and exits with status `1` for a failed audit and `0` for a passed audit.