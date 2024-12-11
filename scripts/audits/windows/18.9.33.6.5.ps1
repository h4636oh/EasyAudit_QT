#```powershell
# Audit Script: Ensure 'Require a password when a computer wakes (on battery)' is set to 'Enabled'
# Profile Applicability: Level 1 (L1) - Corporate/Enterprise Environment (general use)
# Description: Specifies if the user is prompted for a password when the system resumes from sleep.
# The recommended state for this setting is: Enabled.
# The relevant registry path is: 
# HKLM\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51:DCSettingIndex

# Define the registry path and the expected value
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Power\PowerSettings\0e796bdb-100d-47d6-a2d5-f7d2daa51f51'
$registryValueName = 'DCSettingIndex'
$expectedValue = 1

# Check if the registry key exists
if (Test-Path $registryPath) {
    $actualValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction SilentlyContinue

    if ($actualValue -ne $null -and $actualValue.$registryValueName -eq $expectedValue) {
        Write-Host "Audit Passed: The 'Require a password when a computer wakes (on battery)' setting is Enabled."
        exit 0
    }
    else {
        Write-Host "Audit Failed: The 'Require a password when a computer wakes (on battery)' setting is not set correctly." -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "Audit Failed: The registry path $registryPath does not exist. Please verify the policy configuration manually." -ForegroundColor Red
    exit 1
}
# ```
