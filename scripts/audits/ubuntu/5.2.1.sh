#!/usr/bin/env bash

# Check if sudo is installed
if dpkg-query -s sudo &>/dev/null; then
  echo "sudo is installed"
else
  echo "sudo is not installed"
  exit 1
fi

# Check if sudo-ldap is installed
if dpkg-query -s sudo-ldap &>/dev/null; then
  echo "sudo-ldap is installed"
else
  echo "sudo-ldap is not installed"
  exit 1
fi

