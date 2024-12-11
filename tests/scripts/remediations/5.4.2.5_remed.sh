#!/usr/bin/env bash

echo "Starting remediation process..."

# Correct or justify any issues with root's PATH

# Define root's path and the restrictive permissions mask
l_pmask="0022"
l_maxperm="0755"
l_root_path="$(sudo -Hiu root env | grep '^PATH' | cut -d= -f2)"
unset a_path_loc && IFS=":" read -ra a_path_loc <<< "$l_root_path"

# 1. Remove empty directories (::)
for dir in "${a_path_loc[@]}"; do
    if [ -z "$dir" ]; then
        echo "Removing empty directory in PATH: $dir"
        # Update PATH to remove empty directories
        l_root_path=$(echo "$l_root_path" | sed 's/::/:/g')
    fi
done

# 2. Remove trailing colons (:) from PATH
if [[ "$l_root_path" =~ :$ ]]; then
    echo "Removing trailing colon from PATH"
    l_root_path="${l_root_path%:}"
fi

# 3. Remove current working directory (.)
l_root_path=$(echo "$l_root_path" | sed 's/:*\.\(:*\)/\//g')

# Update the root PATH with the corrected value
sudo -Hiu root bash -c "export PATH=\"$l_root_path\""

# 4. Check each directory in PATH for issues (non-root ownership or permissions less than 0755)
for l_path in "${a_path_loc[@]}"; do
    if [ -d "$l_path" ]; then
        l_fmode=$(stat -Lc '%#a' "$l_path")
        l_fown=$(stat -Lc '%U' "$l_path")

        # 4a. Ensure directory is owned by root
        if [ "$l_fown" != "root" ]; then
            echo "Changing ownership of directory $l_path to root"
            sudo chown root:root "$l_path"
        fi

        # 4b. Ensure directory has mode 0755 or more restrictive
        if [ $((l_fmode & l_pmask)) -gt 0 ]; then
            echo "Changing mode of directory $l_path to $l_maxperm"
            sudo chmod $l_maxperm "$l_path"
        fi
    else
        echo "$l_path is not a directory. Skipping."
        exit 1
    fi
done

echo "Remediation process complete."