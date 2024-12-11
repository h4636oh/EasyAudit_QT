#```powershell
# PowerShell 7 Script to Audit BitLocker Policy Setting

# Define the registry path and value to audit
$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\FVE'
$regValue = 'OSHideRecoveryPage'

# Attempt to retrieve the registry value
Try {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValue -ErrorAction Stop
} Catch {
    Write-Output "The registry key or value does not exist."
    Write-Output "Please manually verify that the policy is set through Group Policy Management."
    Exit 1
}

# Check if the registry value matches the expected value
$expectedValue = 1

If ($currentValue.$regValue -eq $expectedValue) {
    Write-Output "Audit Passed: The BitLocker policy is set correctly."
    Exit 0
} Else {
    Write-Output "Audit Failed: The BitLocker policy is not set as expected."
    Write-Output "Please navigate to the Group Policy path and set the policy: Omit recovery options from the BitLocker setup wizard to Enabled: True."
    Exit 1
}
# ```
