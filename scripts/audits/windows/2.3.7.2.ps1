#```powershell
# PowerShell 7 script to audit the policy: Interactive logon: Don't display last signed-in
# The recommended state for this setting is: Enabled (1)

# Define the registry path and value name
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$regValueName = "DontDisplayLastUserName"

# Try to get the current registry setting
Try {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regValueName -ErrorAction Stop | Select-Object -ExpandProperty $regValueName
} Catch {
    Write-Host "Could not retrieve the registry value for $regValueName. Please check if the registry path is correct and accessible."
    exit 1
}

# Check if the policy is set to 1 (Enabled)
if ($currentValue -eq 1) {
    Write-Host "Audit Passed: 'Interactive logon: Don't display last signed-in' is set to 'Enabled'."
    exit 0
} else {
    Write-Host "Audit Failed: 'Interactive logon: Don't display last signed-in' is not set to 'Enabled'."
    Write-Host "Manual Remediation Required: Set 'Interactive logon: Don't display last signed-in' to 'Enabled' via Group Policy."
    Write-Host "Navigate to: Computer Configuration\\Policies\\Windows Settings\\Security Settings\\Local Policies\\Security Options"
    Write-Host "Ensure the setting is correctly configured."
    exit 1
}
# ```
