#!/bin/bash

# Script to audit the status of the systemd-journald service 

# Check if systemd-journald is enabled (expected to be 'static').
is_enabled=$(systemctl is-enabled systemd-journald.service 2>/dev/null)

# Check if systemd-journald is active (expected to be 'active').
is_active=$(systemctl is-active systemd-journald.service 2>/dev/null)

# By default systemd-journald is 'static', confirm it.
if [ "$is_enabled" != "static" ]; then
  echo "Audit failed: The systemd-journald service is not 'static'. Investigate reasons why it is not 'static'."
  exit 1
fi

# Confirming systemd-journald is 'active'.
if [ "$is_active" != "active" ]; then
  echo "Audit failed: The systemd-journald service is not 'active'. Investigate reasons why it is not active."
  exit 1
fi

echo "Audit passed: The systemd-journald service is 'static' and 'active'."
exit 0
```

