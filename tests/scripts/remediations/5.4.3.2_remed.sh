#!/usr/bin/env bash
{
    # Define the maximum allowed TMOUT value
    TMOUT_VALUE=900
    
    # Backup the important files before editing
    cp /etc/profile /etc/profile.bak
    cp /etc/bashrc /etc/bashrc.bak
    for file in /etc/profile.d/*.sh; do
        cp "$file" "$file.bak"
    done

    # Function to update TMOUT in a given file
    update_tmout() {
        local file="$1"
        if grep -q "^TMOUT=" "$file"; then
            # Remove any existing TMOUT setting
            sed -i '/^TMOUT=/d' "$file"
        fi
        # Add the correct TMOUT setting
        echo -e "TMOUT=$TMOUT_VALUE\nreadonly TMOUT\nexport TMOUT" >> "$file"
        echo "Updated TMOUT in $file"
    }

    # Update /etc/profile
    update_tmout /etc/profile

    # Update /etc/bashrc
    update_tmout /etc/bashrc

    # Update all scripts in /etc/profile.d/
    for file in /etc/profile.d/*.sh; do
        update_tmout "$file"
    done

    echo "TMOUT has been updated in the specified files."
}