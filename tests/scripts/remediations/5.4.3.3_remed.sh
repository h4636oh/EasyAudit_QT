#!/usr/bin/env bash
{
l_output="" l_output2="" l_out=""
file_umask_chk()
{
if grep -Psiq --
'^\h*umask\h+(0?[0-7][2-
7]7|u(=[rwx]{0,3}),g=([rx]{0,2}),o=)(\h*#.*)?$' "$l_file"; then
l_out="$l_out\n - umask is set correctly in \"$l_file\""
elif grep -Psiq --
'^\h*umask\h+(([0-7][0-7][01][0-7]\b|[0-7][0-7][0-
7][0-6]\b)|([0-7][01][0-7]\b|[0-7][0-7][0-
6]\b)|(u=[rwx]{1,3},)?(((g=[rx]?[rx]?w[rx]?[rx]?\b)(,o=[rwx]{1,3})?)|((g=[wrx
]{1,3},)?o=[wrx]{1,3}\b)))' "$l_file"; then
l_output2="$l_output2\n - \"$l_file\""
fi
}
while IFS= read -r -d $'\0' l_file; do
file_umask_chk
done < <(find /etc/profile.d/ -type f -name '*.sh' -print0)
[ -n "$l_out" ] && l_output="$l_out"
l_file="/etc/profile" && file_umask_chk
l_file="/etc/bashrc" && file_umask_chk
l_file="/etc/bash.bashrc" && file_umask_chk
l_file="/etc/pam.d/postlogin"
if grep -Psiq
'^\h*session\h+[^#\n\r]+\h+pam_umask\.so\h+([^#\n\r]+\h+)?umask=(([0-7][0-
7][01][0-7]\b|[0-7][0-7][0-7][0-6]\b)|([0-7][01][0-7]\b))' "$l_file"; then
l_output2="$l_output2\n - \"$l_file\""
fi
l_file="/etc/login.defs" && file_umask_chk
l_file="/etc/default/login" && file_umask_chk
if [ -z "$l_output2" ]; then
echo -e " - No files contain a UMASK that is not restrictive enough\n
No UMASK updates required to existing files"
else
echo -e "\n - UMASK is not restrictive enough in the following
file(s):$l_output2\n\n- Remediation Procedure:\n - Update these files and
comment out the UMASK line\n or update umask to be \"0027\" or more
restrictive"
fi
if [ -n "$l_output" ]; then
echo -e "$l_output"
else
echo -e " - Configure UMASK in a file in the \"/etc/profile.d/\"
directory ending in \".sh\"\n\n Example Command (Hash to represent being
run at a root prompt):\n\n# printf '%s\\\n' \"umask 027\" >
/etc/profile.d/50-systemwide_umask.sh\n"
exit 1
fi
}