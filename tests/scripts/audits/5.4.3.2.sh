#!/usr/bin/env bash

{
  output1=""
  output2=""

  # Check if /etc/bashrc exists and set its value
  [ -f /etc/bashrc ] && BRC="/etc/bashrc"

  # Loop through files to check for correct TMOUT settings
  for f in "$BRC" /etc/profile /etc/profile.d/*.sh; do
    if grep -Pq '^\s*([^#]+\s+)?TMOUT=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9])\b' "$f" &&
       grep -Pq '^\s*([^#]+;\s*)?readonly\s+TMOUT(\s+|\s*;|\s*$|=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9]))\b' "$f" &&
       grep -Pq '^\s*([^#]+;\s*)?export\s+TMOUT(\s+|\s*;|\s*$|=(900|[1-8][0-9][0-9]|[1-9][0-9]|[1-9]))\b' "$f"; then
      output1="$f"
    fi
  done

  # Check for incorrect TMOUT configurations
  grep -Pq '^\s*([^#]+\s+)?TMOUT=(9[0-9][1-9]|9[1-9][0-9]|0+|[1-9]\d{3,})\b' /etc/profile /etc/profile.d/*.sh "$BRC" && output2=$(grep -Ps '^\s*([^#]+\s+)?TMOUT=(9[0-9][1-9]|9[1-9][0-9]|0+|[1-9]\d{3,})\b' /etc/profile /etc/profile.d/*.sh $BRC)

  # Output results based on whether the configuration is correct
  if [ -n "$output1" ] && [ -z "$output2" ]; then
    echo -e "\nPASSED\n\nTMOUT is correctly configured in: \"$output1\"\n"
    exit 0  # Exit with success
  else
    if [ -z "$output1" ]; then
      echo -e "\nFAILED\n\nTMOUT is not configured correctly\n"
      exit 1  # Exit with failure if TMOUT is not set
    fi
    if [ -n "$output2" ]; then
      echo -e "\nFAILED\n\nTMOUT is incorrectly configured in: \"$output2\"\n"
      exit 1  # Exit with failure if TMOUT is set incorrectly
    fi
  fi
}
