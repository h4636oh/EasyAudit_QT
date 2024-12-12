#!/usr/bin/env bash

# Audit script to verify that the GDM login banner is configured.
# This script audits the configuration of the GDM login banner to ensure compliance 
# with the requirement of having a legal warning message.
# If packages are not installed, it will indicate that GDM-related configuration is not applicable, resulting in a pass.

# Function: Utility command to check if a package exists
check_package() {
  if command -v dpkg-query > /dev/null 2>&1; then
    dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep "install ok installed" > /dev/null 2>&1
  elif command -v rpm > /dev/null 2>&1; then
    rpm -q "$1" > /dev/null 2>&1
  else
    return 1
  fi
}

# Check if GDM or GDM3 packages are installed
l_pkgoutput=""
packages=("gdm" "gdm3")
for pkg in "${packages[@]}"; do
  if check_package "$pkg"; then
    l_pkgoutput+="\n - Package: \"$pkg\" exists and is installed."
  fi
done

if [ -n "$l_pkgoutput" ]; then
  l_output=""
  l_output2=""
  echo -e "$l_pkgoutput"
  
  # Check for banner-message-enable setting in dconf
  l_gdmfile="$(grep -Prils '^\\h*banner-message-enable\\b' /etc/dconf/db/*.d)"
  
  if [ -n "$l_gdmfile" ]; then
    l_gdmprofile="$(awk -F\\/ '{split($(NF-1),a,".");print a[1]}' <<< "$l_gdmfile")"
    
    # Check if banner-message-enable is true
    if grep -Pisq '^\\h*banner-message-enable=true\\b' "$l_gdmfile"; then
      l_output+="\n - The \"banner-message-enable\" option is enabled in \"$l_gdmfile\"."
    else
      l_output2+="\n - The \"banner-message-enable\" option is not enabled."
    fi

    # Check for banner-message-text
    l_lsbt="$(grep -Pios '^\\h*banner-message-text=.*$' "$l_gdmfile")"
    if [ -n "$l_lsbt" ]; then
      l_output+="\n - The \"banner-message-text\" option is set in \"$l_gdmfile\".\n - banner-message-text is set to: \"$l_lsbt\""
    else
      l_output2+="\n - The \"banner-message-text\" option is not set."
    fi

    # Check profile existence
    if grep -Pq "^\\h*system-db:$l_gdmprofile" /etc/dconf/profile/"$l_gdmprofile"; then
      l_output+="\n - The \"$l_gdmprofile\" profile exists."
    else
      l_output2+="\n - The \"$l_gdmprofile\" profile doesn't exist."
    fi

    if [ -f "/etc/dconf/db/$l_gdmprofile" ]; then
      l_output+="\n - The \"$l_gdmprofile\" profile exists in the dconf database."
    else
      l_output2+="\n - The \"$l_gdmprofile\" profile doesn't exist in the dconf database."
    fi
  else
    l_output2+="\n - The \"banner-message-enable\" option isn't configured."
  fi

  # Report audit results
  if [ -z "$l_output2" ]; then
    echo -e "\n- Audit Result:\n ** PASS **\n$l_output\n"
    exit 0
  else
    echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$l_output2\n"
    [ -n "$l_output" ] && echo -e "\n- Correctly set:\n$l_output\n"
    exit 1
  fi
else
  echo -e "\n\n - GNOME Desktop Manager isn't installed\n - Recommendation is Not Applicable\n- Audit result:\n *** PASS ***\n"
  exit 0
fi
