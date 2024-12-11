#```powershell
# Ensure this script is running on PowerShell 7
if ($PSVersionTable.PSVersion.Major -lt 7) {
    Write-Host "This script requires PowerShell 7."
    exit 1
}

# Define the registry path and key
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security'
$registryKey = 'MaxSize'
$minRecommendedSize = 196608

# Check if the registry key exists
if (-not (Test-Path $registryPath)) {
    Write-Host "Registry path $registryPath does not exist. Manual intervention required."
    exit 1
}

# Get the current log file size setting
$currentLogFileSize = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction SilentlyContinue

if ($null -eq $currentLogFileSize) {
    Write-Host "Log size configuration is not set. Manual intervention required."
    exit 1
}

# Check if the current log file size meets the recommended state
if ($currentLogFileSize.$registryKey -ge $minRecommendedSize) {
    Write-Host "Audit passed: Log file size is set to $($currentLogFileSize.$registryKey) KB, which is compliant."
    exit 0
} else {
    Write-Host "Audit failed: Log file size is set to $($currentLogFileSize.$registryKey) KB. It should be 196,608 KB or greater."
    exit 1
}
# ```
