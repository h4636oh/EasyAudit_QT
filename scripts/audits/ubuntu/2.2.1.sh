#!/bin/bash

# Verify if nis is installed
if dpkg-query -s nis &>/dev/null; then
  echo "nis is installed"
  exit 1
fi

