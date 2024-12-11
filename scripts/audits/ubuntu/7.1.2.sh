#!/usr/bin/env bash

# Verify /etc/passwd- is mode 644 or more restrictive, Uid is 0/root and Gid is 0/root
file_check=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/passwd-)

expected_output="Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)"

if [[ "$file_check" == "$expected_output" ]]; then
    echo "OK: /etc/passwd- permissions, UID, and GID are as expected."
else
    echo "Warning: /etc/passwd- does not meet the expected criteria."
    echo "$file_check"
    exit 1
fi
