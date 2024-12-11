#```powershell
# PowerShell 7 Script to Audit Location Redirection Policy Setting

# Define the registry path and key
$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
$regName = 'fDisableLocationRedir'

# Attempt to get the registry value
try {
    $regValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop
} catch {
    Write-Output "Registry key or value not found. Please verify manually that the setting exists and is configured."
    exit 1
}

# Check if the registry value is set to 1 (Enabled)
if ($regValue.$regName -eq 1) {
    Write-Output "Audit successful: 'Do not allow location redirection' is set to 'Enabled'."
    exit 0
} else {
    Write-Output "Audit failed: 'Do not allow location redirection' is not set to 'Enabled'."
    exit 1
}
# ```
