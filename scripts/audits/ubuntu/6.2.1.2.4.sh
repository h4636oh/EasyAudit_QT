#!/bin/bash

# Verify that systemd-journal-remote.socket and systemd-journal-remote.service are not enabled
enabled_status=$(systemctl is-enabled systemd-journal-remote.socket systemd-journal-remote.service 2>/dev/null | grep -P -- '^enabled')
if [ -z "$enabled_status" ]; then
    echo "systemd-journal-remote.socket and systemd-journal-remote.service are not enabled."
else
    echo "Warning: Some services are enabled:"
    echo "$enabled_status"
    exit 1
fi

# Verify that systemd-journal-remote.socket and systemd-journal-remote.service are not active
active_status=$(systemctl is-active systemd-journal-remote.socket systemd-journal-remote.service 2>/dev/null | grep -P -- '^active')
if [ -z "$active_status" ]; then
    echo "systemd-journal-remote.socket and systemd-journal-remote.service are not active."
else
    echo "Warning: Some services are active:"
    echo "$active_status"
    exit 1
fi

