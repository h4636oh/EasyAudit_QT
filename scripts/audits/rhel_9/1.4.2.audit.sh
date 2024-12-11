#!/usr/bin/env bash

# This script audits the permissions and ownership of grub configuration files
# on systems using either UEFI or BIOS to ensure they are securely configured.

audit_grub_files() {
  local output_pass=""
  local output_fail=""

  # Function to check file mode, user, and group
  file_check() {
    local file="$1"
    local mode user group
    IFS=' ' read -r mode user group <<< "$(stat -Lc '%#a %U %G' "$file")"
    
    # Define the permission mask based on the directory for the UEFI or BIOS
    local mask
    if [[ "$(dirname "$file")" =~ ^/boot/efi/EFI ]]; then
      mask="0077"  # UEFI
    else
      mask="0177"  # BIOS
    fi

    # Calculate the maximum permissive mode
    local maxmode
    maxmode=$(printf '%o' $((0777 & ~$mask)))

    # Permission check
    if (( mode & mask )); then
      output_fail+="\n - File: \"$file\" - Has mode \"$mode\" but should be \"$maxmode\" or more restrictive"
    else
      output_pass+="\n - File: \"$file\" - Mode \"$mode\" is correctly set"
    fi

    # Ownership checks
    if [[ "$user" != "root" ]]; then
      output_fail+="\n - File: \"$file\" - Owned by user \"$user\", should be \"root\""
    else
      output_pass+="\n - File: \"$file\" - Owned by user \"$user\" correctly"
    fi

    if [[ "$group" != "root" ]]; then
      output_fail+="\n - File: \"$file\" - Group-owned by \"$group\", should be \"root\""
    else
      output_pass+="\n - File: \"$file\" - Group ownership correctly set to \"$group\""
    fi
  }

  # Iterate over grub configuration files found
  while IFS= read -r -d '' file; do
    file_check "$file"
  done < <(find /boot -type f \( -name 'grub*' -o -name 'user.cfg' \) -print0)

  # Output results
  if [[ -z "$output_fail" ]]; then
    echo -e "\n- Audit Result:\n *** PASS ***\n - * Correctly set * :$output_pass\n"
    exit 0
  else
    echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :$output_fail\n"
    [[ -n "$output_pass" ]] && echo -e " - * Correctly set * :$output_pass\n"
    exit 1
  fi
}

# Run the audit
audit_grub_files