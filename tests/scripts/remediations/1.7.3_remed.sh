#!/usr/bin/env bash
{
 l_gdmprofile="gdm"
 if [ ! -f "/etc/dconf/profile/$l_gdmprofile" ]; then
 echo "Creating profile \"$l_gdmprofile\""
 echo -e "user-db:user\nsystem-db:$l_gdmprofile\nfiledb:/usr/share/$l_gdmprofile/greeter-dconf-defaults" > /etc/dconf/profile/$l_gdmprofile
 fi
 if [ ! -d "/etc/dconf/db/$l_gdmprofile.d/" ]; then
 echo "Creating dconf database directory \"/etc/dconf/db/$l_gdmprofile.d/\""
 mkdir /etc/dconf/db/$l_gdmprofile.d/
 fi
 if ! grep -Piq '^\h*disable-user-list\h*=\h*true\b' /etc/dconf/db/$l_gdmprofile.d/*; then
 echo "creating gdm keyfile for machine-wide settings"
 if ! grep -Piq -- '^\h*\[org\/gnome\/login-screen\]' /etc/dconf/db/$l_gdmprofile.d/*; then
 echo -e "\n[org/gnome/login-screen]\n# Do not show the user list\ndisable-user-list=true" >> /etc/dconf/db/$l_gdmprofile.d/00-loginscreen
 else
 sed -ri '/^\s*\[org\/gnome\/login-screen\]/ a\# Do not show the user list\ndisable-user-list=true' $(grep -Pil -- '^\h*\[org\/gnome\/loginscreen\]' /etc/dconf/db/$l_gdmprofile.d/*)
 fi
 fi
 dconf update
}

