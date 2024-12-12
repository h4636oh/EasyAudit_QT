#!/usr/bin/env bash

# Check if UsePAM is set to yes
if sshd -T | grep -i -q usepam | grep -i -q "usepam yes"; then
  echo "PASS: UsePAM is set to yes."
  exit 0
else
  echo "FAIL: UsePAM is not set to yes."
  exit 1
fi
