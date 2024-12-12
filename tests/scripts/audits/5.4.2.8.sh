#!/usr/bin/env bash
{
  # Get the list of valid shells (non-nologin shells)
  l_valid_shells="^($(awk -F/ '$NF != "nologin" {print $NF}' /etc/shells | paste -s -d '|' - ))$"

  # Loop through each user and check if they have a valid login shell and whether the account is locked
  while IFS= read -r l_user; do
    # Check if the account is locked and does not have a valid shell
    passwd -S "$l_user" | awk '$2 !~ /^L/ {print "Account: \"" $1 "\" does not have a valid login shell and is not locked"}'
  done < <(awk -v pat="$l_valid_shells" -F: '($1 != "root" && $NF !~ pat) {print $1}' /etc/passwd)
}
