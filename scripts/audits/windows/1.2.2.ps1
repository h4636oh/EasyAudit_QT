#```powershell
# This script audits the 'Account lockout threshold' setting to ensure it is set to '5 or fewer invalid logon attempt(s), but not 0'.
# The policy should be applied via the Default Domain Policy GPO.

function Get-AccountLockoutThreshold {
    try {
        # Retrieve the current Account Lockout Threshold value
        $lockoutThreshold = Get-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LockoutThreshold" -ErrorAction Stop
        return $lockoutThreshold.LockoutThreshold
    } catch {
        # If an error occurs while retrieving policy, assume policy is not set correctly
        Write-Output "Failed to retrieve the Account Lockout Threshold setting. Ensure the policy is configured via Default Domain Policy GPO."
        return $null
    }
}

function Main {
    $lockoutThreshold = Get-AccountLockoutThreshold
    
    if ($null -eq $lockoutThreshold) {
        # Prompt user to manually check the settings
        Write-Output "Please manually check the 'Account lockout threshold' via the following UI path:"
        Write-Output "Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Account Policies\\Account Lockout Policy\\Account lockout threshold"
        exit 1
    }
    
    if ($lockoutThreshold -eq 0 -or $lockoutThreshold -gt 5) {
        Write-Output "Account lockout threshold is set incorrectly to $lockoutThreshold. It should be '5 or fewer invalid logon attempts, but not 0'."
        exit 1
    } else {
        Write-Output "Account lockout threshold is set correctly to $lockoutThreshold."
        exit 0
    }
}

Main
# ```
# 
# This script retrieves the `Account lockout threshold` setting from the Windows Registry under the specified path. If the value is not set correctly (more than 5 or exactly 0), it outputs a message indicating the incorrect setting and exits with a status of 1. If the setting is correct, it exits with a status of 0. If it fails to retrieve the setting due to being incorrectly configured outside of the Default Domain Policy, it prompts the user to manually check the setting.
