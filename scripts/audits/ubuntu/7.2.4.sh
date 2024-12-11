#!/usr/bin/env bash

# Verify no output for group "shadow" in /etc/group
shadow_group_check=$(awk -F: '($1=="shadow") {print $NF}' /etc/group)

if [[ -z "$shadow_group_check" ]]; then
    echo "OK: No entries found for group 'shadow' in /etc/group."
else
    echo "Warning: Entries found for group 'shadow' in /etc/group:"
    echo "$shadow_group_check"
    exit 1
fi

# Verify no users have primary group as the shadow group
shadow_gid=$(getent group shadow | awk -F: '{print $3}' | xargs)
shadow_user_check=$(awk -F: '($4 == '"$shadow_gid"') {print " - user: \"" $1 "\" primary group is the shadow group"}' /etc/passwd)

if [[ -z "$shadow_user_check" ]]; then
    echo "OK: No users have the primary group as the shadow group."
else
    echo "Warning: Some users have the primary group as the shadow group:"
    echo "$shadow_user_check"
    exit 1
fi

