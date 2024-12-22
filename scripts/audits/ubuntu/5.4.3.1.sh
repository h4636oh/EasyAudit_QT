#!/usr/bin/env bash

# Verify that nologin is not listed in the /etc/shells file
nologin_check=$(grep '/nologin\b' /etc/shells)

if [[ -z "$nologin_check" ]]; then
  echo "No 'nologin' entry found in /etc/shells. Configuration is correct."
else
  echo "'nologin' entry found in /etc/shells:"
  echo "$nologin_check"
  exit 1
fi

