#!/usr/bin/env bash

# Check if DisableForwarding is set to yes
disable_forwarding=$(sshd -T | grep -i disableforwarding)

if [[ "$disable_forwarding" == "disableforwarding yes" ]]; then
  echo "DisableForwarding is set to yes"
else
  echo "DisableForwarding is not set to yes"
  exit 1
fi

