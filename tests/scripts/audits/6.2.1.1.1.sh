#!/bin/bash

# Verify if systemd-journald is enabled
status_enabled=$(systemctl is-enabled systemd-journald.service)
echo "systemd-journald.service is-enabled status: $status_enabled"
if [ "$status_enabled" != "static" ]; then
    echo "Warning: systemd-journald.service is not static. Investigate why."
    exit 1
fi

# Verify if systemd-journald is active
status_active=$(systemctl is-active systemd-journald.service)
echo "systemd-journald.service is-active status: $status_active"
if [ "$status_active" != "active" ]; then
    echo "Warning: systemd-journald.service is not active. Investigate why."
    exit 1
fi

