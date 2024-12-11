#```powershell
# PowerShell 7 script to audit the security policy for Allowing Custom SSPs and APs to be loaded into LSASS

# Define the registry path and value name
$registryPath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\System'
$registryValueName = 'AllowCustomSSPsAPs'
$expectedValue = 0

# Check if the registry key exists
if (Test-Path $registryPath) {
    # Get the current registry value
    $currentValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction SilentlyContinue | Select-Object -ExpandProperty $registryValueName

    if ($null -ne $currentValue) {
        # Compare the current value with the expected value
        if ($currentValue -eq $expectedValue) {
            Write-Host "Audit Passed: The setting 'Allow Custom SSPs and APs to be loaded into LSASS' is correctly set to 'Disabled'."
            exit 0
        } else {
            Write-Host "Audit Failed: The setting 'Allow Custom SSPs and APs to be loaded into LSASS' is not set to 'Disabled'. Current Value: $currentValue"
            Write-Host "Please manually check and update the group policy setting as per remediation instructions."
            exit 1
        }
    } else {
        Write-Host "Audit Failed: The registry value 'AllowCustomSSPsAPs' does not exist. Please ensure the policy is properly configured."
        exit 1
    }
} else {
    Write-Host "Audit Failed: The registry path does not exist. It is likely that the policy is not applied."
    Write-Host "Please manually navigate to Computer Configuration\\Policies\\Administrative Templates\\System\\Local Security Authority\\"
    Write-Host "and ensure 'Allow Custom SSPs and APs to be loaded into LSASS' is set to 'Disabled'."
    exit 1
}
# ```
# 
