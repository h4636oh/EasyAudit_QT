#!/usr/bin/env bash

echo "Starting Audit for last password change dates..."

# Loop through each user with a password
while IFS= read -r l_user; do
  # Get the last password change date in seconds
  l_change=$(date -d "$(chage --list $l_user | grep '^Last password change' | cut -d: -f2 | grep -v 'never$')" +%s)

  # Check if the last password change date is in the future
  if [[ "$l_change" -gt "$(date +%s)" ]]; then
    echo "Fail: User: \"$l_user\" last password change was in the future on \"$(chage --list $l_user | grep '^Last password change' | cut -d: -f2)\""
  fi
done < <(awk -F: '$2~/^\$.+\$/{print $1}' /etc/shadow)

# Final audit result
echo "Audit complete. Any user with a future password change date was reported as 'Fail'."
exit 0
