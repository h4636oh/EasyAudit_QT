#!/bin/bash


# Display the contents of /etc/motd
cat /etc/motd

echo
echo "verify that the contents match site policy"

# Verify no restricted keywords are present
restricted_keywords=$(grep -E -i "(\v|\r|\m|\s|$(grep '^ID=' /etc/os-release | cut -d= -f2 | sed -e 's/\"//g'))" /etc/motd)

if [ -z "$restricted_keywords" ]; then
    echo "No restricted keywords found in /etc/motd."
else
    echo "Restricted keywords found in /etc/motd:"
    echo "$restricted_keywords"
    exit 1
fi

