import sys
from PySide6.QtWidgets import QApplication, QStackedWidget
from PySide6.QtUiTools import QUiLoader
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

class MainWindow(QStackedWidget):
    def __init__(self):
        super().__init__()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    main_window = MainWindow()

    # Load the start page UI file
    loader_start_page = QUiLoader()
    start_page = loader_start_page.load("start_page.ui", main_window)
    main_window.addWidget(start_page)

    # Get system information
    system_info = get_system_info()

    # Set label text for each system information entry
    start_page.hostname_lbl_entry.setText(system_info["hostname"])
    start_page.os_name_entry.setText(system_info["os_name"])
    start_page.os_version_lbl_entry.setText(system_info["os_version"])
    start_page.kernel_lbl_entry.setText(system_info["kernel_version"])
    start_page.mach_arch_lbl_entry.setText(system_info["machine_arch"])
    start_page.processor_lbl_entry.setText(system_info["processor"])

    # Connect buttons to methods
    loader_new_audit_page = QUiLoader()
    new_audit_page = loader_new_audit_page.load("new_audit_page.ui", main_window)
    main_window.addWidget(new_audit_page)
    start_page.new_audit_btn.clicked.connect(lambda: main_window.setCurrentIndex(1))

    loader_audit_select_page = QUiLoader()
    audit_select_page = loader_audit_select_page.load("audit_select_page.ui", main_window)
    main_window.addWidget(audit_select_page)

    isworkstation = None
    isserver = None
    islevel1 = None
    islevel2 = None
    isbitlocker = None
    def new_audit_filters():
        isworkstation = new_audit_page.workstation_btn.isChecked()
        isserver = new_audit_page.server_btn.isChecked()
        islevel1 = new_audit_page.level1_btn.isChecked()
        islevel2 = new_audit_page.level2_btn.isChecked()
        isbitlocker = new_audit_page.bitlocker_btn.isChecked()
        print(isworkstation, isserver, islevel1, islevel2, isbitlocker)
        main_window.setCurrentIndex(2)

    new_audit_page.continue_btn.clicked.connect(new_audit_filters)

    

    

    main_window.show()
    sys.exit(app.exec())