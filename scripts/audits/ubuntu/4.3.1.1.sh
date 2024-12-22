#!/usr/bin/env bash

# Check if iptables is installed
if dpkg-query -s iptables &>/dev/null; then
  echo "iptables is installed"
else
  echo "iptables is not installed"
  exit 1
fi

# Check if iptables-persistent is installed
if dpkg-query -s iptables-persistent &>/dev/null; then
  echo "iptables-persistent is installed"
else
  echo "iptables-persistent is not installed"
  exit 1
fi

