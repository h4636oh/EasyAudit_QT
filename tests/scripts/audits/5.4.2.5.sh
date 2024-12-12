#!/usr/bin/env bash

# Initialize variables
l_output2=""
l_pmask="0022"
l_maxperm="$(printf '%o' $(( 0777 & ~$l_pmask )) )"
l_root_path="$(sudo -Hiu root env | grep '^PATH' | cut -d= -f2)"
unset a_path_loc && IFS=":" read -ra a_path_loc <<< "$l_root_path"

# Check for empty directories, trailing colons, or current working directory in root's PATH
grep -q "::" <<< "$l_root_path" && l_output2="$l_output2\n - root's path contains an empty directory (::)"
grep -Pq ":\h*$" <<< "$l_root_path" && l_output2="$l_output2\n - root's path contains a trailing colon (:)"
grep -Pq '(\h+|:)\.(:|\h*$)' <<< "$l_root_path" && l_output2="$l_output2\n - root's path contains the current working directory (.)"

# Loop through each directory in root's PATH
while read -r l_path; do
  if [ -d "$l_path" ]; then
    # Check directory ownership and permissions
    while read -r l_fmode l_fown; do
      [ "$l_fown" != "root" ] && l_output2="$l_output2\n - Directory: \"$l_path\" is owned by: \"$l_fown\", should be owned by \"root\""
      [ $(( $l_fmode & $l_pmask )) -gt 0 ] && l_output2="$l_output2\n - Directory: \"$l_path\" has mode: \"$l_fmode\", should be mode: \"$l_maxperm\" or more restrictive"
    done <<< "$(stat -Lc '%#a %U' "$l_path")"
  else
    l_output2="$l_output2\n - \"$l_path\" is not a directory"
  fi
done <<< "$(printf "%s\n" "${a_path_loc[@]}")"

# Output the result
if [ -z "$l_output2" ]; then
  echo -e "\n- Audit Result:\n *** PASS ***\n - Root's path is correctly configured\n"
else
  echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :\n$l_output2\n"
fi
