#```powershell
<#

    Profile Applicability:
    • Level 1 (L1) - Corporate/Enterprise Environment (general use)

    Title:
    18.9.4.1 (L1) Ensure 'Encryption Oracle Remediation' is set to 'Enabled: Force Updated Clients' (Automated)

    Description:
    Some versions of the CredSSP protocol that is used by some applications (such as
    Remote Desktop Connection) are vulnerable to an encryption oracle attack against the
    client. This policy controls compatibility with vulnerable clients and servers and allows
    you to set the level of protection desired for the encryption oracle vulnerability.
    The recommended state for this setting is: Enabled: Force Updated Clients.

    Audit:
    Navigate to the UI Path articulated in the Remediation section and confirm it is set as
    prescribed. This group policy setting is backed by the following registry location with a
    REG_DWORD value of 0.
    HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters:AllowEncryptionOracle

    Remediation:
    To establish the recommended configuration via GP, set the following UI path to
    Enabled: Force Updated Clients:
    Computer Configuration\Policies\Administrative Templates\System\Credentials
    Delegation\Encryption Oracle Remediation

#>

# Path to the registry key
$regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\CredSSP\Parameters"
$regName = "AllowEncryptionOracle"

# Get the current registry value
try {
    $currentValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop | Select-Object -ExpandProperty $regName
} catch {
    Write-Host "CredSSP setting does not exist. Manual configuration may be required."
    exit 1
}

# Expected value for compliance
$expectedValue = 0

# Check if the current value matches the expected value
if ($currentValue -eq $expectedValue) {
    Write-Host "Audit Passed: The 'Encryption Oracle Remediation' is set to 'Enabled: Force Updated Clients'."
    exit 0
} else {
    Write-Host "Audit Failed: The 'Encryption Oracle Remediation' is not set to 'Enabled: Force Updated Clients'."
    Write-Host "Please ensure the Group Policy setting at 'Computer Configuration\Policies\Administrative Templates\System\Credentials Delegation\Encryption Oracle Remediation' is configured to 'Enabled: Force Updated Clients'."
    exit 1
}
# ```
