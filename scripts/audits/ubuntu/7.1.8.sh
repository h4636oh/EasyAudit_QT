#!/usr/bin/env bash

# Verify /etc/gshadow- is mode 640 or more restrictive, Uid is 0/root and Gid is 0/root or shadow
file_check=$(stat -Lc 'Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/gshadow-)

expected_output_1="Access: (0640/-rw-r-----) Uid: ( 0/ root) Gid: ( 0/ root)"
expected_output_2="Access: (0640/-rw-r-----) Uid: ( 0/ root) Gid: ( 42/ shadow)"

if [[ "$file_check" == "$expected_output_1" || "$file_check" == "$expected_output_2" ]]; then
    echo "OK: /etc/gshadow- permissions, UID, and GID are as expected."
else
    echo "Warning: /etc/gshadow- does not meet the expected criteria."
    echo "$file_check"
    exit 1
fi

