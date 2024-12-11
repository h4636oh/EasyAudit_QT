# Ensure PowerShell 7 is being used
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Error "This script requires PowerShell 7 or newer."
    exit 1
}

# Path to the registry key
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceGuard"
$regValueName = "RequirePlatformSecurityFeatures"

# Check if the registry key exists
if (-not (Test-Path $regPath)) {
    Write-Host "The registry path $regPath does not exist. Manual audit required."
    exit 1
}

# Retrieve the registry value
$regValue = Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction SilentlyContinue

# Check if the registry value exists and is set correctly
if ($null -eq $regValue) {
    Write-Host "The registry value $regValueName does not exist. Manual audit required."
    exit 1
} elseif ($regValue.$regValueName -ne 1 -and $regValue.$regValueName -ne 3) {
    Write-Host "The registry value $regValueName is not set to 1 or 3. Audit failed."
    exit 1
} else {
    Write-Host "Audit passed. The registry value $regValueName is set correctly."
    exit 0
}
