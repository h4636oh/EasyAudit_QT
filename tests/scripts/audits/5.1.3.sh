#!/usr/bin/env bash

{
  l_output=""
  l_output2=""
  l_pmask="0133"  # Mask to check if write or execute permissions are granted for group or others
  l_maxperm="$(printf '%o' $(( 0777 & ~$l_pmask )) )"  # Maximum allowed permissions (644 or more restrictive)

  FILE_CHK() {
    while IFS=: read -r l_file_mode l_file_owner l_file_group; do
      l_out2=""
      
      # Check if the file mode has write or execute permissions for group or others
      if [ $(( $l_file_mode & $l_pmask )) -gt 0 ]; then
        l_out2="$l_out2\n - Mode: \"$l_file_mode\" should be mode: \"$l_maxperm\" or more restrictive"
      fi

      # Check if the file is owned by root
      if [ "$l_file_owner" != "root" ]; then
        l_out2="$l_out2\n - Owned by: \"$l_file_owner\" should be owned by \"root\""
      fi

      # Check if the group owner is root
      if [ "$l_file_group" != "root" ]; then
        l_out2="$l_out2\n - Owned by group \"$l_file_group\" should be group owned by: \"root\""
      fi

      # Output results based on the checks
      if [ -n "$l_out2" ]; then
        l_output2="$l_output2\n - File: \"$l_file\"$l_out2"
      else
        l_output="$l_output\n - File: \"$l_file\"\n - Correct: mode: \"$l_file_mode\", owner: \"$l_file_owner\", and group owner: \"$l_file_group\" configured"
      fi
    done < <(stat -Lc '%#a:%U:%G' "$l_file")
  }

  # Iterate over the SSH public key files and perform the checks
  while IFS= read -r -d $'\0' l_file; do
    if ssh-keygen -lf &>/dev/null "$l_file"; then
      if file "$l_file" | grep -Piq '\bopenssh\h+([^#\n\r]+\h+)?public\h+key\b'; then
        FILE_CHK
      fi
    fi
  done < <(find -L /etc/ssh -xdev -type f -print0 2>/dev/null)

  # Print the results of the audit
  if [ -z "$l_output2" ]; then
    if [ -z "$l_output" ]; then
      l_output="\n - No openSSH public keys found"
    fi
    echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured * :$l_output"
    exit 0  # Exit with success code (0) if everything is correctly configured
  else
    echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure * :$l_output2\n"
    if [ -n "$l_output" ]; then
      echo -e "\n - * Correctly configured * :\n$l_output\n"
    fi
    exit 1  # Exit with failure code (1) if there are issues with the configuration
  fi
}
