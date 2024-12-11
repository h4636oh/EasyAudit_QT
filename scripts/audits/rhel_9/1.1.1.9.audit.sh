#!/usr/bin/env bash

# Audit script to check unused filesystem kernel modules, adhering to CVE vulnerability concerns.

# Arrays to store different sets of kernel modules and configurations
a_output=()
a_output2=()
a_modprope_config=()
a_excluded=()
a_available_modules=()

# List of modules to ignore as they are common and presumably not a threat
a_ignore=("xfs" "vfat" "ext2" "ext3" "ext4")

# List of modules that have associated CVEs
a_cve_exists=("afs" "ceph" "cifs" "exfat" "ext" "fat" "fscache" "fuse" "gfs2" "nfs_common" "nfsd" "smbfs_common")

# Function to check individual modules against configuration and loading state
f_module_chk() {
    l_out2="" 
    # Check if the current module has a CVE
    grep -Pq -- "\\b$l_mod_name\\b" <<< "${a_cve_exists[*]}" && l_out2=" <- CVE exists!"
    
    # Check if the module is not blacklisted or if "install /bin/false" is not set
    if ! grep -Pq -- '\\bblacklist\\h+'"${l_mod_name}"'\\b' <<< "${a_modprope_config[*]}"; then
        a_output2+=(" - Kernel module: \"$l_mod_name\" is not fully disabled $l_out2")
    elif ! grep -Pq -- '\\binstall\\h+'"${l_mod_name}"'\\h+\\/bin\\/(false|true)\\b' <<< "${a_modprope_config[*]}"; then
        a_output2+=(" - Kernel module: \"$l_mod_name\" is not fully disabled $l_out2")
    fi
    
    # Check if the module is currently loaded
    if lsmod | grep "$l_mod_name" &> /dev/null; then
        a_output2+=(" - Kernel module: \"$l_mod_name\" is loaded" "")
    fi
}

# Gather all available filesystem modules
while IFS= read -r -d '' l_module_dir; do
    a_available_modules+=("$(basename "$l_module_dir")")
done < <(find "$(readlink -f /lib/modules/"$(uname -r)"/kernel/fs)" -mindepth 1 -maxdepth 1 -type d ! -empty -print0)

# Gather mounted filesystem modules and check against CVEs and common modules
while IFS= read -r l_exclude; do
    if grep -Pq -- "\\b$l_exclude\\b" <<< "${a_cve_exists[*]}"; then
        a_output2+=(" - ** WARNING: kernel module: \"$l_exclude\" has a CVE and is currently mounted! **")
    elif grep -Pq -- "\\b$l_exclude\\b" <<< "${a_available_modules[*]}"; then
        a_output+=(" - Kernel module: \"$l_exclude\" is currently mounted - do NOT unload or disable")
    fi
    ! grep -Pq -- "\\b$l_exclude\\b" <<< "${a_ignore[*]}" && a_ignore+=("$l_exclude")
done < <(findmnt -knD | awk '{print $2}' | sort -u)

# Collect modprobe configuration related to blacklisting and disabling modules
while IFS= read -r l_config; do
    a_modprope_config+=("$l_config")
done < <(modprobe --showconfig | grep -P '^\\h*(blacklist|install)')

# Check through all available filesystem modules
for l_mod_name in "${a_available_modules[@]}"; do
    [[ "$l_mod_name" =~ overlay ]] && l_mod_name="${l_mod_name::-2}"
    if grep -Pq -- "\\b$l_mod_name\\b" <<< "${a_ignore[*]}"; then
        a_excluded+=(" - Kernel module: \"$l_mod_name\"")
    else
        f_module_chk
    fi
done

# Output the results of the audit
if [ "${#a_output2[@]}" -le 0 ]; then
    printf '%s\n' "" " - No unused filesystem kernel modules are enabled" "${a_output[@]}" ""
    exit 0
else
    printf '%s\n' "" "-- Audit Result: --" " ** REVIEW the following **" "${a_output2[@]}"
    [ "${#a_output[@]}" -gt 0 ] && printf '%s\n' "" "-- Correctly set: --" "${a_output[@]}" ""
    exit 1
fi