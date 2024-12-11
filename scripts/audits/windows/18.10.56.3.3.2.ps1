#```powershell
<#
.SYNOPSIS
This script audits whether the policy setting for preventing COM port redirection in Remote Desktop Services is enabled.

.DESCRIPTION
The script checks the registry key that corresponds to disabling COM port redirection in Remote Desktop Services. 
It checks if the registry key HKLM\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services:fDisableCcm is set to 1, which indicates 'Enabled'.

.NOTES
Profile Applicability: Level 2 (L2) - High Security/Sensitive Data Environment (limited functionality)

#>

try {
    # Registry path and key value
    $registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
    $registryKey = "fDisableCcm"

    # Attempt to get the registry value
    $comPortRedirectionValue = Get-ItemProperty -Path $registryPath -ErrorAction Stop | Select-Object -ExpandProperty $registryKey

    # Check if the value is set to 1 (Enabled)
    if ($comPortRedirectionValue -eq 1) {
        Write-Host "Audit Passed: 'Do not allow COM port redirection' is set to 'Enabled'."
        exit 0
    }
    else {
        Write-Host "Audit Failed: 'Do not allow COM port redirection' is NOT set to 'Enabled'."
        exit 1
    }
}
catch {
    # Handle scenarios where the registry key is not found
    Write-Host "Audit Failed: Unable to check 'Do not allow COM port redirection' setting. Registry key may not exist."
    exit 1
}

# Prompt the user to manually verify the UI settings if needed
Write-Host "Please manually verify the setting in Group Policy Management Console at the following path:"
Write-Host "Computer Configuration\Policies\Administrative Templates\Windows Components\Remote Desktop Services\Remote Desktop Session Host\Device and Resource Redirection\Do not allow COM port redirection"

# ```
