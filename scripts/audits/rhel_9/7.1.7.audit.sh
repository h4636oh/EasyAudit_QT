#!/bin/bash

# File to audit
FILE="/etc/gshadow"

echo "Auditing $FILE..."

# Fetch file permissions in octal format
PERMISSIONS=$(stat -c "%a" "$FILE")

# Fetch UID and GID of the file
OWNER=$(stat -c "%u" "$FILE")
GROUP=$(stat -c "%g" "$FILE")

# Expected values
EXPECTED_PERMISSIONS=0
EXPECTED_OWNER=0
EXPECTED_GROUP=0

# Audit checks
if [ "$PERMISSIONS" -eq "$EXPECTED_PERMISSIONS" ] && [ "$OWNER" -eq "$EXPECTED_OWNER" ] && [ "$GROUP" -eq "$EXPECTED_GROUP" ]; then
    OUTPUT=$(LC_ALL=C stat -Lc 'Access: (%#a/%A) Uid: (%u/%U) Gid: (%g/%G)' "$FILE" | sed 's/ \+/ /g')
    echo "Audit results for $FILE:"
    echo "$OUTPUT"
    echo "PASS: $FILE meets the security requirements."
    exit 0
else
    OUTPUT=$(LC_ALL=C stat -Lc 'Access: (%#a/%A) Uid: (%u/%U) Gid: (%g/%G)' "$FILE" | sed 's/ \+/ /g')
    echo "Audit results for $FILE:"
    echo "$OUTPUT"
    echo "FAIL: $FILE does not meet the security requirements."
    exit 1
fi
