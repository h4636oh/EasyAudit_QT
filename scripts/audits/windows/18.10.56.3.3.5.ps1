#```powershell
# PowerShell 7 Script to Audit the 'Do not allow LPT port redirection' Policy Setting

# Function to check the registry value
Function Test-LPTPortRedirection {
    # Define the registry path and value name
    $registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
    $valueName = 'fDisableLPT'
    
    # Check if the registry key and value exist
    if (Test-Path $registryPath) {
        $registryValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction SilentlyContinue

        if ($null -ne $registryValue) {
            # Check if the value is set to 1 (Enabled)
            if ($registryValue.$valueName -eq 1) {
                Write-Output "Audit Passed: The 'Do not allow LPT port redirection' policy is enabled."
                return $true
            } else {
                Write-Warning "Audit Failed: The 'Do not allow LPT port redirection' policy is not set to Enabled (value not 1)."
                return $false
            }
        } else {
            Write-Warning "Audit Failed: The 'fDisableLPT' registry value does not exist."
            return $false
        }
    } else {
        Write-Warning "Audit Failed: The registry path $registryPath does not exist."
        return $false
    }
}

# Run the audit function
if (Test-LPTPortRedirection) {
    # Exit with status 0 (success)
    exit 0
} else {
    Write-Host "Please manually check the Group Policy setting: Computer Configuration > Policies > Administrative Templates > Windows Components > Remote Desktop Services > Remote Desktop Session Host > Device and Resource Redirection > Do not allow LPT port redirection."
    # Exit with status 1 (failure)
    exit 1
}
# ```
