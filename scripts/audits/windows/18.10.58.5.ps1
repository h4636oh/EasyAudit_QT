#```powershell
# PowerShell script to audit the setting 'Allow indexing of encrypted files'

# Exit codes
$EXIT_FAIL = 1
$EXIT_SUCCESS = 0

# Registry path and value name
$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search'
$regName = 'AllowIndexingEncryptedStoresOrItems'

try {
    # Attempt to read the registry value
    $regValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop

    # Check if the registry value matches the recommended state (0: Disabled)
    if ($regValue.$regName -eq 0) {
        Write-Output "Audit Passed: 'Allow indexing of encrypted files' is set to 'Disabled'."
        exit $EXIT_SUCCESS
    } else {
        Write-Output "Audit Failed: 'Allow indexing of encrypted files' is not set to 'Disabled'. Please set it manually via Group Policy."
        exit $EXIT_FAIL
    }
} catch {
    Write-Output "Audit Failed: Unable to find the setting 'Allow indexing of encrypted files' in the specified registry path. Please verify manually if the Group Policy setting is configured as 'Disabled'."
    exit $EXIT_FAIL
}
# ```
