#```powershell
# Script to audit the group policy setting for "Let Windows apps activate with voice while the system is locked"
# The policy should be set to "Enabled: Force Deny", which corresponds to a registry value of 2.

$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy'
$regName = 'LetAppsActivateWithVoiceAboveLock'
$expectedValue = 2

# Function to check the registry value
function Test-RegistrySetting {
    param (
        [string]$Path,
        [string]$Name,
        [int]$ExpectedValue
    )

    if (Test-Path $Path) {
        $actualValue = Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $Name

        if ($null -ne $actualValue -and $actualValue -eq $ExpectedValue) {
            Write-Output "Audit Passed: The registry setting is correctly configured."
            return $true
        }
        else {
            Write-Output "Audit Failed: The registry setting is not configured as expected. Current value: $actualValue"
            return $false
        }
    }
    else {
        Write-Output "Audit Failed: Registry path does not exist."
        return $false
    }
}

# Run the audit check
if (Test-RegistrySetting -Path $regPath -Name $regName -ExpectedValue $expectedValue) {
    exit 0
} else {
    Write-Output "Please manually verify the Group Policy via UI Path: Computer Configuration\Policies\Administrative Templates\Windows Components\App Privacy\Let Windows apps activate with voice while the system is locked"
    exit 1
}
# ```
