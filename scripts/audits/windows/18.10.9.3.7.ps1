#```powershell
# PowerShell 7 Script to Audit BitLocker Recovery Information Settings

# Define the registry path and value to check
$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\FVE'
$regName = 'RDVActiveDirectoryBackup'
$expectedValue = 0

try {
    # Check if the registry key exists
    if (Test-Path $regPath) {
        # Get the current value of the registry key
        $currentValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop | Select-Object -ExpandProperty $regName

        # Compare the current value with the expected value
        if ($currentValue -eq $expectedValue) {
            Write-Output "Audit Passed: The registry key '$regName' is set to $currentValue, as expected."
            exit 0
        } 
        else {
            Write-Output "Audit Failed: The registry key '$regName' is set to $currentValue. Expected value is $expectedValue."
            exit 1
        }
    } 
    else {
        Write-Output "Audit Failed: The registry path '$regPath' does not exist."
        exit 1
    }
} 
catch {
    # Handle any unexpected errors
    Write-Output "Audit Failed: An error occurred while checking the registry key. $_"
    exit 1
}

# Prompt user to manually check if the Group Policy setting is applied correctly.
Write-Output "Please manually verify the Group Policy setting:"
Write-Output "Navigate to: Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\BitLocker Drive Encryption\\Removable Data Drives\\"
Write-Output "Confirm 'Choose how BitLocker-protected removable drives can be recovered: Save BitLocker recovery information to AD DS for removable data drives' is set to 'Enabled: False'."
# ```
