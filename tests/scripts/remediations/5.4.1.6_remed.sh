#!/usr/bin/env bash

echo "Checking for users with a future password change date..."

# Loop through each user with a password entry in /etc/shadow
while IFS= read -r user; do
    # Get the last password change date
    last_change=$(date -d "$(chage --list "$user" | grep '^Last password change' | cut -d: -f2 | grep -v 'never$')" +%s 2>/dev/null)
    current_date=$(date +%s)

    # Check if the last password change date is in the future
    if [[ "$last_change" -gt "$current_date" ]]; then
        echo "User \"$user\" has a future last password change date: $(chage --list "$user" | grep '^Last password change' | cut -d: -f2)"
        
        # Lock the account and expire the password
        echo "Locking account and expiring the password for \"$user\"..."
        passwd -l "$user"
        chage -E 0 "$user"

        if [[ $? -eq 0 ]]; then
            echo "Account for \"$user\" locked and password expired successfully."
        else
            echo "Failed to remediate account for \"$user\". Manual intervention required."
        fi
    fi
done < <(awk -F: '$2~/^\$.+\$/{print $1}' /etc/shadow)

echo "Remediation process complete."