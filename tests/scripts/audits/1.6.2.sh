#!/bin/bash

# Display the contents of /etc/issue
echo "Contents of /etc/issue:"
cat /etc/issue

# Check for the presence of specific escape sequences or values in /etc/issue
echo "Verifying content against policy..."
result=$(grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/\"//g'))" /etc/issue)

# Display results
if [ -z "$result" ]; then
    echo "Verification successful: No disallowed content found in /etc/issue."
else
    echo "Verification failed: Disallowed content found in /etc/issue."
    echo "$result"
    exit 1
fi

