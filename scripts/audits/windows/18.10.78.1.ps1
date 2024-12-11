#```powershell
# PowerShell 7 Script to Audit Enhanced Sign-in Security for Biometrics

$regPath = 'HKLM:\SOFTWARE\Microsoft\Policies\PassportForWork\Biometrics'
$regName = 'EnableESSwithSupportedPeripherals'
$expectedValue = 1

try {
    # Check if the registry key exists
    if (-Not (Test-Path $regPath)) {
        Write-Host "Registry path $regPath does not exist."
        Write-Host "Audit failed."
        exit 1
    }

    # Get the current value of the registry setting
    $currentValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop | Select-Object -ExpandProperty $regName
} catch {
    Write-Host "Error accessing registry: $($_.Exception.Message)"
    Write-Host "Audit failed."
    exit 1
}

# Compare the current value with the expected value
if ($currentValue -eq $expectedValue) {
    Write-Host "Enhanced Sign-in Security is enabled as expected."
    Write-Host "Audit passed."
    exit 0
} else {
    Write-Host "Enhanced Sign-in Security is not set correctly."
    Write-Host "Please manually set the policy as defined:"
    Write-Host "Navigate to Computer Configuration -> Policies -> Administrative Templates"
    Write-Host "-> Windows Components -> Windows Hello for Business"
    Write-Host "-> Enable ESS with Supported Peripherals and set it to Enabled."
    Write-Host "Audit failed."
    exit 1
}
# ```
# 
