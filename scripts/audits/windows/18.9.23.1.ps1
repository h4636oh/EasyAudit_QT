#```powershell
# PowerShell 7 Audit Script
# Title: Ensure 'Support device authentication using certificate' is set to 'Enabled: Automatic' (Automated)

# Define the registry paths for auditing
$registryPath = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\kerberos\parameters'
$devicePKInitBehaviorKey = 'DevicePKInitBehavior'
$devicePKInitEnabledKey = 'DevicePKInitEnabled'

# Attempt to get the registry values
try {
    $devicePKInitBehavior = Get-ItemProperty -Path $registryPath -Name $devicePKInitBehaviorKey -ErrorAction Stop
    $devicePKInitEnabled = Get-ItemProperty -Path $registryPath -Name $devicePKInitEnabledKey -ErrorAction Stop
} catch {
    Write-Host "Error: Could not retrieve registry keys. Please ensure the path and keys exist." -ForegroundColor Red
    exit 1
}

# Check the registry values against the expected configuration
# Expected: DevicePKInitBehavior = 0, DevicePKInitEnabled = 1
if ($devicePKInitBehavior.$devicePKInitBehaviorKey -eq 0 -and $devicePKInitEnabled.$devicePKInitEnabledKey -eq 1) {
    Write-Host "Audit Pass: 'Support device authentication using certificate' is set correctly." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Audit Fail: 'Support device authentication using certificate' is not set to the recommended configuration." -ForegroundColor Yellow
    Write-Host "Please manually set 'Support device authentication using certificate' to 'Enabled: Automatic' through Group Policy."
    Write-Host "Navigate to: Computer Configuration -> Policies -> Administrative Templates -> System -> Kerberos -> Support device authentication using certificate."
    exit 1
}
# ```
# 
