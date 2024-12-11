#!/usr/bin/env bash

# This script audits the permissions and ownership of /etc/ssh/sshd_config
# and files ending in .conf in the /etc/ssh/sshd_config.d directory.
# The goal is to ensure these files are secure from unauthorized access.

perm_mask='0177'  # An octal mask for permissible file modes
maxperm="$(printf '%o' $((0777 & ~$perm_mask)))"

SSHD_FILES_AUDIT() {
  local l_file="$1"
  local l_output2=""

  while IFS=: read -r l_mode l_user l_group; do
    # Check if file permissions and ownership are correct
    [ $(( l_mode & perm_mask )) -gt 0 ] && l_output2="$l_output2\n - Is mode: \"$l_mode\" should be: \"$maxperm\" or more restrictive"
    [ "$l_user" != "root" ] && l_output2="$l_output2\n - Is owned by \"$l_user\" should be owned by \"root\""
    [ "$l_group" != "root" ] && l_output2="$l_output2\n - Is group owned by \"$l_group\" should be group owned by \"root\""

    if [ -n "$l_output2" ]; then
      echo -e "\n - File: \"$l_file\":$l_output2\n"
      return 1
    else
      echo -e "\n - File: \"$l_file\":\n - Correct: mode ($l_mode), owner ($l_user), and group owner ($l_group) configured"
    fi
  done < <(stat -Lc '%#a:%U:%G' "$l_file")

  return 0
}

audit_files() {
  local failed=0

  if [ -e "/etc/ssh/sshd_config" ]; then
    SSHD_FILES_AUDIT "/etc/ssh/sshd_config" || failed=1
  fi

  while IFS= read -r -d $'\0' l_file; do
    [ -e "$l_file" ] && SSHD_FILES_AUDIT "$l_file" || failed=1
  done < <(find /etc/ssh/sshd_config.d -type f -print0 2>/dev/null)

  return $failed
}

audit_files
audit_result=$?

if [ $audit_result -eq 0 ]; then
  echo -e "\n- Audit Result:\n *** PASS ***\n- All files have been correctly configured.\n"
  exit 0
else
  echo -e "\n- Audit Result:\n ** FAIL **\n- * Reasons for audit failure * are listed above.\n"
  exit 1
fi

# This script audits the permissions and ownership of SSH configuration files located at `/etc/ssh/sshd_config` and within the `/etc/ssh/sshd_config.d` directory. It ensures that these files have the correct permissions `0600` or more restrictive, are owned by the user `root`, and are group-owned by the group `root`. If any file fails to meet these criteria, it outputs the specific reasons and exits with a status of `1` indicating failure. If all files comply, it exits with a status of `0`, indicating a successful audit.