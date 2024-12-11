#!/usr/bin/env bash

# Check if at is installed
if command -v at >/dev/null 2>&1; then
    echo "at is installed"

    # Determine the group for ownership
    if grep -Pq -- '^daemon\b' /etc/group; then
        l_group="daemon"
    else
        l_group="root"
    fi

    # Create /etc/at.allow if it doesn't exist, and set ownership and permissions
    if [ ! -e "/etc/at.allow" ]; then
        touch /etc/at.allow
        echo "/etc/at.allow created"
    fi
    chown root:"$l_group" /etc/at.allow
    chmod u-x,g-wx,o-rwx /etc/at.allow
    echo "/etc/at.allow ownership and permissions set"

    # If /etc/at.deny exists, set ownership and permissions
    if [ -e "/etc/at.deny" ]; then
        chown root:"$l_group" /etc/at.deny
        chmod u-x,g-wx,o-rwx /etc/at.deny
        echo "/etc/at.deny ownership and permissions set"
    else
        echo "/etc/at.deny does not exist"
    fi
else
    echo "at is not installed"
fi

