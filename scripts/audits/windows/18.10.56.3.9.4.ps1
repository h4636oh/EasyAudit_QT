#```powershell
# This script audits whether the setting "Require user authentication for remote connections 
# by using Network Level Authentication" is enabled.

# Define the registry path and value name
$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
$regValueName = 'UserAuthentication'

# Attempt to retrieve the registry value
try {
    $regValue = Get-ItemProperty -Path $regPath -ErrorAction Stop | Select-Object -ExpandProperty $regValueName
} catch {
    Write-Host "Registry path or value not found: $regPath\$regValueName" -ForegroundColor Red
    Write-Host "Please enable the policy manually through Group Policy:\n" `
        + "Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\Remote Desktop Services\\Remote Desktop Session Host\\Security" `
        + "\nRequire user authentication for remote connections by using Network Level Authentication" -ForegroundColor Yellow
    exit 1
}

# Check if the policy is enabled
if ($regValue -eq 1) {
    Write-Host "Audit Passed: 'Require user authentication for remote connections by using Network Level Authentication' is set to Enabled." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Audit Failed: 'Require user authentication for remote connections by using Network Level Authentication' is not set to Enabled." -ForegroundColor Red
    Write-Host "Please ensure this policy is set to 'Enabled' through the Group Policy path mentioned." -ForegroundColor Yellow
    exit 1
}
# ```
