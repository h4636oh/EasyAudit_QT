#!/bin/bash

# Check if prelink is installed
if dpkg-query -s prelink &> /dev/null; then
  echo "prelink is installed"
  exit 1
else
  echo "prelink is not installed"
fi
