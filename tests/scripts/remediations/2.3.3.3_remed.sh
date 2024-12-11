#!/bin/bash

# Check if chronyd is running as the _chrony user
chrony_user_check=$(ps -ef | awk '(/[c]hronyd/ && $1!="_chrony") { print $1 }')

if [[ -n $chrony_user_check ]]; then
    echo "chronyd is not running as _chrony user. Found: $chrony_user_check"
    exit 1
else
    echo "chronyd is running as _chrony user."
fi

# Check if chrony.service is enabled
chrony_enabled=$(systemctl is-enabled chrony.service 2>/dev/null)

# Check if chrony.service is active
chrony_active=$(systemctl is-active chrony.service 2>/dev/null)

if [[ $chrony_enabled == "enabled" && $chrony_active == "active" ]]; then
    echo "chrony.service is in use. Unmasking, enabling, and starting chrony.service..."
    systemctl unmask chrony.service
    systemctl --now enable chrony.service
    echo "chrony.service is unmasked, enabled, and started."
else
    echo "chrony is not in use. Removing chrony..."
    apt purge -y chrony
    apt autoremove -y
    echo "chrony has been removed."
fi

