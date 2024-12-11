#```powershell
# Define the registry path and the value name to audit
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\WindowsFirewall\PrivateProfile\Logging'
$valueName = 'LogSuccessfulConnections'

# Try to retrieve the current value of the registry key
try {
    $logSuccessfulConnections = (Get-ItemProperty -Path $registryPath -Name $valueName).$valueName
} catch {
    Write-Host "Unable to retrieve the registry setting. It may not be configured. Please check manually."
    exit 1
}

# Check if the value is set to the recommended state (1)
if ($logSuccessfulConnections -eq 1) {
    Write-Host "Audit Passed: 'Log successful connections' is set to 'Yes'."
    exit 0
} else {
    Write-Host "Audit Failed: 'Log successful connections' is not set to 'Yes'. Please set it manually via Group Policy or registry."
    exit 1
}
# ```
