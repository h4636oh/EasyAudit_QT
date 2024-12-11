#!/usr/bin/env bash
{
 exit_status=0
 while read -r l_count l_group; do
 if [ "$l_count" -gt 1 ]; then
 echo -e "Duplicate Group: \"$l_group\" Groups: \"$(awk -F: '($1 == n) { print $1 }' n=$l_group /etc/group | xargs)\""
 exit_status=1
 fi
 done < <(cut -f1 -d":" /etc/group | sort -n | uniq -c)
 exit $exit_status
}

