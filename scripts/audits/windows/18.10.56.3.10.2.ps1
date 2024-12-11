#```powershell
# Ensure PowerShell 7
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Host "This script requires PowerShell 7 or later."
    exit 1
}

# Define the registry path and the expected value for the policy
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
$registryKey = "MaxDisconnectionTime"
$expectedValue = 60000  # 1 minute in milliseconds

# Check if the registry key exists
if (-not (Test-Path "$registryPath\$registryKey")) {
    Write-Host "The registry key $registryKey does not exist under $registryPath."
    Write-Host "Please manually configure the policy through Group Policy Management."
    exit 1
}

# Retrieve the current value of the registry key
$currentValue = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $registryKey -ErrorAction SilentlyContinue

# Audit the current value against the expected value
if ($null -eq $currentValue) {
    Write-Host "The registry key $registryKey exists but has no value set."
    Write-Host "Please manually configure the policy through Group Policy Management."
    exit 1
}

if ($currentValue -eq $expectedValue) {
    Write-Host "Audit Passed: The 'Set time limit for disconnected sessions' is set correctly to 'Enabled: 1 minute'."
    exit 0
} else {
    Write-Host "Audit Failed: The 'Set time limit for disconnected sessions' is not set to 'Enabled: 1 minute'."
    Write-Host "Current Value: $currentValue milliseconds"
    Write-Host "Please manually configure the policy through Group Policy Management."
    exit 1
}
# ```
