#!/usr/bin/env bash

# Audit script to inspect world writable files and directories without sticky bit

l_output=""
l_output2=""
l_smask='01000'
a_file=()
a_dir=()
# Exclude certain paths from the search
a_path=(! -path "/run/user/*" -a ! -path "/proc/*" -a ! -path "*/containerd/*" -a ! -path "*/kubelet/pods/*" -a ! -path "*/kubelet/plugins/*" -a ! -path "/sys/*" -a ! -path "/snap/*")

# Loop through the mounted file systems
while IFS= read -r l_mount; do
  # Find world writable files and directories
  while IFS= read -r -d $'\0' l_file; do
    if [ -e "$l_file" ]; then
      # Add world writable files
      [ -f "$l_file" ] && a_file+=("$l_file")
      # Check directories without sticky bit and add to list
      if [ -d "$l_file" ]; then
        l_mode="$(stat -Lc '%#a' "$l_file")"
        [ ! $(( l_mode & l_smask )) -gt 0 ] && a_dir+=("$l_file")
      fi
    fi
  done < <(find "$l_mount" -xdev \( "${a_path[@]}" \) \( -type f -o -type d \) -perm -0002 -print0 2>/dev/null)
done < <(findmnt -Dkerno fstype,target | awk '($1 !~ /^s*(nfs|proc|smb|vfat|iso9660|efivarfs|selinuxfs)/ && $2 !~ /^(\/run\/user\/|\/tmp|\/var\/tmp)/){print $2}')

# Check results and prepare output
if ! (( ${#a_file[@]} > 0 )); then
  l_output="$l_output\n - No world writable files exist on the local filesystem."
else
  l_output2="$l_output2\n - There are \"$(printf '%s' "${#a_file[@]}")\" World writable files on the system.\n - The following is a list of World writable files:\n$(printf '%s\n' "${a_file[@]}")\n - end of list\n"
fi

if ! (( ${#a_dir[@]} > 0 )); then
  l_output="$l_output\n - Sticky bit is set on world writable directories on the local filesystem."
else
  l_output2="$l_output2\n - There are \"$(printf '%s' "${#a_dir[@]}")\" World writable directories without the sticky bit on the system.\n - The following is a list of World writable directories without the sticky bit:\n$(printf '%s\n' "${a_dir[@]}")\n - end of list\n"
fi

# Clean up variables
unset a_file a_dir a_path

# Audit Result
if [ -z "$l_output2" ]; then
  echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :\n$l_output\n"
  exit 0
else
  echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :\n$l_output2"
  [ -n "$l_output" ] && echo -e "- * Correctly configured * :\n$l_output\n"
  exit 1
fi
