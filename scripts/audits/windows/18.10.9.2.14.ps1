#```powershell
# PowerShell script to audit BitLocker policy setting for allowing BitLocker without a compatible TPM

# Define registry path and value name
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\FVE"
$valueName = "EnableBDEWithNoTPM"

# Function to check the registry value
function Test-BitLockerPolicy {
    try {
        # Check if the registry key exists
        if (Test-Path $regPath) {
            # Get the current registry value
            $value = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction Stop

            # Check if the registry value is not set to 0 (Enabled: False)
            if ($value.$valueName -eq 0) {
                Write-Host "Audit Passed: BitLocker policy is correctly set to 'Enabled: False (unchecked)'."
                return $true
            } else {
                Write-Host "Audit Failed: BitLocker policy is not set to 'Enabled: False (unchecked)'."
                return $false
            }
        } else {
            Write-Host "Audit Failed: Registry path does not exist."
            return $false
        }
    } catch {
        Write-Host "Audit Failed: An error occurred while checking the BitLocker policy." -ForegroundColor Red
        return $false
    }
}

# Run the test and set the exit code accordingly
if (Test-BitLockerPolicy) {
    exit 0
} else {
    exit 1
}
# ```
