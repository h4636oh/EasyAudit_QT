#!/bin/bash

# Define the search pattern for the $FileCreateMode directive
PATTERN='^\h*\$FileCreateMode\h+0[0,2,4,6][0,2,4]0\b'

# Define the files to search in
FILES="/etc/rsyslog.conf /etc/rsyslog.d/*.conf"

# Search for the $FileCreateMode in the specified files
MATCHES=$(grep -Psr "$PATTERN" $FILES)

# Check if matches were found and validate the output
if [ -n "$MATCHES" ]; then
    echo "Audit Passed: $FileCreateMode directive found and configured correctly."
    echo "$MATCHES"
    exit 0
else
    echo "Audit Failed: $FileCreateMode directive is missing or misconfigured."
    exit 1
fi
