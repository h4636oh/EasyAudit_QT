#!/bin/bash

# Verify if rsh-client is installed
if dpkg-query -s rsh-client &>/dev/null; then
  echo "rsh-client is installed"
  exit 1
fi

