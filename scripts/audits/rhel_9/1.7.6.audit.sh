#!/bin/bash

# This script audits the access permissions, owner, and group of the /etc/issue.net file.
# It ensures that the file is as per security recommendation: Access 644, Uid and Gid are both 0/root.

# Command to get the file permissions, Uid and Gid
audit_command="stat -Lc 'Access: (%a) Uid: (%u) Gid: (%g)' /etc/issue.net"

# Execute the command and store the output
output=$(eval $audit_command)

# Extract the permissions, Uid and Gid from the output
access=$(echo $output | awk '{print $2}' | tr -d '()')
uid=$(echo $output | awk '{print $4}' | tr -d '()')
gid=$(echo $output | awk '{print $6}' | tr -d '()')

# Default Values
expected_access="644"
expected_uid="0"
expected_gid="0"

# Function to print failure message and exit with status 1
function audit_fail {
    echo "Audit failed: /etc/issue.net does not have the correct permissions, Uid, or Gid."
    echo "Current settings: Access: $access, Uid: $uid, Gid: $gid"
    echo "Expected settings: Access: $expected_access, Uid: $expected_uid, Gid: $expected_gid"
    exit 1
}

# Perform audit
if [[ "$access" == "$expected_access" && "$uid" == "$expected_uid" && "$gid" == "$expected_gid" ]]; then
    echo "Audit passed: /etc/issue.net is configured correctly."
    exit 0
else
    audit_fail
fi
