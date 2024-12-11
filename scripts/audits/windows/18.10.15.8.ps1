#```powershell
# PowerShell 7 Script to Audit 'Toggle user control over Insider builds'

# Define the registry path and key to check
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds'
$registryKey = 'AllowBuildPreview'

# Initialize the result flag as true
$auditPassed = $true

try {
    # Retrieve the registry value
    $registryValue = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction Stop
    
    # Check if the value is set to 0, which means 'Disabled'
    if ($registryValue.$registryKey -eq 0) {
        Write-Output "Audit Passed: 'Toggle user control over Insider builds' is set to 'Disabled'."
    } else {
        Write-Output "Audit Failed: 'Toggle user control over Insider builds' is NOT set to 'Disabled'."
        $auditPassed = $false
    }
} catch {
    Write-Output "Audit Failed: Registry path or key not found. Ensure policy path 'Toggle user control over Insider builds' is configured."
    $auditPassed = $false
}

# Exit with 0 if audit passed, 1 if failed
if ($auditPassed) {
    exit 0
} else {
    exit 1
}
# ```
