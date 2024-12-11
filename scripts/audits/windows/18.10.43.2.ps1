#```powershell
# PowerShell 7 Script to Audit Microsoft Defender Application Guard Camera and Microphone Access
# This script checks the registry setting to ensure applications inside Microsoft Defender Application Guard
# cannot access the camera and microphone on the device.
# If the setting is as recommended (Disabled), it will exit with code 0. If not, it will prompt for manual review and exit with code 1.

# Define the registry path and name
$regPath = 'HKLM:\SOFTWARE\Policies\Microsoft\AppHVSI'
$regName = 'AllowCameraMicrophoneRedirection'

# Check if the registry value exists
if (Test-Path "$regPath") {
    # Retrieve the current value from the registry
    $regValue = Get-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue

    # Check if the value is set to 0 (Disabled)
    if ($regValue -eq 0) {
        Write-Output "Audit Passed: 'Allow camera and microphone access in Microsoft Defender Application Guard' is set to 'Disabled'."
        exit 0
    }
    else {
        Write-Warning "Audit Failed: 'Allow camera and microphone access in Microsoft Defender Application Guard' is not set to 'Disabled'."
        Write-Output "ACTION REQUIRED: Manually set the policy to 'Disabled' via Group Policy Editor or registry."
        Write-Output "Navigate to: Computer Configuration\\Policies\\Administrative Templates\\Windows Components\\Microsoft Defender Application Guard."
        Write-Output "Ensure the setting 'Allow camera and microphone access in Microsoft Defender Application Guard' is set to 'Disabled'."
        exit 1
    }
}
else {
    Write-Warning "Audit Failed: Required registry path does not exist. Cannot determine compliance."
    Write-Output "ACTION REQUIRED: Verify that Microsoft Defender Application Guard policies are correctly configured on this system."
    exit 1
}
# ```
