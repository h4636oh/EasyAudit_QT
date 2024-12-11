#```powershell
# Ensure PowerShell 7 compatibility
if ($PSVersionTable.PSVersion -lt [version]'7.0') {
    Write-Host "This script requires PowerShell 7 or higher." -ForegroundColor Red
    exit 1
}

# Define the registry path and key to audit
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\f15576e8-98b7-4186-b944-eafa664402d9"
$registryKey = "DCSettingIndex"
$expectedValue = 0

# Function to audit the registry setting
function Audit-RegistrySetting {
    try {
        $currentValue = Get-ItemPropertyValue -Path $registryPath -Name $registryKey -ErrorAction Stop
    } catch {
        Write-Host "Registry path or key not found. Please ensure the Group Policy is applied: `Computer Configuration\Policies\Administrative Templates\System\Power Management\Sleep Settings\Allow network connectivity during connected-standby (on battery)`." -ForegroundColor Yellow
        exit 1
    }

    if ($currentValue -eq $expectedValue) {
        Write-Host "Audit Passed: 'Allow network connectivity during connected-standby (on battery)' is set to 'Disabled' as expected." -ForegroundColor Green
        exit 0
    } else {
        Write-Host "Audit Failed: 'Allow network connectivity during connected-standby (on battery)' is not set to 'Disabled'. Expected value: $expectedValue, Current value: $currentValue." -ForegroundColor Red
        exit 1
    }
}

# Call the function to audit registry setting
Audit-RegistrySetting
# ```
