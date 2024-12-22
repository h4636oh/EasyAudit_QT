#!/usr/bin/env bash

if dpkg-query -s ufw &>/dev/null; then
  echo "ufw is installed"
else
  echo "ufw is not installed"
  exit 1
fi

