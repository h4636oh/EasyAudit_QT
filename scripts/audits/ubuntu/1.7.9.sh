#!/usr/bin/env bash
{
 # Check if GNOME Desktop Manager is installed. If package isn't installed, recommendation is Not Applicable\n
 # determine system's package manager
 l_pkgoutput=""
 if command -v dpkg-query &> /dev/null; then
 l_pq="dpkg-query -s"
 elif command -v rpm &> /dev/null; then
 l_pq="rpm -q"
 fi
 # Check if GDM is installed
 l_pcl="gdm gdm3" # Space separated list of packages to check
 for l_pn in $l_pcl; do
 $l_pq "$l_pn" &> /dev/null && l_pkgoutput="$l_pkgoutput\n - Package: \"$l_pn\" exists on the system\n - checking configuration"
 done
 # Search /etc/dconf/db/ for [org/gnome/desktop/media-handling] settings)
 l_desktop_media_handling=$(grep -Psir -- '^\h*\[org/gnome/desktop/mediahandling\]' /etc/dconf/db/*)
 if [[ -n "$l_desktop_media_handling" ]]; then
 l_output="" l_output2=""
 l_autorun_setting=$(grep -Psir -- '^\h*autorun-never=true\b' /etc/dconf/db/local.d/*)
 # Check for auto-run setting
 if [[ -n "$l_autorun_setting" ]]; then
 l_output="$l_output\n - \"autorun-never\" setting found"
 else
 l_output2="$l_output2\n - \"autorun-never\" setting not found"
 fi 
 else
 l_output="$l_output\n - [org/gnome/desktop/media-handling] setting not found in /etc/dconf/db/*"
 fi 
 # Report results. If no failures output in l_output2, we pass[ -n "$l_pkgoutput" ] && echo -e "\n$l_pkgoutput"
 if [ -z "$l_output2" ]; then
 echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
 else
 echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
 [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
 exit 1
 fi
}

