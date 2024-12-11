#!/usr/bin/env bash

# Function to audit the /etc/motd and /etc/motd.d/* files for any system information.
audit_motd() {
  local l_output=""
  local l_output2=""
  local a_files=()
  
  # Iterate through MOTD files
  for l_file in /etc/motd{,.d/*}; do
    # Check for system information in the files
    if grep -Psqi -- "(\\\\\\v|\\\\\\r|\\\\\\m|\\\\\\s|\\b$(grep ^ID= /etc/os-release | cut -d= -f2 | sed -e 's/"//g')\\b)" "$l_file"; then
      l_output2="$l_output2\n - File: \"$l_file\" includes system information"
    else
      a_files+=("$l_file")
    fi
  done

  # Provide manual check instructions if necessary
  if [ "${#a_files[@]}" -gt 0 ]; then
    echo -e "\n- ** Please review the following files and verify their contents follow local site policy **\n"
    printf '%s\n' "${a_files[@]}"
  elif [ -z "$l_output2" ]; then
    echo -e "- ** No MOTD files with any size were found. Please verify this conforms to local site policy ** -"
  fi

  # Output audit results
  if [ -z "$l_output2" ]; then
    l_output=" - No MOTD files include system information"
    echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
    exit 0
  else
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
    exit 1
  fi
}

# Start the audit function
audit_motd

# Script Explanation:
# - The script audits files (`/etc/motd` and `/etc/motd.d/*`) to check for any system information indicators (`\v`, `\r`, `\m`, `\s`).
# - If system information is found, it marks the audit as failed and lists the offending files.
# - It prompts the user to review files if no violations are found, ensuring the site's policy is followed.
# - The script exits with code 0 if the audit passes, or 1 if it fails.