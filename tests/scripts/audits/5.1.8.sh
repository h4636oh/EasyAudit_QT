#!/usr/bin/env bash

# Check if DisableForwarding is set to yes
if sshd -T | grep -i -q disableforwarding | grep -i -q "disableforwarding yes"; then
  echo "PASS: DisableForwarding is set to yes."
  exit 0
else
  echo "FAIL: DisableForwarding is not set to yes."
  exit 1
fi
