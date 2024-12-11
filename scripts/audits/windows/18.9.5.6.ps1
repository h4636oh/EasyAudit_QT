#```powershell
# Define the registry path and value name for auditing
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
$valueName = "ConfigureSystemGuardLaunch"

# Try to get the registry entry
try {
    $regValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
    # Check if the value is set to 1 (Enabled)
    if ($regValue.$valueName -eq 1) {
        Write-Host "Audit Passed: Secure Launch is Enabled."
        exit 0
    } else {
        Write-Host "Audit Failed: Secure Launch is NOT Enabled. Please enable it manually through Group Policy."
        exit 1
    }
} catch {
    # In case of an error (e.g., registry key does not exist)
    Write-Host "Audit Error: Could not retrieve the registry value. Secure Launch may not be configured."
    exit 1
}
# ```
