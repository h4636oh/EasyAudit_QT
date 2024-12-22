#!/usr/bin/env bash

if dpkg-query -s iptables-persistent &>/dev/null; then
  echo "iptables-persistent is installed"
  exit 1
else
  echo "iptables-persistent is not installed"
fi

