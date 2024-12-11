#```powershell
# PowerShell 7 Script to audit the configuration of "Disallow WinRM from storing RunAs credentials" policy.
# The script will check the registry value to ensure the policy is enabled.

$registryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Service"
$registryValueName = "DisableRunAs"

try {
    # Check if the registry path exists
    if (Test-Path $registryPath) {
        # Get the registry value
        $registryValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop

        # Audit to check if the value is set to 1 as required
        if ($registryValue.$registryValueName -eq 1) {
            Write-Output "Audit Passed: 'Disallow WinRM from storing RunAs credentials' is set to 'Enabled'."
            exit 0
        } else {
            Write-Output "Audit Failed: 'Disallow WinRM from storing RunAs credentials' is NOT set to 'Enabled'. Please enable this setting via Group Policy."
            exit 1
        }
    } else {
        Write-Output "Audit Failed: Registry path does not exist. Please ensure the Group Policy is applied."
        exit 1
    }
} catch {
    Write-Output "Audit Failed: An error occurred while accessing the registry. $_"
    exit 1
}
# ```
