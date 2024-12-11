#```powershell
# Script to audit 'Interactive logon: Machine inactivity limit' setting
# This script checks if the Machine inactivity limit is set to 900 seconds or fewer, but not 0
# Reference: Registry Key HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System:InactivityTimeoutSecs

# Define the registry path and value name
$registryPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
$valueName = 'InactivityTimeoutSecs'

# Get the registry value
try {
    $inactivityTimeoutSecs = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop
} catch {
    Write-Output "The registry key or value does not exist. Please manually check the Group Policy setting."
    exit 1
}

# Check if the value is 900 or fewer and not 0
if ($inactivityTimeoutSecs.$valueName -le 900 -and $inactivityTimeoutSecs.$valueName -ne 0) {
    Write-Output "Audit passed: 'Interactive logon: Machine inactivity limit' is set to 900 seconds or fewer, and not 0."
    exit 0
} else {
    Write-Output "Audit failed: Please set 'Interactive logon: Machine inactivity limit' to 900 seconds or fewer, and not 0."
    exit 1
}
# ```
