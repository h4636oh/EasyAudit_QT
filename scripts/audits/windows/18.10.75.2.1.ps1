#```powershell
# PowerShell 7 script to audit Windows Defender SmartScreen settings.
# This script checks the registry settings for EnableSmartScreen and ShellSmartScreenLevel.
# It exits with code 0 if the settings are as expected or code 1 if the settings do not match the expected values.

# Define registry path and expected values
$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
$enableSmartScreenExpected = 1
$shellSmartScreenLevelExpected = 'Block'

# Function to get the registry value
function Get-RegistryValue {
    param (
        [string]$Path,
        [string]$Name
    )
    try {
        $value = Get-ItemProperty -Path $Path -Name $Name -ErrorAction Stop
        return $value.$Name
    } catch {
        Write-Host "Could not retrieve the registry value $Name at path $Path" -ForegroundColor Red
        return $null
    }
}

# Get current registry values
$enableSmartScreenCurrent = Get-RegistryValue -Path $regPath -Name 'EnableSmartScreen'
$shellSmartScreenLevelCurrent = Get-RegistryValue -Path $regPath -Name 'ShellSmartScreenLevel'

# Audit check logic
if ($null -eq $enableSmartScreenCurrent -or $null -eq $shellSmartScreenLevelCurrent) {
    Write-Host "One or more registry keys could not be found. Please check if the policy is applied." -ForegroundColor Yellow
    exit 1
}

if ($enableSmartScreenCurrent -eq $enableSmartScreenExpected -and $shellSmartScreenLevelCurrent -eq $shellSmartScreenLevelExpected) {
    Write-Host "Audit Passed: SmartScreen settings are configured correctly." -ForegroundColor Green
    exit 0
} else {
    Write-Host "Audit Failed: SmartScreen settings are not configured as recommended." -ForegroundColor Red
    Write-Host "Please navigate to the group policy path and set 'Configure Windows Defender SmartScreen' to 'Enabled: Warn and prevent bypass'." -ForegroundColor Yellow
    exit 1
}
# ```
