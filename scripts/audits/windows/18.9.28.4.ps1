#```powershell
# PowerShell 7 script to audit if "Turn on convenience PIN sign-in" is set to Disabled

# Define the registry path and value name to be audited
$RegistryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
$ValueName = 'AllowDomainPINLogon'

# Try to get the registry value
try {
    $regValue = Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction Stop
} catch {
    Write-Output "Registry path or value not found. Please ensure the policy is set manually."
    exit 1
}

# Check if the registry value is set to 0 (Disabled)
if ($regValue.$ValueName -eq 0) {
    Write-Output "Audit Passed: 'Turn on convenience PIN sign-in' is set to 'Disabled'."
    exit 0
} else {
    Write-Output "Audit Failed: 'Turn on convenience PIN sign-in' is not set to 'Disabled'. Please check manually."
    exit 1
}
# ```
