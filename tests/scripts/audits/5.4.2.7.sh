#!/usr/bin/env bash

{
  # Get the list of valid shells (non-nologin shells)
  l_valid_shells="^($(awk -F/ '$NF != \"nologin\" {print $NF}' /etc/shells | paste -s -d '|' - ))$"

  # Get the system's minimum UID from /etc/login.defs
  l_uid_min=$(awk '/^\s*UID_MIN/{print $2}' /etc/login.defs)

  # Check for system accounts with valid login shells and store the result in a variable
  invalid_accounts=$(awk -v pat="$l_valid_shells" -v min_uid="$l_uid_min" -F: '
    ($1 !~ /^(root|halt|sync|shutdown|nfsnobody)$/ && 
    ($3 < min_uid || $3 == 65534) && 
    $NF ~ pat) {
      print "Service account: \"" $1 "\" has a valid shell: " $NF
    }
  ' /etc/passwd)

  # If invalid accounts are found, output them and exit with code 1
  if [[ -n "$invalid_accounts" ]]; then
    echo "$invalid_accounts"  # Print the found issues
    echo "Audit failed: Some system accounts have valid shells."  # Final message
    exit 1
  else
    # If everything is fine, exit silently with code 0 (no output)
    exit 0
  fi
} > /dev/null 2>&1  # Redirect all output to /dev/null
