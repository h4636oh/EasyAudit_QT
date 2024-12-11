#```powershell
# PowerShell 7 Script to audit BitLocker recovery policy for fixed drives
# Ensure 'Choose how BitLocker-protected fixed drives can be recovered: Configure storage of BitLocker recovery information to AD DS'
# is set to 'Enabled: Backup recovery passwords and key packages'.

$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\FVE'
$registryValueName = 'FDVActiveDirectoryInfoToStore'
$expectedValue = 1

try {
    # Check if registry path exists
    if (Test-Path $registryPath) {
        # Get the registry value
        $currentValue = (Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop).$registryValueName
        
        # Compare the current value with the expected value
        if ($currentValue -eq $expectedValue) {
            Write-Output "Audit Passed: The BitLocker recovery policy for fixed drives is correctly configured."
            exit 0
        } else {
            Write-Output "Audit Failed: The BitLocker recovery policy for fixed drives is not configured as expected."
            exit 1
        }
    } else {
        # Registry path does not exist
        Write-Output "Audit Failed: Registry path for BitLocker recovery policy does not exist. Please ensure Group Policy is applied."
        exit 1
    }
} catch {
    # Handle any errors that occur during the registry operations
    Write-Output "Audit Failed: An error occurred - $_. Exception.Message"
    exit 1
}
# ```
# 
