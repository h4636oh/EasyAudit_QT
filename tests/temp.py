from PySide6.QtWidgets import QWidget, QPushButton, QLabel
from PySide6.QtUiTools import QUiLoader
from PySide6.QtCore import QFile
import platform
import os
import subprocess


def get_system_info():
    # Detect the current operating system
    os_name = platform.system()
    
    # Get the hostname of the system
    hostname = os.uname()[1] if hasattr(os, 'uname') else platform.node()

    # Initialize placeholders for other system info
    os_version = None
    kernel_version = None
    machine_arch = None
    processor = None

    # Handle Linux
    if os_name == "Linux":
        os_version = platform.version()
        kernel_version = platform.release()
        machine_arch = platform.machine()
        try:
            # Get detailed processor info using lscpu command
            processor = subprocess.check_output("lscpu", shell=True).decode('utf-8').strip().split("\n")[0]
        except subprocess.CalledProcessError:
            processor = "Unknown"

    # Handle Windows
    elif os_name == "Windows":
        os_version = platform.version()
        kernel_version = platform.release()
        machine_arch = platform.machine()
        processor = platform.processor()

    # Handle macOS
    elif os_name == "Darwin":
        os_version = platform.version()
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
        ui_file.open(QFile.ReadOnly)
        loader = QUiLoader()
        self.ui = loader.load(ui_file, self)
        ui_file.close()

        # Access the UI elements directly from the loaded UI file
        # self.new_audit_btn = self.ui.findChild(QPushButton, "new_audit_btn")
        # self.cis_benchmark_btn = self.ui.findChild(QPushButton, "cis_benchmark_btn")
        
        # # Access labels directly from the UI file
        # self.hostname_lbl_entry = self.ui.findChild(QLabel, "hostname_lbl_entry")
        # self.os_name_entry = self.ui.findChild(QLabel, "os_name_entry")
        # self.os_version_lbl_entry = self.ui.findChild(QLabel, "os_version_lbl_entry")
        # self.kernel_lbl_entry = self.ui.findChild(QLabel, "kernel_lbl_entry")
        # self.mach_arch_lbl_entry = self.ui.findChild(QLabel, "mach_arch_lbl_entry")
        # self.processor_lbl_entry = self.ui.findChild(QLabel, "processor_lbl_entry")

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
        Set default or sample information for the labels
        

        

    def on_new_audit_click(self):
        print("New Audit clicked")

    def on_cis_benchmark_click(self):
        print("CIS Benchmark clicked")