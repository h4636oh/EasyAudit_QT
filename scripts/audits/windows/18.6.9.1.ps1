#```powershell
# This script audits whether the 'Turn on Mapper I/O (LLTDIO) driver' setting is set to 'Disabled'
# as per security recommendations for Level 2 (L2) - High Security/Sensitive Data Environment.

# Define registry keys and values
$registryPaths = @(
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LLTD",
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LLTD",
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LLTD",
    "HKLM:\SOFTWARE\Policies\Microsoft\Windows\LLTD"
)

$registryValues = @(
    "AllowLLTDIOOnDomain",
    "AllowLLTDIOOnPublicNet",
    "EnableLLTDIO",
    "ProhibitLLTDIOOnPrivateNet"
)

# Audit the registry values
$allCompliant = $true

for ($i = 0; $i -lt $registryPaths.Count; $i++) {
    $path = $registryPaths[$i]
    $valueName = $registryValues[$i]

    try {
        $value = Get-ItemProperty -Path $path -Name $valueName -ErrorAction Stop

        if ($value.$valueName -ne 0) {
            Write-Host "Audit Failed: $valueName at $path is not set to 0."
            $allCompliant = $false
        }
    } catch {
        Write-Host "Audit Notice: $valueName not found at $path. Manual verification required."
        $allCompliant = $false
    }
}

# Evaluate audit result
if ($allCompliant) {
    Write-Host "Audit Passed: All settings are compliant."
    exit 0
} else {
    Write-Host "Audit Failed: Some settings are non-compliant or missing."
    Write-Host "Please navigate to Computer Configuration\Policies\Administrative Templates\Network\Link-Layer Topology Discovery\Turn on Mapper I/O (LLTDIO) driver and ensure it is set to 'Disabled'."
    exit 1
}
# ```
