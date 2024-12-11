#```powershell
# The script audits the Windows Messenger Customer Experience Improvement Program policy setting.
# It checks the registry value to determine if the setting is configured as 'Enabled'.

# Define the registry path and value details
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Messenger\Client'
$registryValueName = 'CEIP'
$expectedValue = 2

try {
    # Attempt to get the registry value
    $registryValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop

    # Check if the registry value matches the expected value
    if ($registryValue.$registryValueName -eq $expectedValue) {
        Write-Output "Audit Passed: The Windows Messenger Customer Experience Improvement Program setting is enabled correctly."
        exit 0
    } else {
        Write-Output "Audit Failed: The Windows Messenger Customer Experience Improvement Program setting is not enabled as expected."
        exit 1
    }
} catch {
    # Display a message prompting manual verification if the registry key/value does not exist
    Write-Warning "Registry path or value not found. Please verify manually through the Group Policy UI."
    exit 1
}
# ```
# 
