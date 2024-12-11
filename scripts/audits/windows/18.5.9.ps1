# This script audits the Safe DLL search mode configuration to ensure it is set to 'Enabled'.
# Profile Applicability: Level 1 (L1) - Corporate/Enterprise Environment

# Registry path and value details
$regPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager'
$valueName = 'SafeDllSearchMode'
$expectedValue = 1

try {
    # Check if the registry path exists
    if (-not (Test-Path -Path $regPath)) {
        Write-Error "Registry path does not exist: $regPath. Please verify that the policy is configured."
        exit 1
    }

    # Check if the registry value exists
    if (-not (Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction SilentlyContinue)) {
        Write-Error "Registry value does not exist: $valueName. Please ensure it is configured via Group Policy."
        exit 1
    }

    # Get the SafeDllSearchMode registry value
    $regValue = Get-ItemProperty -Path $regPath -Name $valueName -ErrorAction Stop | Select-Object -ExpandProperty $valueName

    # Compare the current value with the expected value
    if ($regValue -eq $expectedValue) {
        Write-Output "Safe DLL search mode is correctly set to 'Enabled'."
        exit 0
    } else {
        Write-Warning "Safe DLL search mode is NOT set to 'Enabled'. It is set to $regValue. Please enable it through Group Policy."
        exit 1
    }
} catch {
    Write-Error "Error accessing the registry or the specified value does not exist. Verify manually via the Group Policy."
    exit 1
}

# Additional instruction prompt if necessary
Write-Output "If the Group Policy setting is not visible, ensure that the MSS-legacy.admx/adml template is imported into Group Policy Management."
