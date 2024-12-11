#!/bin/bash

# This script audits the permissions and ownership of the /etc/issue file.
# It checks if Access is 644 or more restrictive and Uid and Gid are both 0/root.

# Function to perform the audit
audit_issue_file() {
    local file="/etc/issue"

    # Capture the stat output into variables
    local stat_output
    stat_output=$(stat -Lc 'Access: (%#a/%A) Uid: (%u/%U) Gid: (%g/%G)' "$file")

    # Extract the permission, uid, and gid values
    local permissions
    local uid
    local gid
    permissions=$(echo "$stat_output" | awk '{print $2}' | cut -d'(' -f2 | cut -d'/' -f1)
    uid=$(echo "$stat_output" | awk '{print $4}' | cut -d'(' -f2 | cut -d'/' -f1)
    gid=$(echo "$stat_output" | awk '{print $6}' | cut -d'(' -f2 | cut -d'/' -f1)

    # Perform audit checks
    if [[ "$permissions" -le 644 && "$uid" -eq 0 && "$gid" -eq 0 ]]; then
        echo "Audit Passed: /etc/issue has correct permissions and ownership."
        exit 0
    else
        echo "Audit Failed: /etc/issue does not meet the required permissions or ownership criteria."
        echo "Expected: Permissions <= 644, Uid = 0, Gid = 0"
        echo "Found   : Permissions = $permissions, Uid = $uid, Gid = $gid"
        echo "Please manually set the mode, owner, and group on /etc/issue using the following commands:"
        echo "# chown root:root /etc/issue"
        echo "# chmod u-x,go-wx /etc/issue"
        exit 1
    fi
}

# Invoke the audit function
audit_issue_file

