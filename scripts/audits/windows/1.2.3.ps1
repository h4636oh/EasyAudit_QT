#```powershell
# PowerShell 7 Script to Audit the 'Allow Administrator account lockout' Policy Setting

# Function to check the status of the 'Allow Administrator account lockout' policy
function Test-AdministratorLockoutPolicy {
    # Retrieve the current policy setting from the Local Security Policy
    $policy = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "EnableAdminAccountLockout" -ErrorAction SilentlyContinue

    # Check if the policy is enabled (The registry value should be 1 if enabled)
    if ($null -eq $policy) {
        Write-Output "Policy not found. It might not be applied."
        return $false
    } elseif ($policy.EnableAdminAccountLockout -eq 1) {
        return $true
    } else {
        return $false
    }
}

# Main Script Execution
if (Test-AdministratorLockoutPolicy) {
    Write-Host "Audit Passed: 'Allow Administrator account lockout' is set to 'Enabled'."
    exit 0
} else {
    Write-Host "Audit Failed: 'Allow Administrator account lockout' is NOT set to 'Enabled'."
    Write-Host "Manual Action Required: Navigate to 'Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Account Policies\\Account Lockout Policies' and set 'Allow Administrator account lockout' to 'Enabled'."
    exit 1
}
# ```
# 
# This PowerShell script checks the status of the 'Allow Administrator account lockout' policy setting. The script uses the Local Security Policy registry path to verify if the setting is enabled (indicated by a registry value of 1). If the policy is correctly configured, the script exits with a status code of 0 to indicate a pass. If the policy is not set or found, it prompts the user to manually configure it and exits with a status code of 1, indicating a failed audit.
