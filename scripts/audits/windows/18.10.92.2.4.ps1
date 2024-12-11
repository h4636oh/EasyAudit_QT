# ```powershell
# Script to audit if 'Remove access to "Pause updates"' feature is set to 'Enabled'
# This script checks the registry setting at HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate

$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$regName = "SetDisablePauseUXAccess"
$expectedValue = 1

try {
    # Check if the registry key exists
    $regValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop | Select-Object -ExpandProperty $regName

    if ($regValue -eq $expectedValue) {
        Write-Output "Audit Passed: 'Remove access to “Pause updates” feature' is set to 'Enabled'."
        exit 0
    }
    else {
        Write-Output "Audit Failed: 'Remove access to “Pause updates” feature' is not set to 'Enabled'."
        Write-Output "Please manually set the policy via Group Policy or update the registry accordingly."
        exit 1
    }
} catch {
    Write-Output "Audit Failed: Registry path '$regPath' or value '$regName' does not exist."
    Write-Output "Please manually set the policy via Group Policy or update the registry accordingly."
    exit 1
}
# ```
