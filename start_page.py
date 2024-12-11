from PySide6.QtWidgets import QWidget, QPushButton, QLabel
from PySide6.QtUiTools import QUiLoader
from PySide6.QtCore import QFile
import platform
import os
import subprocess

def get_clean_linux_version():
    try:
        with open("/etc/os-release", "r") as file:
            for line in file:
                if line.startswith("PRETTY_NAME="):
                    return line.split("=")[1].strip().replace('"', '')
    except FileNotFoundError:
        return platform.system()

def get_system_info():
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
        "hostname": hostname,
        "os_name": os_name,
        "os_version": os_version,
        "kernel_version": kernel_version,
        "machine_arch": machine_arch,
        "processor": processor
    }

class MainMenu(QWidget):
    def __init__(self):
        super().__init__()
        # ui_file = QFile("start_page.ui")
        # if ui_file.open(QFile.ReadOnly):
        #     loader = QUiLoader()
        #     self.ui = loader.load(ui_file, self)
        #     ui_file.close()
        
        # self.new_audit_btn = self.ui.findChild(QPushButton, "new_audit_btn")
        # self.cis_benchmark_btn = self.ui.findChild(QPushButton, "cis_benchmark_btn")

        # system_info = get_system_info()
        # self.ui.findChild(QLabel, "hostname_lbl_entry").setText(system_info["hostname"])
        # self.ui.findChild(QLabel, "os_name_entry").setText(system_info["os_name"])
        # self.ui.findChild(QLabel, "os_version_lbl_entry").setText(system_info["os_version"])
        # self.ui.findChild(QLabel, "kernel_lbl_entry").setText(system_info["kernel_version"])
        # self.ui.findChild(QLabel, "mach_arch_lbl_entry").setText(system_info["machine_arch"])
        # self.ui.findChild(QLabel, "processor_lbl_entry").setText(system_info["processor"])