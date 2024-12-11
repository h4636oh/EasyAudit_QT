from PySide6.QtWidgets import QWidget, QPushButton, QLabel
from PySide6.QtUiTools import QUiLoader
from PySide6.QtCore import QFile
import platform
import os
import subprocess


def get_clean_linux_version():
    """Extracts a clean version of the Linux distribution name and version."""
    try:
        with open("/etc/os-release", "r") as file:
            for line in file:
                if line.startswith("PRETTY_NAME="):
                    return line.split("=")[1].strip().replace('"', '')
    except FileNotFoundError:
        return platform.system()

def get_system_info():
    # Detect the current operating system
    os_name = platform.system()
    
    # Get the hostname of the system
    hostname = os.uname()[1] if hasattr(os, 'uname') else platform.node()

    # Initialize placeholders for system info
    os_version = None
    kernel_version = None
    machine_arch = None
    processor = None

    # Handle Linux
    if os_name == "Linux":
        os_version = get_clean_linux_version()  # Get clean version (like Ubuntu 22.04)
        kernel_version = platform.release()
        machine_arch = platform.machine()
        try:
            processor = subprocess.check_output("lscpu | grep 'Model name:'", shell=True).decode('utf-8').strip().split(":")[1].strip()
        except (subprocess.CalledProcessError, IndexError):
            processor = "Unknown"

    # Handle Windows
    elif os_name == "Windows":
        os_version = '.'.join(platform.win32_ver()[1].split('.')[:2])  # Extract only the major.minor part
        kernel_version = platform.release()
        machine_arch = platform.machine()
        processor = platform.processor()

    # Handle macOS
    elif os_name == "Darwin":
        os_version = platform.mac_ver()[0]  # Get macOS version (like 13.2.1)
        kernel_version = platform.release()
        machine_arch = platform.machine()
        processor = platform.processor()

    else:
        # For unsupported systems, return a default message
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

        # Load the UI from the .ui file
        ui_file = QFile("start_page.ui")
        if ui_file.open(QFile.ReadOnly):
            loader = QUiLoader()  # Create the loader object
            self.ui = loader.load(ui_file, self)  # Load the UI file into this widget
            ui_file.close()
        
        # Access the UI elements directly from the loaded UI file
        self.new_audit_btn = self.ui.findChild(QPushButton, "new_audit_btn")
        self.cis_benchmark_btn = self.ui.findChild(QPushButton, "cis_benchmark_btn")
        
        # Access labels directly from the UI file
        self.hostname_lbl_entry = self.ui.findChild(QLabel, "hostname_lbl_entry")
        self.os_name_entry = self.ui.findChild(QLabel, "os_name_entry")
        self.os_version_lbl_entry = self.ui.findChild(QLabel, "os_version_lbl_entry")
        self.kernel_lbl_entry = self.ui.findChild(QLabel, "kernel_lbl_entry")
        self.mach_arch_lbl_entry = self.ui.findChild(QLabel, "mach_arch_lbl_entry")
        self.processor_lbl_entry = self.ui.findChild(QLabel, "processor_lbl_entry")

        # Connect the buttons to methods
        self.new_audit_btn.clicked.connect(self.on_new_audit_click)
        self.cis_benchmark_btn.clicked.connect(self.on_cis_benchmark_click)

        #Usage to set labels in the UI
        system_info = get_system_info()

        # Assuming the labels are already set up in the UI
        self.hostname_lbl_entry.setText(system_info["hostname"])
        self.os_name_entry.setText(system_info["os_name"])
        self.os_version_lbl_entry.setText(system_info["os_version"])
        self.kernel_lbl_entry.setText(system_info["kernel_version"])
        self.mach_arch_lbl_entry.setText(system_info["machine_arch"])
        self.processor_lbl_entry.setText(system_info["processor"])
  

    def on_new_audit_click(self):
        print("New Audit clicked")

    def on_cis_benchmark_click(self):
        print("CIS Benchmark clicked")