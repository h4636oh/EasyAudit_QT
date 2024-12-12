#!/usr/bin/env bash
{
    # Check if ufw service is enabled
    ufw_enabled=$(systemctl is-enabled ufw.service)
    if [[ "$ufw_enabled" == "enabled" ]]; then
        echo "- UFW service is enabled."
    else
        echo "- UFW service is NOT enabled."
    fi

    # Check if ufw service is active
    ufw_active=$(systemctl is-active ufw)
    if [[ "$ufw_active" == "active" ]]; then
        echo "- UFW service is active."
    else
        echo "- UFW service is NOT active."
        exit 1
    fi

    # Check if UFW status is active
    ufw_status=$(ufw status)
    if [[ "$ufw_status" == *"Status: active"* ]]; then
        echo "- UFW is active."
    else
        echo "- UFW is NOT active."
        exit 1
    fi
}