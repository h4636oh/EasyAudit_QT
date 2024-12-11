#!/bin/bash

# Verify if systemd-timesyncd service is in use
if systemctl list-unit-files | grep -q 'systemd-timesyncd.service'; then
  echo "systemd-timesyncd.service is in use"

  # Verify that the systemd-timesyncd service is enabled
  if systemctl is-enabled systemd-timesyncd.service &>/dev/null; then
    echo "The systemd-timesyncd service is enabled"
  else
    echo "The systemd-timesyncd service is not enabled"
    exit 1
  fi

  # Verify that the systemd-timesyncd service is active
  if systemctl is-active systemd-timesyncd.service &>/dev/null; then
    echo "The systemd-timesyncd service is active"
  else
    echo "The systemd-timesyncd service is not active"
    exit 1
  fi

else
  echo "systemd-timesyncd.service is not in use on this system"
fi

