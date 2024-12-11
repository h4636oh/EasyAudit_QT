#!/usr/bin/env bash
{
    # Define valid shells pattern (excluding nologin)
    l_valid_shells="^($(awk -F\/ '$NF != \"nologin\" {print}' /etc/shells | sed -r -e 's/^\//\\\//g' | paste -s -d '|' - ))$"

    # Iterate through the list of users
    while IFS= read -r l_user; do
        # Check if the user is not root and has an invalid shell
        passwd -S "$l_user" | awk '$2 !~ /^L/ {system ("usermod -L " $1)}'
    done < <(awk -v pat="$l_valid_shells" -F: '($1 != "root" && $(NF) !~ pat) {print $1}' /etc/passwd)
}