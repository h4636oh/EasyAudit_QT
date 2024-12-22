#!/usr/bin/env bash

# Loop through each user in /etc/shadow
while IFS= read -r l_user; do
  # Get the last password change date
  l_change=$(date -d "$(chage --list $l_user | grep '^Last password change' | cut -d: -f2 | grep -v 'never$')" +%s)
  
  # Check if the last password change date is in the future
  if [[ "$l_change" -gt "$(date +%s)" ]]; then
    echo "User: \"$l_user\" last password change was \"$(chage --list $l_user | grep '^Last password change' | cut -d: -f2)\""
  fi
done < <(awk -F: '$2~/^\$.+\$/{print $1}' /etc/shadow)

