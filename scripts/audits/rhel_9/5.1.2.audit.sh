#!/usr/bin/env bash

# This script audits SSH private host key files to ensure they are configured correctly
# regarding ownership and permissions as per the provided guidelines.

# Initialize output variables
output_pass=""
output_fail=""

# Determine the designated ssh group name
ssh_group_name=$(awk -F: '($1 ~ /^(ssh_keys|_?ssh)$/) {print $1}' /etc/group)

# Function to check file properties
check_file_properties() {
    while IFS=: read -r file_mode file_owner file_group; do
        local issues=""
        
        # Determine permission mask based on the group ownership
        [ "$file_group" = "$ssh_group_name" ] && pmask="0137" || pmask="0177"
        maxperm=$(printf '%o' $((0777 & ~$pmask)))

        # Check file permissions, ownership, and group ownership
        [ $((file_mode & pmask)) -gt 0 ] && issues="$issues\n - Mode: \"$file_mode\" should be mode: \"$maxperm\" or more restrictive"
        [ "$file_owner" != "root" ] && issues="$issues\n - Owned by: \"$file_owner\" should be owned by \"root\""
        [[ ! "$file_group" =~ ($ssh_group_name|root) ]] && issues="$issues\n - Owned by group: \"$file_group\" should be group owned by: \"$ssh_group_name\" or \"root\""

        # Append issues to the output
        if [ -n "$issues" ]; then
            output_fail="$output_fail\n - File: \"$file\"$issues"
        else
            output_pass="$output_pass\n - File: \"$file\"\n - Correct: mode: \"$file_mode\", owner: \"$file_owner\", and group owner: \"$file_group\" configured"
        fi
    done < <(stat -Lc '%#a:%U:%G' "$file")
}

# Check each file in /etc/ssh directory
while IFS= read -r -d $'\0' file; do
    if ssh-keygen -lf &>/dev/null "$file"; then
        if file "$file" | grep -Piq -- '\bopenssh\s+([^#\n\r]+\s+)?private\s+key\b'; then
            check_file_properties
        fi
    fi
done < <(find -L /etc/ssh -xdev -type f -print0 2>/dev/null)

# Display audit results
if [ -z "$output_fail" ]; then
    [ -z "$output_pass" ] && output_pass="\n - No openSSH private keys found"
    echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured *:$output_pass"
    exit 0
else
    echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :$output_fail"
    [ -n "$output_pass" ] && echo -e "\n - * Correctly configured * :$output_pass"
    exit 1
fi

### Explanation:
# - The script audits SSH private host key files in `/etc/ssh`.
# - It verifies that these files are owned by `root`, have appropriate group ownership (`root` or a designated SSH group), and confirm permissions are restrictive enough (0600 or 0640 based on the group).
# - It uses `ssh-keygen` to verify SSH keys and `stat` for file information.
# - Outputs detail files that fail the checks and those correctly configured.
# - Exits with `0` if all files pass the checks, or `1` if any file fails.