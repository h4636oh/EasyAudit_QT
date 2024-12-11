#```powershell
# This script audits if the 'Scan all downloaded files and attachments' policy is enabled.
# Registry path and value details are provided to verify the Group Policy setting.

# Define the registry path and value name
$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection'
$valueName = 'DisableIOAVProtection'

# Attempt to get the registry value
try {
    $regValue = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction Stop
} catch {
    Write-Host "Registry path or value does not exist. Manual verification required." -ForegroundColor Yellow
    exit 1
}

# Check if the registry value is set to 0 (Enabled)
if ($regValue.$valueName -eq 0) {
    Write-Host "'Scan all downloaded files and attachments' is enabled as expected." -ForegroundColor Green
    exit 0
} else {
    Write-Host "'Scan all downloaded files and attachments' is NOT enabled. Manual adjustment required." -ForegroundColor Red
    exit 1
}
# ```
