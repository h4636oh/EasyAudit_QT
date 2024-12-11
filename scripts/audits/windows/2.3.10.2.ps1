#```powershell
# PowerShell 7 Script to Audit the Policy Setting for 'Network access: Do not allow anonymous enumeration of SAM accounts'

# Define the registry path and value for auditing
$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
$registryValueName = "RestrictAnonymousSAM"
$expectedValue = 1

# Function to check the registry setting
function Test-RestrictAnonymousSAM {
    try {
        # Get the current value of the registry setting
        $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop | Select-Object -ExpandProperty $registryValueName

        # Compare the current value with the expected value
        if ($currentValue -eq $expectedValue) {
            Write-Output "Audit Passed: 'Network access: Do not allow anonymous enumeration of SAM accounts' is correctly set to 'Enabled'."
            exit 0
        } else {
            Write-Output "Audit Failed: 'Network access: Do not allow anonymous enumeration of SAM accounts' is NOT set correctly. Expected: $expectedValue, Found: $currentValue."
            exit 1
        }
    } catch {
        # Handle errors such as the registry key/value not existing
        Write-Output "Audit Failed: Unable to read the registry setting. Ensure the path $registryPath exists and has the correct permissions."
        exit 1
    }
}

# Invoke the function to check the setting
Test-RestrictAnonymousSAM
# ```
