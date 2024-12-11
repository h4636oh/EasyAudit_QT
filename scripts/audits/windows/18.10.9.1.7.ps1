#```powershell
# This script audits the BitLocker policy setting for saving BitLocker recovery information to Active Directory Domain Services (AD DS).
# The required state is: 'Enabled: False' (unchecked).
# This sets the registry value at HKLM:\SOFTWARE\Policies\Microsoft\FVE\FDVActiveDirectoryBackup to 0.


# Define the registry path and key name
$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$registryValueName = "FDVActiveDirectoryBackup"
$expectedValue = 0

try {
    # Check if the registry key exists
    $actualValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop | Select-Object -ExpandProperty $registryValueName

    if ($actualValue -eq $expectedValue) {
        Write-Host "Audit Passed: The BitLocker recovery information is not saved to AD DS as required."
        exit 0
    }
    else {
        Write-Host "Audit Failed: The BitLocker recovery information is saved to AD DS when it should not be."
        exit 1
    }
}
catch {
    Write-Host "Audit Failed: Unable to read the registry value. Confirm that BitLocker is enabled and the specified registry path is correct."
    exit 1
}

# Prompt user to manually check the Group Policy setting
Write-Host "Please manually check the following Group Policy setting:"
Write-Host "Computer Configuration -> Policies -> Administrative Templates -> Windows Components -> BitLocker Drive Encryption -> Fixed Data Drives -> Choose how BitLocker-protected fixed drives can be recovered: Save BitLocker recovery information to AD DS for fixed data drives"
Write-Host "Ensure it is set to 'Enabled: False' (unchecked)."
# ```
