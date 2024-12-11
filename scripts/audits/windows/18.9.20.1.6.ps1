# PowerShell 7 Script to Audit the Group Policy Setting

# Define the registry path and value name
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$valueName = "NoWebServices"

try {
    # Attempt to retrieve the current value from the registry
    $regValue = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction Stop
    $currentValue = $regValue.$valueName
    
    # Check if the value is set to Enabled (1)
    if ($currentValue -eq 1) {
        Write-Output "Audit Passed: 'Turn off Internet download for Web publishing and online ordering wizards' is set to 'Enabled'."
        exit 0
    } else {
        Write-Warning "Audit Failed: 'Turn off Internet download for Web publishing and online ordering wizards' is NOT set to 'Enabled'."
        exit 1
    }
}
catch {
    Write-Warning "Audit Failed: Unable to retrieve the registry value. The setting might not be configured."
    Write-Warning "Manual check required. Ensure the policy is set to 'Enabled' at the following path: Computer Configuration\Policies\Administrative Templates\System\Internet Communication Management\Internet Communication settings\Turn off Internet download for Web publishing and online ordering wizards"
    exit 1
}
