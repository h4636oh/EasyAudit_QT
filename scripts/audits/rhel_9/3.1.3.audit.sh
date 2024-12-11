#!/bin/bash

# Script to audit bluetooth service and bluez package status

# Function to check the bluez package status
check_bluez_package() {
    if rpm -q bluez &>/dev/null; then
        echo "bluez package is installed."
        echo "If required as a dependency, ensure it's approved by local site policy."
        return 1
    else
        echo "bluez package is not installed."
        return 0
    fi
}

# Function to check bluetooth.service status if bluez is required
check_bluetooth_service() {
    service_enabled=$(systemctl is-enabled bluetooth.service 2>/dev/null | grep 'enabled')
    service_active=$(systemctl is-active bluetooth.service 2>/dev/null | grep '^active')

    if [[ -z $service_enabled && -z $service_active ]]; then
        echo "bluetooth.service is not enabled or active."
        return 0
    else
        echo "bluetooth.service is either enabled or active."
        echo "Ensure stopping and masking the service meets local site policy."
        return 1
    fi
}

# Main script logic
if check_bluez_package; then
    if check_bluetooth_service; then
        echo "Audit passed. Bluetooth services are not in use."
        exit 0
    else
        echo "Audit failed!"
        exit 1
    fi
else
    echo "Audit failed!"
    exit 1
fi

### Description:
# - This script audits the presence of the `bluez` package and the status of `bluetooth.service`.
# - It checks if the `bluez` package is installed. If it is not, the audit passes for the package check.
# - If the `bluez` package is required, it checks whether `bluetooth.service` is enabled or active. If neither, the audit passes for the service check.
# - The script exits with `0` if both conditions to not using bluetooth are met, otherwise it exits with `1`.