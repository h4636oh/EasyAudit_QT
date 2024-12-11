#!/usr/bin/env bash

echo "Starting remediation to ensure reauthentication is required for privilege escalation..."

# Define sudoers files to check
sudoers_files=("/etc/sudoers" "/etc/sudoers.d/*")

# Backup the original sudoers files
backup_dir="/root/sudoers_backup_$(date +%Y%m%d%H%M%S)"
mkdir -p "$backup_dir"
echo "Backing up sudoers files to $backup_dir..."
for file in "${sudoers_files[@]}"; do
    if [ -f "$file" ]; then
        cp "$file" "$backup_dir"
        echo "Backed up: $file"
    fi
done

# Remove any occurrences of '!authenticate' tags
echo "Removing occurrences of '!authenticate' from sudoers files..."
for file in "${sudoers_files[@]}"; do
    if [ -f "$file" ]; then
        sed -i '/!authenticate/d' "$file"
        echo "Processed: $file"
    fi
done

# Validate sudoers files
echo "Validating sudoers files for syntax errors..."
visudo