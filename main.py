import sys
from PySide6.QtWidgets import QApplication, QStackedWidget
from PySide6 import QtWidgets, QtCore
from PySide6.QtUiTools import QUiLoader
import platform
import os
import subprocess
import sqlite3
import json


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

def load_module_to_name():
    with open('tests/ubuntu_moduleToName.json', 'r') as file:
        return json.load(file)

def populate_script_list():
    audit_select_page.script_select_display.clear()
    script_dir = 'tests/scripts/audits'
    if os.path.isdir(script_dir):
        for script in sorted(os.listdir(script_dir)):
            script_name = os.path.splitext(script)[0]
            module_name = audit_select_page.module_to_name.get(script_name, script_name)
            list_item = QtWidgets.QListWidgetItem(module_name)
            list_item.setFlags(list_item.flags() | QtCore.Qt.ItemIsUserCheckable)
            list_item.setCheckState(QtCore.Qt.Unchecked)
            list_item.setData(QtCore.Qt.UserRole, script)
            audit_select_page.script_select_display.addItem(list_item)

def select_all_scripts():
    for index in range(audit_select_page.script_select_display.count()):
        item = audit_select_page.script_select_display.item(index)
        item.setCheckState(QtCore.Qt.Checked)

def create_tables():
    cursor = audit_select_page.database.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS audit_results (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            script_name TEXT,
            output TEXT,
            error TEXT,
            return_code INTEGER,
            execution_time TEXT
        )
    ''')
    audit_select_page.database.commit()

def run_script(script_path):
    try:
        os.chmod(script_path, 0o755)
        result = subprocess.run(["bash", script_path], capture_output=True, text=True)
        return result.stdout, result.stderr, result.returncode
    except subprocess.CalledProcessError as e:
        return e.stdout, e.stderr, e.returncode

def add_audit_result(result):
    cursor = audit_select_page.database.cursor()
    cursor.execute('''
        INSERT INTO audit_results (script_name, output, error, return_code, execution_time)
        VALUES (?, ?, ?, ?, datetime('now'))
    ''', (result['script_name'], result['output'], result['error'], result['return_code']))
    audit_select_page.database.commit()


def audit_selected_scripts():
    selected_items = [audit_select_page.script_select_display.item(i) for i in range(audit_select_page.script_select_display.count()) if audit_select_page.script_select_display.item(i).checkState() == QtCore.Qt.Checked]
    for item in selected_items:
        script_name = item.data(QtCore.Qt.UserRole)
        script_path = os.path.join('tests/scripts/audits', script_name)
        if not os.path.exists(script_path):
            print(f"Script not found: {script_path}")
            continue
        stdout, stderr, return_code = run_script(script_path)
        result = { 'script_name': script_name, 'output': stdout, 'error': stderr, 'return_code': return_code }
        add_audit_result(result)
    print("Audit completed")


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

    audit_select_page.module_to_name = load_module_to_name()
    audit_select_page.database = sqlite3.connect('audit_results.db')
    create_tables()
    populate_script_list()
    audit_select_page.select_all_btn.clicked.connect(select_all_scripts)
    audit_select_page.audit_btn.clicked.connect(audit_selected_scripts)

    main_window.show()
    sys.exit(app.exec())