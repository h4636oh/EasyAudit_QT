#!/usr/bin/env bash

# Script to audit GNOME desktop environment for disabling automatic mounting of removable media
# It checks if the GDM package is installed and verifies if the automount settings are locked
# Exits 0 if audit passes, or 1 if it fails

# Function to determine the package manager and check if required packages are installed
check_gdm_installation() {
    local pkg_output=""

    if command -v dpkg-query > /dev/null 2>&1; then
        pkg_query="dpkg-query -W"
    elif command -v rpm > /dev/null 2>&1; then
        pkg_query="rpm -q"
    else
        echo "Unable to determine package manager."
        exit 1
    fi

    local pkg_list=("gdm" "gdm3")
    for pkg in "${pkg_list[@]}"; do
        if $pkg_query "$pkg" > /dev/null 2>&1; then
            pkg_output="$pkg_output\n - Package: \"$pkg\" exists on the system\n - checking configuration"
        fi
    done

    echo -e "$pkg_output"
}

# Function to check if the automount settings are locked
check_automount_lock() {
    local output=""
    local output_fail=""

    local kfd="/etc/dconf/db/$(grep -Psril '^\\h*automount\\b' /etc/dconf/db/*/ | awk -F'/' '{split($(NF-1),a,".");print a[1]}' ).d"
    local kfd2="/etc/dconf/db/$(grep -Psril '^\\h*automount-open\\b' /etc/dconf/db/*/ | awk -F'/' '{split($(NF-1),a,".");print a[1]}' ).d"

    if [[ -d "$kfd" ]]; then
        if grep -Priq '^\\h*/org/gnome/desktop/media-handling/automount\\b' "$kfd"; then
            output="$output\n - \"automount\" is locked in \"$(grep -Pril '^\\h*/org/gnome/desktop/media-handling/automount\\b' \"$kfd\")\""
        else
            output_fail="$output_fail\n - \"automount\" is not locked"
        fi
    else
        output_fail="$output_fail\n - \"automount\" is not set so it cannot be locked"
    fi

    if [[ -d "$kfd2" ]]; then
        if grep -Priq '^\\h*/org/gnome/desktop/media-handling/automount-open\\b' "$kfd2"; then
            output="$output\n - \"automount-open\" is locked in \"$(grep -Pril '^\\h*/org/gnome/desktop/media-handling/automount-open\\b' \"$kfd2\")\""
        else
            output_fail="$output_fail\n - \"automount-open\" is not locked"
            exit 1
        fi
    else
        output_fail="$output_fail\n - \"automount-open\" is not set so it cannot be locked"
    fi

    if [[ -n "$output_fail" ]]; then
        echo -e "\n- Audit Result:\n ** FAIL **\n - Reason(s) for audit failure:\n$output_fail\n"
        [ -n "$output" ] && echo -e "\n- Correctly set:\n$output\n"
        exit 1
    else
        echo -e "\n- Audit Result:\n ** PASS **\n$output\n"
        exit 0
    fi
}

# Main script execution
echo "Checking if GNOME Desktop Manager packages are installed:"
pkg_check_output=$(check_gdm_installation)

if [[ -z "$pkg_check_output" ]]; then
    echo -e " - GNOME Desktop Manager package is not installed on the system\n - Recommendation is not applicable"
    exit 0
else
    echo -e "$pkg_check_output\n"
    check_automount_lock
fi
