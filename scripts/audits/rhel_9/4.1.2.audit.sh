#!/usr/bin/env bash

# Audit script to ensure a single firewall configuration utility is in use

# Variables to store the status of firewalld and nftables
l_fwd_status=""
l_nft_status=""
l_fwutil_status=""

# Determine FirewallD utility Status
if rpm -q firewalld > /dev/null 2>&1; then
    l_fwd_status="$(systemctl is-enabled firewalld.service):$(systemctl is-active firewalld.service)"
fi

# Determine NFTables utility Status
if rpm -q nftables > /dev/null 2>&1; then
    l_nft_status="$(systemctl is-enabled nftables.service):$(systemctl is-active nftables.service)"
fi

# Consolidate the firewall utility statuses
l_fwutil_status="$l_fwd_status:$l_nft_status"

case $l_fwutil_status in
    enabled:active:masked:inactive|enabled:active:disabled:inactive)
        l_output="\n - FirewallD utility is in use, enabled and active\n - NFTables utility is correctly disabled or masked and inactive\n - Only configure the recommendations found in the Configure Firewalld subsection"
        ;;
    masked:inactive:enabled:active|disabled:inactive:enabled:active)
        l_output="\n - NFTables utility is in use, enabled and active\n - FirewallD utility is correctly disabled or masked and inactive\n - Only configure the recommendations found in the Configure NFTables subsection"
        ;;
    enabled:active:enabled:active)
        l_output2="\n - Both FirewallD and NFTables utilities are enabled and active. Configure only ONE firewall either NFTables OR Firewalld"
        ;;
    enabled:*:enabled:*)
        l_output2="\n - Both FirewallD and NFTables utilities are enabled\n - Configure only ONE firewall: either NFTables OR Firewalld"
        ;;
    *:active:*:active)
        l_output2="\n - Both FirewallD and NFTables utilities are enabled\n - Configure only ONE firewall: either NFTables OR Firewalld"
        ;;
    :enabled:active)
        l_output="\n - NFTables utility is in use, enabled, and active\n - FirewallD package is not installed\n - Only configure the recommendations found in the Configure NFTables subsection"
        ;;
    :)
        l_output2="\n - Neither FirewallD or NFTables is installed. Configure only ONE firewall either NFTables OR Firewalld"
        ;;
    *:*)
        l_output2="\n - NFTables package is not installed on the system.\nInstall NFTables and Configure only ONE firewall either NFTables OR Firewalld"
        ;;
    *)
        l_output2="\n - Unable to determine firewall state. Configure only ONE firewall either NFTables OR Firewalld"
        ;;
esac

# Output results
if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Results:\n ** Pass **\n$l_output\n"
    exit 0
else
    echo -e "\n- Audit Results:\n ** Fail **\n$l_output2\n"
    exit 1
fi

# Note: This script only audits the firewall status on the system and provides guidance based on that status. It checks for the presence and state of both `firewalld` and `nftables` services, recommending action when both are active or neither is properly configured. Adjustments or installation should be managed manually based on site-specific policies.