import sys, os, platform, subprocess, sqlite3, json, datetime
from osinformation import check_os


def run_script(script_path):
    """
    Run the script at the given path with the correct interpreter based on the current
    operating system. If the script is on Ubuntu or rhel_9, it is run with bash. If the
    script is on Windows, it is run with PowerShell. The script is run with the correct
    execution policy based on the operating system.

    Returns:
    stdout (str): The output of the script
    stderr (str): The error output of the script
    returncode (int): The return code of the script
    """
    try:
        os_name = check_os()
        if os_name == "Ubuntu":
            os.chmod(script_path, 0o755)
            result = subprocess.run(["bash", script_path], capture_output=True, text=True)
        if os_name == "rhel_9":
            os.chmod(script_path, 0o755)
            result = subprocess.run(["bash", script_path], capture_output=True, text=True)
        if os_name == "Windows":
            result = subprocess.run(
                ["powershell.exe",
                "-ExecutionPolicy", "Bypass",
                "-File", script_path],
                capture_output=True, text=True
            )
        return result.stdout, result.stderr, result.returncode
    except subprocess.CalledProcessError as e:
        return e.stdout, e.stderr, e.returncode
