import sys, os, platform, subprocess, sqlite3, json, datetime

def check_os():
    """
    Check the operating system and return the OS type.
    
    Returns:
    str: The type of the operating system: "Ubuntu", "rhel_9", or "Windows".
    """
    # Check if the system is Linux
    if platform.system() == "Linux":
        # Try to determine if it's Ubuntu or rhel_9
            with open("/etc/os-release", "r") as f:
                os_info = f.read()
            if "Ubuntu" in os_info:
                return "Ubuntu"
            elif "Red Hat" in os_info or "rhel_9" in os_info or "fedora" in os_info:
                return "rhel_9"
            else:
                return "Windows"
    else:
        return "Windows"
def get_clean_linux_version():
    """
    Try to get the clean version name of the Linux distribution.
    For example, if the PRETTY_NAME is "Red Hat Enterprise Linux 9.0 (Plow)", return "Red Hat Enterprise Linux 9.0".
    If the file does not exist, return the result of platform.system(), which is "Linux".
    Returns:
    str: The clean version name of the Linux distribution.
    """
    try:
        with open("/etc/os-release", "r") as file:
            for line in file:
                if line.startswith("PRETTY_NAME="):
                    return line.split("=")[1].strip().replace('"', '')
    except FileNotFoundError:
        return platform.system()

def get_system_info():
    """
    Get information about the system such as the hostname, OS name, OS version,
    kernel version, machine architecture, and processor.

    Returns:
    dict: A dictionary containing the system information.
    """
    os_name = platform.system()
    hostname = os.uname()[1] if hasattr(os, 'uname') else platform.node()
    os_version = None
    kernel_version = None
    machine_arch = None
    processor = None

    if os_name == "Linux":
        os_version = get_clean_linux_version()
        kernel_version = platform.release()
        machine_arch = platform.machine()
        try:
            processor = subprocess.check_output("lscpu | grep 'Model name:'", shell=True).decode('utf-8').strip().split(":")[1].strip()
        except (subprocess.CalledProcessError, IndexError):
            processor = "Unknown"

    elif os_name == "Windows":
        os_version = '.'.join(platform.win32_ver()[1].split('.')[:2])
        kernel_version = platform.release()
        machine_arch = platform.machine()
        processor = platform.processor()

    elif os_name == "Darwin":
        os_version = platform.mac_ver()[0]
        kernel_version = platform.release()
        machine_arch = platform.machine()
        processor = platform.processor()

    else:
        os_version = "Unknown"
        kernel_version = "Unknown"
        machine_arch = "Unknown"
        processor = "Unknown"

    return {
        "hostname": f"HOSTNAME - {hostname}",
        "os_name": f"OS NAME - {os_name}",
        "os_version": f"OS VERSION - {os_version}",
        "kernel_version": f"KERNEL - {kernel_version}",
        "machine_arch": f"MACHINE ARCH - {machine_arch}",
        "processor": f"PROCESSOR - {processor}"
    }
