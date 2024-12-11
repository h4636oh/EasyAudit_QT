#!/bin/bash

# Verify if auditd is enabled
is_enabled=$(systemctl is-enabled auditd 2>/dev/null | grep '^enabled')
if [ "$is_enabled" ]; then
    echo "auditd is enabled"
else
    echo "auditd is not enabled"
    exit 1
fi

# Verify if auditd is active
is_active=$(systemctl is-active auditd 2>/dev/null | grep '^active')
if [ "$is_active" ]; then
    echo "auditd is active"
else
    echo "auditd is not active"
    exit 1
fi

