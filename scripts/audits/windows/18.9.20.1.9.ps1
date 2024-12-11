#```powershell
# PowerShell 7 Script to Audit "Turn off Search Companion content file updates" Policy
# Checks if the policy is enabled by verifying a specific registry setting
# Exits with status 0 if compliant, otherwise exits with status 1

# Define the registry path and value name
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\SearchCompanion'
$valueName = 'DisableContentFileUpdates'

# Retrieve the registry value
try {
    $registryValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
} catch {
    Write-Host "Audit Failed: The registry path or value does not exist."
    # If the registry key or value does not exist, it is not compliant
    exit 1
}

# Check if the registry value is set to the recommended state (Enabled -> 1)
if ($registryValue.$valueName -eq 1) {
    Write-Host "Audit Passed: The policy is correctly set to Enabled."
    exit 0
} else {
    Write-Host "Audit Failed: The policy is not set to Enabled."
    Write-Host "Please manually set the policy via Group Policy Management to Enabled."
    exit 1
}
# ```
