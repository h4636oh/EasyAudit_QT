#```powershell
# This script audits the encryption level setting for Remote Desktop Protocol (RDP)
# connections to ensure it is set to 'Enabled: High Level'.

# Define the registry path and value to check
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
$valueName = 'MinEncryptionLevel'
$expectedValue = 3

try {
    # Check if the registry key exists
    if (Test-Path $registryPath) {
        # Get the current encryption level
        $currentValue = Get-ItemProperty -Path $registryPath -Name $valueName -ErrorAction Stop | Select-Object -ExpandProperty $valueName
        
        # Compare the current value with the expected value
        if ($currentValue -eq $expectedValue) {
            Write-Output "Audit Passed: RDP encryption level is set to 'Enabled: High Level'."
            exit 0
        } else {
            Write-Output "Audit Failed: RDP encryption level is not set to 'Enabled: High Level'. Current value: $currentValue"
            exit 1
        }
    } else {
        Write-Output "Audit Failed: Registry path does not exist. The RDP setting might not be configured."
        exit 1
    }
} catch {
    Write-Output "Error: Unable to access registry or retrieve the encryption setting. Exception: $_"
    exit 1
}

# If manual confirmation is required as part of the audit process, prompt the user.
Write-Output "Please manually confirm the RDP encryption level via Group Policy: Computer Configuration -> Policies -> Administrative Templates -> Windows Components -> Remote Desktop Services -> Remote Desktop Session Host -> Security -> Set client connection encryption level."
# ```
