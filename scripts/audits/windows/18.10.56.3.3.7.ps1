#```powershell
# This script audits the setting for "Do not allow WebAuthn redirection"
# It verifies the corresponding registry key value.
# Expected value for compliance is 1 (Enabled)

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$registryName = "fDisableWebAuthn"
$expectedValue = 1

# Attempt to read the registry value
try {
    $actualValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction Stop
} catch {
    Write-Host "Failed to read registry key or the key does not exist. Please ensure the group policy is applied." -ForegroundColor Yellow
    # Exiting as a failure since the key isn't configured as expected
    exit 1
}

# Audit the setting
if ($actualValue.$registryName -eq $expectedValue) {
    Write-Host "Audit Passed: Do not allow WebAuthn redirection is set to Enabled." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Audit Failed: Do not allow WebAuthn redirection is NOT set to Enabled." -ForegroundColor Red
    Write-Host "Manual action required: Navigate to Group Policy and set 'Do not allow WebAuthn redirection' to Enabled." -ForegroundColor Yellow
    exit 1
}
# ```
