#!/bin/bash

SERVICE_NAME="systemd-journal-upload.service"

echo "Auditing $SERVICE_NAME status..."

# Check if the service is enabled
is_enabled=$(systemctl is-enabled $SERVICE_NAME 2>/dev/null)
if [ $? -ne 0 ]; then
    echo "$SERVICE_NAME is not installed or does not exist."
    exit 1
fi

# Check if the service is active
is_active=$(systemctl is-active $SERVICE_NAME)

# Output the results
echo "Service Status:"
echo " - Enabled: $is_enabled"
echo " - Active: $is_active"

# Determine the overall status
if [[ "$is_enabled" == "enabled" && "$is_active" == "active" ]]; then
    echo "Audit Successful: $SERVICE_NAME is enabled and active."
    exit 0
else
    echo "Audit Failed: $SERVICE_NAME is not properly configured."
    exit 1
fi