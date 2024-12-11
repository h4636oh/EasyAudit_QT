#!/usr/bin/env bash
{
exit_status=0
 while read -r l_count l_gid; do
 if [ "$l_count" -gt 1 ]; then
 echo -e "Duplicate GID: \"$l_gid\" Groups: \"$(awk -F: '($3 == n) { print $1 }' n=$l_gid /etc/group | xargs)\""
 exit_status=1
 fi
 done < <(cut -f3 -d":" /etc/group | sort -n | uniq -c)
 exit $exit_status
}
