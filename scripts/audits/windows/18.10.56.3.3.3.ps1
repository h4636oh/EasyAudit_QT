#```powershell
# Define the registry path and the expected value
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
$registryName = 'fDisableCdm'
$expectedValue = 1

# Function to check the registry value
function Test-DriveRedirection {
    try {
        # Check if the registry key exists
        if (Test-Path -Path $registryPath) {
            # Get the current value of the registry key
            $currentValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction Stop
            
            # Check if the current value matches the expected value
            if ($currentValue.$registryName -eq $expectedValue) {
                Write-Host "Audit Passed: 'Do not allow drive redirection' is set to 'Enabled'."
                exit 0
            } else {
                Write-Host "Audit Failed: 'Do not allow drive redirection' is not set to 'Enabled'. Expected value: $expectedValue, Found: $($currentValue.$registryName)"
                Write-Host "Please manually set 'Do not allow drive redirection' to 'Enabled' in Group Policy."
                exit 1
            }
        } else {
            Write-Host "Audit Failed: Registry path $registryPath does not exist."
            Write-Host "Please manually set 'Do not allow drive redirection' to 'Enabled' in Group Policy."
            exit 1
        }
    } catch {
        Write-Host "Audit Failed: An error occurred while accessing the registry - $($_.Exception.Message)"
        exit 1
    }
}

# Execute the audit function
Test-DriveRedirection
# ```
