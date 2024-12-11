#!/bin/bash

# Verify if systemd-journal-upload is enabled
status_enabled=$(systemctl is-enabled systemd-journal-upload.service)
echo "systemd-journal-upload.service is-enabled status: $status_enabled"
if [ "$status_enabled" != "enabled" ]; then
    echo "Warning: systemd-journal-upload.service is not enabled. Please investigate."
    exit 1
fi

# Verify if systemd-journal-upload is active
status_active=$(systemctl is-active systemd-journal-upload.service)
echo "systemd-journal-upload.service is-active status: $status_active"
if [ "$status_active" != "active" ]; then
    echo "Warning: systemd-journal-upload.service is not active. Please investigate."
    exit 1
fi

