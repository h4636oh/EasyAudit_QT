#!/bin/bash

# Title: Ensure noexec option set on /tmp partition (Automated)
# Description: The noexec mount option specifies that the filesystem cannot contain executable binaries.
# Rationale: This ensures that users cannot run executable binaries from /tmp.
# Profile Applicability: Level 1 - Server, Level 1 - Workstation

# Function to audit the noexec option on /tmp
audit_noexec_tmp() {
    if findmnt -kn /tmp | grep -v noexec > /dev/null 2>&1; then
        echo "Audit failed: /tmp is a separate partition, and 'noexec' is NOT set."
        exit 1
    else
        echo "Audit passed: 'noexec' is set on /tmp partition."
        exit 0
    fi
}

# Inform user if manual checks are necessary
prompt_manual_check() {
    echo "Please ensure manually that /tmp is a separate partition."
}

# Start the audit process
echo "Starting audit for /tmp partition 'noexec' option..."
prompt_manual_check
audit_noexec_tmp

### Explanation:
# - The script checks if the `/tmp` partition is mounted with the `noexec` option using `findmnt`. 
# - It provides output based on whether the `noexec` option is set or not.
# - It exits with `0` if the `noexec` option is correctly set or `1` if it is not.
# - The script prompts the user to manually verify if `/tmp` is indeed a separate partition as part of a thorough audit.