#!/usr/bin/env bash
{
    
    l_output="" 
    l_output2=""
    a_nouser=(); a_nogroup=() # Initialize arrays (note this goes through every file so takes a lot of time have to do threadding)
    a_path=(! -path "/run/user/*" -a ! -path "/proc/*" -a ! -path \
    "*/containerd/*" -a ! -path "*/kubelet/pods/*" -a ! -path \
    "*/kubelet/plugins/*" -a ! -path "/sys/fs/cgroup/memory/*" -a ! -path \
    "/var/*/private/*")
    
    while IFS= read -r l_mount; do
        while IFS= read -r -d $'\0' l_file; do
            if [ -e "$l_file" ]; then
                while IFS=: read -r l_user l_group; do
                    [ "$l_user" = "UNKNOWN" ] && a_nouser+=("$l_file")
                    [ "$l_group" = "UNKNOWN" ] && a_nogroup+=("$l_file")
                done < <(stat -Lc '%U:%G' "$l_file")
            fi
        done < <(find "$l_mount" -xdev \( "${a_path[@]}" \) \( -type f -o -type d \) \( -nouser -o -nogroup \) -print0 2> /dev/null)
    done < <(findmnt -Dkerno fstype,target | awk '($1 !~ /^\s*(nfs|proc|smb|vfat|iso9660|efivarfs|selinuxfs)/ && $2 !~ /^\/run\/user\//) {print $2}')
    
    if ! (( ${#a_nouser[@]} > 0 )); then
        l_output="$l_output\n - No files or directories without a owner exist on the local filesystem."
    else
        l_output2="$l_output2\n - There are \"$(printf '%s' "${#a_nouser[@]}")\" unowned files or directories on the system.\n - The following is a list of unowned files and/or directories:\n$(printf '%s\n' "${a_nouser[@]}")\n - end of list"
    fi
    
    if ! (( ${#a_nogroup[@]} > 0 )); then
        l_output="$l_output\n - No files or directories without a group exist on the local filesystem."
    else
        l_output2="$l_output2\n - There are \"$(printf '%s' "${#a_nogroup[@]}")\" ungrouped files or directories on the system.\n - The following is a list of ungrouped files and/or directories:\n$(printf '%s\n' "${a_nogroup[@]}")\n - end of list"
    fi
    
    unset a_path
    unset a_nouser
    unset a_nogroup # Remove arrays
    
    if [ -z "$l_output2" ]; then # If l_output2 is empty, we pass
        echo -e "\n- Audit Result:\n ** PASS **\n - * Correctly configured *:\n$l_output\n"
        exit 0
    else
        echo -e "\n- Audit Result:\n ** FAIL **\n - * Reasons for audit failure *:\n$l_output2"
        [ -n "$l_output" ] && echo -e "\n- * Correctly configured *:\n$l_output\n"
        exit 1
    fi
}