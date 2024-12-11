#!/usr/bin/env bash

# Verify /etc/security/opasswd is mode 600 or more restrictive, Uid is 0/root and Gid is 0/root if it exists
if [ -e "/etc/security/opasswd" ]; then
    opasswd_check=$(stat -Lc '%n Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/security/opasswd)
    echo "$opasswd_check"
else
    echo "Nothing is returned for /etc/security/opasswd"
fi

# Verify /etc/security/opasswd.old is mode 600 or more restrictive, Uid is 0/root and Gid is 0/root if it exists
if [ -e "/etc/security/opasswd.old" ]; then
    opasswd_old_check=$(stat -Lc '%n Access: (%#a/%A) Uid: ( %u/ %U) Gid: ( %g/ %G)' /etc/security/opasswd.old)
    echo "$opasswd_old_check"
else
    echo "Nothing is returned for /etc/security/opasswd.old"
    exit 1
fi

