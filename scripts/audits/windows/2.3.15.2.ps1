#```powershell
# PowerShell 7 Script to Audit the Strength of Default DACL for System Objects

# Define registry path and key to check
$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager'
$registryKey = 'ProtectionMode'
$expectedValue = 1

# Try to get the current value of the registry key
try {
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryKey -ErrorAction Stop

    # Check if the current value matches the expected value
    if ($currentValue.$registryKey -eq $expectedValue) {
        Write-Host "Audit Passed: The 'ProtectionMode' is set correctly to 1."
        exit 0
    } else {
        Write-Host "Audit Failed: The 'ProtectionMode' is not set to 1."
        Write-Host "Please navigate to 'Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Local Policies\\Security Options' in Group Policy and ensure 'System objects: Strengthen default permissions of internal system objects (e.g. Symbolic Links)' is set to 'Enabled'."
        exit 1
    }
} catch {
    Write-Host "An error occurred while accessing the registry: $($_.Exception.Message)"
    Write-Host "Please ensure you have the necessary permissions to read the registry key."
    exit 1
}
# ```
