#!/bin/bash

# Verify if talk is installed
if dpkg-query -s talk &>/dev/null; then
  echo "talk is installed"
  exit 1
fi

