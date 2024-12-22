#!/usr/bin/env bash

# Check if MaxStartups is set to 10:30:60 or more restrictive
max_startups=$(sshd -T | awk '$1 ~ /^\s*maxstartups/{split($2, a, ":");{if(a[1] > 10 || a[2] > 30 || a[3] > 60) print $0}}')

if [[ -z "$max_startups" ]]; then
  echo "MaxStartups is set to 10:30:60 or more restrictive."
else
  echo "MaxStartups is not restrictive enough:"
  echo "$max_startups"
  exit 1
fi

