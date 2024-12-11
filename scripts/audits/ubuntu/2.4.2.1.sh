#!/usr/bin/env bash

# Check if at is installed
if command -v at >/dev/null 2>&1; then
    echo "at is installed"

    # Verify /etc/at.allow
    if [ -e /etc/at.allow ]; then
        at_allow_status=$(stat -Lc 'Access: (%a/%A) Owner: (%U) Group: (%G)' /etc/at.allow)
        echo "$at_allow_status"
        # Check if the conditions are met
        if [[ "$at_allow_status" == *"Access: (640/-rw-r-----) Owner: (root) Group: (daemon)"* ]] || \
           [[ "$at_allow_status" == *"Access: (640/-rw-r-----) Owner: (root) Group: (root)"* ]]; then
            echo "/etc/at.allow permissions and ownership are correctly set."
        else
            echo "/etc/at.allow permissions or ownership are not correctly set."
            exit 1
        fi
    else
        echo "/etc/at.allow does not exist."
        exit 1
    fi

    # Verify /etc/at.deny
    if [ -e /etc/at.deny ]; then
        at_deny_status=$(stat -Lc 'Access: (%a/%A) Owner: (%U) Group: (%G)' /etc/at.deny)
        echo "$at_deny_status"
        # Check if the conditions are met
        if [[ "$at_deny_status" == *"Access: (640/-rw-r-----) Owner: (root) Group: (daemon)"* ]] || \
           [[ "$at_deny_status" == *"Access: (640/-rw-r-----) Owner: (root) Group: (root)"* ]]; then
            echo "/etc/at.deny permissions and ownership are correctly set."
        else
            echo "/etc/at.deny permissions or ownership are not correctly set."
            exit 1
        fi
    else
        echo "/etc/at.deny does not exist or is correctly configured."
    fi
else
    echo "at is not installed"
fi

