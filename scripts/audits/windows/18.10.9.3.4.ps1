# Script to audit the BitLocker recovery password policy setting
# The script audits the specified registry value to confirm compliance with the policy

$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\FVE'
$registryValueName = 'RDVRecoveryPassword'
$expectedValue = 0

# Function to check the registry value for BitLocker recovery password policy
function Check-BitLockerRecoveryPasswordPolicy {
    try {
        # Check if the registry path exists
        if (-not (Test-Path -Path $registryPath)) {
            Write-Warning "Registry path $registryPath not found. Please ensure the policy is configured."
            exit 1
        }

        # Check if the registry value exists
        if (-not (Test-Path -Path "$registryPath\$registryValueName")) {
            Write-Warning "Registry value $registryValueName not found. Please ensure the policy is configured."
            exit 1
        }

        # Get the current value of the registry entry
        $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop

        if ($currentValue.$registryValueName -eq $expectedValue) {
            Write-Output "Audit Passed: The 'Choose how BitLocker-protected removable drives can be recovered: Recovery Password' policy is set correctly."
            exit 0
        }
        else {
            Write-Warning "Audit Failed: The 'Choose how BitLocker-protected removable drives can be recovered: Recovery Password' policy is not set correctly. Expected: $expectedValue, Found: $($currentValue.$registryValueName)"
            exit 1
        }
    }
    catch {
        Write-Error "Audit Failed: Unable to retrieve the registry value. Ensure that the policy is set manually as per the remediation steps if not found in the registry."
        exit 1
    }
}

# Execute the audit check
Check-BitLockerRecoveryPasswordPolicy
