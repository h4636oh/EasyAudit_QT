#!/bin/bash

# Display the contents of /etc/issue.net
echo "Contents of /etc/issue.net:"
cat /etc/issue.net

# Check for the presence of specific escape sequences or values in /etc/issue.net
echo "Verifying content against policy..."
result=$(grep -E -i "(\\\v|\\\r|\\\m|\\\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/\"//g'))" /etc/issue.net)

# Display results
if [ -z "$result" ]; then
    echo "Verification successful: No disallowed content found in /etc/issue.net."
else
    echo "Verification failed: Disallowed content found in /etc/issue.net."
    echo "$result"
    exit 1
fi

