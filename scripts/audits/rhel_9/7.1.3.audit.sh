#!/bin/bash

FILE="/etc/group"

echo "Auditing $FILE..."

# Fetch file permissions in octal format
PERMISSIONS=$(stat -c "%a" "$FILE")
# Fetch Uid and Gid
UID=$(stat -c "%u" "$FILE")
GID=$(stat -c "%g" "$FILE")

# Check if permissions are exactly 644 or more restrictive (less than 666)
if [ "$PERMISSIONS" -le 644 ] && [ "$UID" -eq 0 ] && [ "$GID" -eq 0 ]; then
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