#!/usr/bin/env bash

echo "Starting remediation process..."

# Files to check and update
root_bash_profile="/root/.bash_profile"
root_bashrc="/root/.bashrc"

# Function to update umask to 0027 if found in the file
update_umask() {
    local file="$1"

    if [ -f "$file" ]; then
        echo "Checking file: $file"

        # Backup original file before making changes
        cp "$file" "$file.bak"
        echo "Backup created for $file as $file.bak"

        # Check if the umask line exists
        if grep -q "umask" "$file"; then
            # Remove or comment out any existing umask lines
            sed -i '/umask/d' "$file"
            echo "Removed any existing umask lines from $file"

            # Add the new umask line (0027 or more restrictive)
            echo "umask 0027" >> "$file"
            echo "Added umask 0027 to $file"
        else
            # If no umask line exists, simply add it at the end
            echo "umask 0027" >> "$file"
            echo "Added umask 0027 to $file"
        fi
    else
        echo "$file not found, skipping..."
        exit 1
    fi
}

# Update /root/.bash_profile and /root/.bashrc
update_umask "$root_bash_profile"
update_umask "$root_bashrc"

echo "Remediation process complete."