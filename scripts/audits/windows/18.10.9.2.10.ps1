#```powershell
# PowerShell 7 script to audit BitLocker recovery information storage policy

# Define the registry path and the expected registry value
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\FVE'
$registryValueName = 'OSRequireActiveDirectoryBackup'
$expectedValue = 1

# Check if the registry path exists
if (Test-Path $registryPath) {
    # Get the actual value from the registry
    $actualValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction SilentlyContinue

    # Check if the registry value matches the expected value
    if ($null -ne $actualValue -and $actualValue.$registryValueName -eq $expectedValue) {
        Write-Output "Audit Passed: BitLocker recovery information is stored successfully in AD DS."
        exit 0
    }
    else {
        Write-Output "Audit Failed: BitLocker recovery information is NOT stored in AD DS as required."
        exit 1
    }
} else {
    Write-Output "Audit Failed: Registry path for BitLocker setting does not exist."
    exit 1
}

# Prompt the user for manual check if the registry path does not exist
if ($null -eq $actualValue) {
    Write-Output "Please ensure that BitLocker policy settings are configured correctly through Group Policy."
}
# ```
