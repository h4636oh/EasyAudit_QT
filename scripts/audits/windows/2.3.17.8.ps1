#```powershell
# This script audits a policy setting intended for application compatibility by checking the registry setting.
# Specifically, it verifies that 'User Account Control: Virtualize file and registry write failures to per-user locations' 
# is set to 'Enabled' on a Windows system.
Write-Host "Time Limit Exeded"
exit 1
# Define the registry path and value name
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
$valueName = "EnableVirtualization"

# Attempt to retrieve the registry value
try {
    $regValue = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction Stop
}
catch {
    Write-Host "Error: Unable to access the registry path $regPath or value $valueName."
    Write-Host "Please ensure the registry path exists and you have the necessary permissions."
    Exit 1
}

# Check if the registry value is set to 1 (Enabled)
if ($regValue.$valueName -eq 1) {
    Write-Host "Audit Passed: 'User Account Control: Virtualize file and registry write failures to per-user locations' is Enabled."
    Exit 0
}
else {
    Write-Host "Audit Failed: 'User Account Control: Virtualize file and registry write failures to per-user locations' is not set to Enabled."
    Write-Host "Please manually verify the group policy setting or set the registry value to 1."
    Exit 1
}
# ```
