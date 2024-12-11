#```powershell
# PowerShell 7 script to audit 'Network security: Minimum session security for NTLM SSP based (including secure RPC) servers'
# Ensure the proper registry setting for NTLM security

$registryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0"
$registryValueName = "NTLMMinServerSec"
$expectedValue = 537395200

try {
    # Check if the registry key exists
    if (Test-Path $registryPath) {
        # Read the registry value
        $actualValue = Get-ItemProperty -Path $registryPath -Name $registryValueName -ErrorAction Stop

        # Compare the current value with the expected value
        if ($actualValue.$registryValueName -eq $expectedValue) {
            Write-Host "Audit Passed: The setting is correctly configured."
            exit 0
        }
        else {
            Write-Host "Audit Failed: Registry value $registryValueName is set to $($actualValue.$registryValueName). Expected: $expectedValue."
            Write-Host "Please manually configure the policy to 'Require NTLMv2 session security, Require 128-bit encryption'."
            exit 1
        }
    }
    else {
        Write-Host "Audit Failed: Registry path $registryPath does not exist."
        Write-Host "Please manually configure the policy to 'Require NTLMv2 session security, Require 128-bit encryption'."
        exit 1
    }
}
catch {
    Write-Host "Audit Error: $_"
    exit 1
}
# ```
# 
