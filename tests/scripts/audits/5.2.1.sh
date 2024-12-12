#!/usr/bin/env bash

# Check if sudo is installed
if dpkg-query -s sudo &>/dev/null; then
  echo "PASS: sudo is installed."
  exit 0
# Check if sudo-ldap is installed
elif dpkg-query -s sudo-ldap &>/dev/null; then
  echo "PASS: sudo-ldap is installed."
  exit 0
else
  echo "FAIL: Neither sudo nor sudo-ldap is installed."
  exit 1
fi
