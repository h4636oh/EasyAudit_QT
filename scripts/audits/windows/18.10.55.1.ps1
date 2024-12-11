#```powershell
# Define the registry path and value name
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\PushToInstall"
$valueName = "DisablePushToInstall"

# Attempt to get the registry value
try {
    $regValue = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction Stop
} catch {
    Write-Host "The registry path or value does not exist. Please ensure the policy is applied."
    exit 1
}

# Check if the value is set to 1 (Enabled)
if ($regValue.$valueName -eq 1) {
    Write-Host "Audit Passed: 'DisablePushToInstall' is set to 'Enabled'."
    exit 0
} else {
    Write-Host "Audit Failed: 'DisablePushToInstall' is not set to 'Enabled'."
    Write-Host "Manual Action Required: Navigate to 'Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\Push to Install' and ensure 'Turn off Push To Install service' is set to 'Enabled'."
    exit 1
}
# ```
