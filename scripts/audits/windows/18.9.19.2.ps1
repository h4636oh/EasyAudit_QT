#```powershell
# PowerShell 7 Script to Audit the 'Continue experiences on this device' Policy Setting

# Initialize a variable to track audit status
$AuditSuccess = $true

# Define the registry path and key
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
$registryKey = 'EnableCdp'
$expectedValue = 0

try {
    # Check if the registry key exists
    if (Test-Path "$registryPath\$registryKey") {
        # Get the current value of the registry key
        $currentValue = Get-ItemProperty -Path $registryPath -Name $registryKey | Select-Object -ExpandProperty $registryKey

        # Compare the current value with the expected value
        if ($currentValue -eq $expectedValue) {
            Write-Host "Audit Passed: The policy is set correctly."
        } else {
            Write-Host "Audit Failed: The policy is NOT set correctly. Expected value: $expectedValue, Found: $currentValue"
            $AuditSuccess = $false
        }
    } else {
        Write-Host "Audit Failed: The registry key '$registryPath\$registryKey' does not exist."
        $AuditSuccess = $false
    }
} catch {
    Write-Host "Audit Error: An exception occurred. $_"
    $AuditSuccess = $false
}

# Prompt the user to verify the setting through the Group Policy Editor if needed
if (-not $AuditSuccess) {
    Write-Host "Please verify the policy manually:"
    Write-Host "Go to 'Computer Configuration\\Policies\\Administrative Templates\\System\\Group Policy\\Continue experiences on this device'"
    Write-Host "Ensure that the setting is set to 'Disabled'."
}

# Exit with the appropriate status code
if ($AuditSuccess) {
    exit 0
} else {
    exit 1
}
# ```
