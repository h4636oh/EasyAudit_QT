systemctl is-enabled nftables#!/usr/bin/env bash

# Check if nftables service is enabled
nftables_status=$(systemctl is-enabled nftables 2>/dev/null)

if [[ "$nftables_status" == "enabled" ]]; then
  echo "nftables service is enabled"
else
  echo "nftables service is not enabled"
  exit 1
fi

