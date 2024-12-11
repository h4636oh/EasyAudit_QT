#!/bin/bash
[ -e "/etc/security/opasswd" ] && chmod u-x,go-rwx /etc/security/opasswd
[ -e "/etc/security/opasswd" ] && chown root:root /etc/security/opasswd
[ -e "/etc/security/opasswd.old" ] && chmod u-x,go-rwx
[ -e "/etc/security/opasswd.old" ] && chown root:root
