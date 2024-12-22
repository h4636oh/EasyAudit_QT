#!/usr/bin/env bash

# Check if timestamp_timeout is configured in /etc/sudoers*
timestamp_timeout=$(grep -roP "timestamp_timeout=\K[0-9]*" /etc/sudoers*)

if [[ -z "$timestamp_timeout" ]]; then
  echo "No timestamp_timeout configured in /etc/sudoers*. The default is 15 minutes."
  # Check the default timeout
  sudo_timeout=$(sudo -V | grep "Authentication timestamp timeout:")
  echo "$sudo_timeout"
else
  for timeout in $timestamp_timeout; do
    if (( timeout <= 15 )); then
      echo "timestamp_timeout is set to $timeout minutes, which is within the limit."
    else
      echo "timestamp_timeout is set to $timeout minutes, which exceeds the 15-minute limit."
      exit
    fi
  done
fi

