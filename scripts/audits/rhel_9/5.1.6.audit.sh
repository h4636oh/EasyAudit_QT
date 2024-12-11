#!/bin/bash

# This script audits the SSHD MAC configuration to ensure no weak MAC algorithms are used.
# It checks against known weak MACs and ensures compliance by issuing a warning if any are found.

# Function to check for weak MACs in SSH configuration
check_weak_macs() {
    local weak_macs="hmac-md5|hmac-md5-96|hmac-ripemd160|hmac-sha1-96|umac-64@openssh.com|hmac-md5-etm@openssh.com|hmac-md5-96-etm@openssh.com|hmac-ripemd160-etm@openssh.com|hmac-sha1-96-etm@openssh.com|umac-64-etm@openssh.com|umac-128-etm@openssh.com"

    # Execute the SSHD test command and search for weak MAC patterns
    sshd -T | grep -Pi -- "macs\\h+([^#\\n\\r]+,)?($weak_macs)\\b" &> /dev/null
    
    if [ $? -eq 0 ]; then
        echo "Weak MAC algorithms are configured in sshd. Please review and update your configuration to disable these weak MACs."
        # Instructions for reviewing CVE and manual checks
        echo -e "Note: Review CVE-2023-48795 and verify the system has been patched.\nIf the system has not been patched, review the use of the Encrypt Then Mac (etm) MACs."
        exit 1
    else
        echo "No weak MAC algorithms found in sshd configuration. Audit passed."
        exit 0
    fi
}

# Main execution
check_weak_macs

### Script Explanation:
# - **Purpose**: The script is designed to audit SSHD's MAC configuration for the presence of any weak MAC algorithms, using a predefined list of weak MACs.
# - **Check Function**: The `check_weak_macs` function runs the `sshd -T` command to print the SSH daemon's effective configuration and `grep` is used with a regex to search for any usage of known weak MAC algorithms.
# - **Exit Codes**: 
#   - Exits with status `1` if weak MACs are found, indicating an audit failure.
#   - Exits with status `0` if no weak MACs are found, indicating an audit success.
# - **Manual Step Prompt**: Provides a message for the user to manually review a CVE and check the system’s patch status as part of the audit procedure.