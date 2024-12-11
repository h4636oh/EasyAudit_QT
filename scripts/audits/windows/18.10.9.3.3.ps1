#```powershell
# Define the registry path and value
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\FVE'
$registryValueName = 'RDVManageDRA'
$expectedValue = 1

try {
    # Read the registry value
    $registryValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop

    # Check if the value matches the expected state
    if ($registryValue.$registryValueName -eq $expectedValue) {
        Write-Output "Audit Successful: The Data Recovery Agent for BitLocker-protected removable drives is enabled as expected."
        exit 0
    }
    else {
        Write-Warning "Audit Failed: The Data Recovery Agent for BitLocker-protected removable drives is not set as expected."
        exit 1
    }
}
catch {
    Write-Warning "Audit Failed: Unable to read the registry value. Please ensure the registry path and value name are correct."
    exit 1
}

# Prompt the user to verify Group Policy manually as per the audit guidelines
Write-Output "Please verify that the Group Policy setting 'Allow data recovery agent for BitLocker-protected removable data drives' is enabled."
Write-Output "You can find the setting at the following UI path:"
Write-Output "Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\BitLocker Drive Encryption\\Removable Data Drives\\Choose how BitLocker-protected removable drives can be recovered: Allow data recovery agent"
# ```
