#!/usr/bin/env bash

# Check the values of ClientAliveInterval and ClientAliveCountMax
settings=$(sshd -T | grep -Pi -- '(clientaliveinterval|clientalivecountmax)')

# Check if both settings are greater than zero
if echo "$settings" | grep -qE 'clientaliveinterval\s+[1-9][0-9]*' && echo "$settings" | grep -qE 'clientalivecountmax\s+[1-9][0-9]*'; then
  echo "PASS: ClientAliveInterval and ClientAliveCountMax are correctly configured."
  exit 0
else
  echo "FAIL: ClientAliveInterval and/or ClientAliveCountMax are not correctly configured."
  exit 1
fi
