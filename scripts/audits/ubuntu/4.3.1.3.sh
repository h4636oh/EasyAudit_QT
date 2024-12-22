#!/usr/bin/env bash

# Check if ufw is not installed
if dpkg-query -s ufw &>/dev/null; then
  echo "ufw is installed"
  exit 1
else
  echo "ufw is not installed"
  exit 0
fi

# Check if ufw is disabled
ufw_status=$(ufw status)
if [[ "$ufw_status" == "Status: inactive" ]]; then
  echo "ufw is disabled"
else
  echo "ufw is active"
  exit 1
fi

# Check if ufw service is masked
ufw_service_status=$(systemctl is-enabled ufw 2>/dev/null)
if [[ "$ufw_service_status" == "masked" ]]; then
  echo "ufw service is masked"
else
  echo "ufw service is not masked"
  exit 1
fi

