#!/usr/bin/env bash
{
exit_status=0
 while read -r l_count l_user; do
 if [ "$l_count" -gt 1 ]; then
 echo -e "Duplicate User: \"$l_user\" Users: \"$(awk -F: '($1 == n) { print $1 }' n=$l_user /etc/passwd | xargs)\""
exit_status=0
 fi
 done < <(cut -f1 -d":" /etc/group | sort -n | uniq -c)
exit $exit_status
}
