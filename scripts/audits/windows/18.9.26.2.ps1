#```powershell
# PowerShell 7 script to audit LSASS protection setting

$registryPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
$registryName = 'RunAsPPL'
$expectedValue = 1
$auditPassed = $false

# Check if the LSASS protected setting is configured correctly
try {
    $regValue = Get-ItemProperty -Path $registryPath -Name $registryName -ErrorAction Stop
    if ($regValue.$registryName -eq $expectedValue) {
        Write-Host "Audit Passed: LSASS is configured to run as a protected process (Enabled with UEFI Lock)."
        $auditPassed = $true
    } else {
        Write-Host "Audit Failed: LSASS is not configured to run as a protected process (Expected value is $expectedValue, found $($regValue.$registryName))."
    }
} catch {
    Write-Host "Audit Failed: Could not find the registry key or value. Ensure the registry path $registryPath exists."
}

# Advise manual remediation if not already configured
if (-not $auditPassed) {
    Write-Host "Please manually navigate to the Group Policy path:"
    Write-Host "Computer Configuration\\Policies\\Administrative Templates\\System\\Local Security Authority"
    Write-Host "Set 'Configures LSASS to run as a protected process' to 'Enabled: Enabled with UEFI Lock'."
}

# Exit script with appropriate status
if ($auditPassed) {
    exit 0
} else {
    exit 1
}
# ```
