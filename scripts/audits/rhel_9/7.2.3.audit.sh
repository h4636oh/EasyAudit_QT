#!/usr/bin/env bash
{
    a_passwd_group_gid=($(awk -F: '{print $4}' /etc/passwd | sort -u))
    a_group_gid=($(awk -F: '{print $3}' /etc/group | sort -u))
    a_passwd_group_diff=($(printf '%s\n' "${a_group_gid[@]}" "${a_passwd_group_gid[@]}" | sort | uniq -u))

    # Check for users with GIDs that do not exist in /etc/group
    found_issue=false
    while IFS= read -r l_gid; do
        awk -F: '($4 == '"$l_gid"') {print " - User: \"" $1 "\" has GID: \"" $4 "\" which does not exist in /etc/group"}' /etc/passwd
        found_issue=true
    done < <(printf '%s\n' "${a_passwd_group_gid[@]}" "${a_passwd_group_diff[@]}" | sort | uniq -D | uniq)

    # Check if any output was produced, indicating an audit failure
    if [ "$found_issue" = true ]; then
        echo "Audit failed: There are users with GIDs that do not exist in /etc/group."
        exit 1
    else
        echo "**PASS** There are NO users with GIDs that do not exist in /etc/group. "
    fi

    unset a_passwd_group_gid
    unset a_group_gid
    unset a_passwd_group_diff
}