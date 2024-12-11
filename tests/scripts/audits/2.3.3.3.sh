#!/bin/bash

# Check if chronyd is running as the _chrony user
chrony_user_check=$(ps -ef | awk '(/[c]hronyd/ && $1!="_chrony") { print $1 }')

if [[ -n $chrony_user_check ]]; then
    echo "chronyd is not running as _chrony user. Found: $chrony_user_check"
else
    echo "chronyd is running as _chrony user."
fi

# Check if chrony.service is enabled
chrony_enabled=$(systemctl is-enabled chrony.service 2>/dev/null)

if [[ $chrony_enabled == "enabled" ]]; then
    echo "chrony.service is enabled."
else
    echo "chrony.service is not enabled."
    exit 1
fi

# Check if chrony.service is active
chrony_active=$(systemctl is-active chrony.service 2>/dev/null)

if [[ $chrony_active == "active" ]]; then
    echo "chrony.service is active."
else
    echo "chrony.service is not active."
    exit 1
fi

