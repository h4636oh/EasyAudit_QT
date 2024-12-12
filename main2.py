import sys
from PySide6.QtWidgets import QApplication, QStackedWidget, QFileDialog
from PySide6 import QtWidgets, QtCore
from PySide6.QtUiTools import QUiLoader
import platform
import os
import subprocess
import sqlite3
import json
from PySide6.QtCore import QCoreApplication
from PySide6.QtGui import QDesktopServices
from PySide6.QtCore import QUrl
import datetime
from fpdf import FPDF

def bitlocker_status():
    if platform.system() == "Windows":
        new_audit_page.bitlocker_btn.setEnabled(True)
    else:
        new_audit_page.bitlocker_btn.setEnabled(False)

def check_os():
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

def open_cis_website():
    QDesktopServices.openUrl(QUrl("https://www.cisecurity.org/"))

###START PAGE INFORMATION###

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
        "hostname": f"HOSTNAME - {hostname}",
        "os_name": f"HOSTNAME - {os_name}",
        "os_version": f"HOSTNAME - {os_version}",
        "kernel_version": f"HOSTNAME - {kernel_version}",
        "machine_arch": f"HOSTNAME - {machine_arch}",
        "processor": f"HOSTNAME - {processor}"
    }

###-----------------###

WindowsL1=['1.1.1', '1.1.2', '1.1.3', '1.1.4', '1.1.5', '1.1.6', '1.1.7', '1.2.1', '1.2.2', '1.2.3', '1.2.4', '17.1.1', '17.2.1', '17.2.3', '17.3.1', '17.3.2', '17.5.1', '17.5.2', '17.5.3', '17.5.4', '17.5.5', '17.5.6', '17.6.1', '17.6.2', '17.6.3', '17.6.4', '17.7.1', '17.7.2', '17.7.3', '17.7.4', '17.7.5', '17.8.1', '17.9.1', '17.9.2', '17.9.3', '17.9.4', '17.9.5', '18.1.1.1', '18.1.1.2', '18.1.2.2', '18.1.3', '18.10.10.1', '18.10.12.1', '18.10.12.2', '18.10.12.3', '18.10.13.1', '18.10.14.1', '18.10.14.2', '18.10.14.3', '18.10.15.1', '18.10.15.2', '18.10.15.3', '18.10.15.4', '18.10.15.5', '18.10.15.6', '18.10.15.7', '18.10.15.8', '18.10.16.1', '18.10.17.1', '18.10.17.2', '18.10.17.3', '18.10.17.4', '18.10.25.1.1', '18.10.25.1.2', '18.10.25.2.1', '18.10.25.2.2', '18.10.25.3.1', '18.10.25.3.2', '18.10.25.4.1', '18.10.25.4.2', '18.10.28.2', '18.10.28.3', '18.10.28.4', '18.10.28.5', '18.10.3.1', '18.10.3.2', '18.10.36.1', '18.10.4.1', '18.10.40.1', '18.10.41.1', '18.10.42.10.1', '18.10.42.10.2', '18.10.42.10.3', '18.10.42.10.4', '18.10.42.12.1', '18.10.42.13.1', '18.10.42.13.2', '18.10.42.13.3', '18.10.42.16', '18.10.42.17', '18.10.42.5.1', '18.10.42.5.2', '18.10.42.6.1.1', '18.10.42.6.1.2', '18.10.42.6.3.1', '18.10.42.7.1', '18.10.43.1', '18.10.43.2', '18.10.43.3', '18.10.43.4', '18.10.43.5', '18.10.43.6', '18.10.49.1', '18.10.5.1', '18.10.5.2', '18.10.50.1', '18.10.55.1', '18.10.56.2.2', '18.10.56.2.3', '18.10.56.3.10.1', '18.10.56.3.10.2', '18.10.56.3.11.1', '18.10.56.3.2.1', '18.10.56.3.3.1', '18.10.56.3.3.2', '18.10.56.3.3.3', '18.10.56.3.3.4', '18.10.56.3.3.5', '18.10.56.3.3.6', '18.10.56.3.3.7', '18.10.56.3.9.1', '18.10.56.3.9.2', '18.10.56.3.9.3', '18.10.56.3.9.4', '18.10.56.3.9.5', '18.10.57.1', '18.10.58.2', '18.10.58.3', '18.10.58.4', '18.10.58.5', '18.10.58.6', '18.10.58.7', '18.10.62.1', '18.10.65.1', '18.10.65.2', '18.10.65.3', '18.10.65.4', '18.10.65.5', '18.10.7.1', '18.10.7.2', '18.10.7.3', '18.10.71.1', '18.10.75.1.1', '18.10.75.1.2', '18.10.75.1.3', '18.10.75.1.4', '18.10.75.1.5', '18.10.75.2.1', '18.10.77.1', '18.10.78.1', '18.10.79.1', '18.10.79.2', '18.10.8.1.1', '18.10.80.1', '18.10.80.2', '18.10.80.3', '18.10.81.1', '18.10.81.2', '18.10.86.1', '18.10.86.2', '18.10.88.1.1', '18.10.88.1.2', '18.10.88.1.3', '18.10.88.2.1', '18.10.88.2.2', '18.10.88.2.3', '18.10.88.2.4', '18.10.89.1', '18.10.9.1.1', '18.10.9.1.10', '18.10.9.1.11', '18.10.9.1.12', '18.10.9.1.13', '18.10.9.1.2', '18.10.9.1.3', '18.10.9.1.4', '18.10.9.1.5', '18.10.9.1.6', '18.10.9.1.7', '18.10.9.1.8', '18.10.9.1.9', '18.10.9.2.1', '18.10.9.2.10', '18.10.9.2.11', '18.10.9.2.12', '18.10.9.2.13', '18.10.9.2.14', '18.10.9.2.15', '18.10.9.2.16', '18.10.9.2.17', '18.10.9.2.18', '18.10.9.2.2', '18.10.9.2.3', '18.10.9.2.4', '18.10.9.2.5', '18.10.9.2.6', '18.10.9.2.7', '18.10.9.2.8', '18.10.9.2.9', '18.10.9.3.1', '18.10.9.3.10', '18.10.9.3.11', '18.10.9.3.12', '18.10.9.3.13', '18.10.9.3.14', '18.10.9.3.15', '18.10.9.3.2', '18.10.9.3.3', '18.10.9.3.4', '18.10.9.3.5', '18.10.9.3.6', '18.10.9.3.7', '18.10.9.3.8', '18.10.9.3.9', '18.10.9.4', '18.10.90.1', '18.10.90.2', '18.10.91.2.1', '18.10.92.1.1', '18.10.92.2.1', '18.10.92.2.2', '18.10.92.2.3', '18.10.92.2.4', '18.10.92.4.1', '18.10.92.4.2', '18.10.92.4.3', '18.10.92.4.4', '18.4.1', '18.4.2', '18.4.3', '18.4.4', '18.4.5', '18.4.6', '18.4.7', '18.5.1', '18.5.10', '18.5.11', '18.5.12', '18.5.13', '18.5.2', '18.5.3', '18.5.4', '18.5.5', '18.5.6', '18.5.7', '18.5.8', '18.5.9', '18.6.10.2', '18.6.11.2', '18.6.11.3', '18.6.14.1', '18.6.19.2.1', '18.6.20.1', '18.6.20.2', '18.6.21.1', '18.6.23.2.1', '18.6.4.1', '18.6.5.1', '18.6.8.1', '18.6.9.1', '18.6.9.2', '18.7.1', '18.7.10', '18.7.11', '18.7.2', '18.7.3', '18.7.4', '18.7.5', '18.7.6', '18.7.7', '18.7.8', '18.7.9', '18.8.1.1', '18.8.2', '18.9.13.1', '18.9.19.2', '18.9.20.1.1', '18.9.20.1.10', '18.9.20.1.11', '18.9.20.1.12', '18.9.20.1.13', '18.9.20.1.14', '18.9.20.1.2', '18.9.20.1.3', '18.9.20.1.4', '18.9.20.1.5', '18.9.20.1.6', '18.9.20.1.7', '18.9.20.1.8', '18.9.20.1.9', '18.9.23.1', '18.9.24.1', '18.9.26.1', '18.9.26.2', '18.9.27.1', '18.9.28.1', '18.9.28.2', '18.9.28.3', '18.9.28.4', '18.9.3.1', '18.9.31.1', '18.9.31.2', '18.9.33.6.1', '18.9.33.6.2', '18.9.33.6.3', '18.9.33.6.4', '18.9.33.6.5', '18.9.33.6.6', '18.9.35.1', '18.9.35.2', '18.9.36.1', '18.9.36.2', '18.9.4.1', '18.9.4.2', '18.9.47.11.1', '18.9.47.5.1', '18.9.49.1', '18.9.5.1', '18.9.5.2', '18.9.5.3', '18.9.5.4', '18.9.5.5', '18.9.5.6', '18.9.5.7', '18.9.51.1.1', '18.9.7.1.1', '18.9.7.1.2', '18.9.7.1.3', '18.9.7.1.4', '18.9.7.1.5', '18.9.7.1.6', '18.9.7.2', '19.5.1.1', '19.6.6.1.1', '19.7.26.1', '19.7.38.1', '19.7.42.1', '19.7.44.2.1', '19.7.5.1', '19.7.5.2', '19.7.8.1', '19.7.8.2', '19.7.8.3', '19.7.8.4', '19.7.8.5', '2.2.1', '2.2.10', '2.2.11', '2.2.12', '2.2.13', '2.2.14', '2.2.15', '2.2.16', '2.2.17', '2.2.18', '2.2.19', '2.2.2', '2.2.20', '2.2.21', '2.2.22', '2.2.23', '2.2.24', '2.2.25', '2.2.26', '2.2.27', '2.2.28', '2.2.29', '2.2.3', '2.2.30', '2.2.31', '2.2.32', '2.2.33', '2.2.34', '2.2.35', '2.2.36', '2.2.37', '2.2.38', '2.2.39', '2.2.4', '2.2.5', '2.2.6', '2.2.7', '2.2.8', '2.2.9', '2.3.1.1', '2.3.1.2', '2.3.1.3', '2.3.1.4', '2.3.1.5', '2.3.10.1', '2.3.10.10', '2.3.10.11', '2.3.10.12', '2.3.10.2', '2.3.10.3', '2.3.10.4', '2.3.10.5', '2.3.10.6', '2.3.10.7', '2.3.10.8', '2.3.10.9', '2.3.11.1', '2.3.11.10', '2.3.11.11', '2.3.11.12', '2.3.11.2', '2.3.11.3', '2.3.11.4', '2.3.11.5', '2.3.11.6', '2.3.11.7', '2.3.11.8', '2.3.11.9', '2.3.14.1', '2.3.15.1', '2.3.15.2', '2.3.17.1', '2.3.17.2', '2.3.17.3', '2.3.17.4', '2.3.17.5', '2.3.17.6', '2.3.17.7', '2.3.17.8', '2.3.2.1', '2.3.2.2', '2.3.4.1', '2.3.7.1', '2.3.7.2', '2.3.7.3', '2.3.7.4', '2.3.7.5', '2.3.7.6', '2.3.7.7', '2.3.7.8', '2.3.8.1', '2.3.8.2', '2.3.8.3', '2.3.9.1', '2.3.9.2', '2.3.9.3', '2.3.9.4', '2.3.9.5', '5.1', '5.11', '5.12', '5.13', '5.14', '5.15', '5.16', '5.17', '5.18', '5.19', '5.2', '5.21', '5.22', '5.23', '5.24', '5.25', '5.26', '5.27', '5.28', '5.29', '5.3', '5.31', '5.32', '5.33', '5.34', '5.35', '5.36', '5.37', '5.38', '5.39', '5.4', '5.41', '5.42', '5.43', '5.44', '5.5', '5.6', '5.7', '5.8', '5.9', '9.2.1', '9.2.2', '9.2.3', '9.2.4', '9.2.5', '9.2.6', '9.2.7', '9.3.1', '9.3.2', '9.3.3', '9.3.4', '9.3.5', '9.3.6', '9.3.7', '9.3.8', '9.3.9']

WindowsL2=['18.1.3', '18.10.10.1', '18.10.12.2', '18.10.15.2', '18.10.28.2', '18.10.3.1', '18.10.36.1', '18.10.40.1', '18.10.42.12.1', '18.10.42.5.2', '18.10.49.1', '18.10.5.2', '18.10.55.1', '18.10.56.2.2', '18.10.56.3.10.1', '18.10.56.3.10.2', '18.10.56.3.2.1', '18.10.56.3.3.1', '18.10.56.3.3.2', '18.10.56.3.3.4', '18.10.56.3.3.5', '18.10.56.3.3.6', '18.10.56.3.3.7', '18.10.58.2', '18.10.58.7', '18.10.62.1', '18.10.65.1', '18.10.65.5', '18.10.79.1', '18.10.80.3', '18.10.86.1', '18.10.86.2', '18.10.88.2.2', '18.10.89.1', '18.10.9.1.1', '18.10.9.1.10', '18.10.9.1.11', '18.10.9.1.12', '18.10.9.1.13', '18.10.9.1.2', '18.10.9.1.3', '18.10.9.1.4', '18.10.9.1.5', '18.10.9.1.6', '18.10.9.1.7', '18.10.9.1.8', '18.10.9.1.9', '18.10.9.2.1', '18.10.9.2.10', '18.10.9.2.11', '18.10.9.2.12', '18.10.9.2.13', '18.10.9.2.14', '18.10.9.2.15', '18.10.9.2.16', '18.10.9.2.17', '18.10.9.2.18', '18.10.9.2.2', '18.10.9.2.3', '18.10.9.2.4', '18.10.9.2.5', '18.10.9.2.6', '18.10.9.2.7', '18.10.9.2.8', '18.10.9.2.9', '18.10.9.3.1', '18.10.9.3.10', '18.10.9.3.11', '18.10.9.3.12', '18.10.9.3.13', '18.10.9.3.14', '18.10.9.3.15', '18.10.9.3.2', '18.10.9.3.3', '18.10.9.3.4', '18.10.9.3.5', '18.10.9.3.6', '18.10.9.3.7', '18.10.9.3.8', '18.10.9.3.9', '18.10.9.4', '18.5.11', '18.5.12', '18.5.4', '18.5.6', '18.5.8', '18.6.10.2', '18.6.19.2.1', '18.6.20.1', '18.6.20.2', '18.6.5.1', '18.6.9.1', '18.6.9.2', '18.8.1.1', '18.8.2', '18.9.20.1.1', '18.9.20.1.10', '18.9.20.1.11', '18.9.20.1.12', '18.9.20.1.13', '18.9.20.1.14', '18.9.20.1.3', '18.9.20.1.4', '18.9.20.1.5', '18.9.20.1.7', '18.9.20.1.8', '18.9.20.1.9', '18.9.23.1', '18.9.24.1', '18.9.27.1', '18.9.31.1', '18.9.31.2', '18.9.33.6.3', '18.9.33.6.4', '18.9.47.11.1', '18.9.47.5.1', '18.9.49.1', '18.9.7.1.1', '18.9.7.1.2', '18.9.7.1.3', '18.9.7.1.4', '18.9.7.1.5', '18.9.7.1.6', '19.6.6.1.1', '19.7.44.2.1', '19.7.8.3', '19.7.8.4', '2.2.28', '2.2.29', '2.3.14.1', '2.3.4.1', '2.3.7.3', '5.11', '5.13', '5.14', '5.15', '5.16', '5.17', '5.18', '5.19', '5.2', '5.21', '5.22', '5.24', '5.26', '5.28', '5.33', '5.34', '5.37', '5.38', '5.39', '5.5', '5.8']

WindowsBL=['18.10.9.1.1', '18.10.9.1.10', '18.10.9.1.11', '18.10.9.1.12', '18.10.9.1.13', '18.10.9.1.2', '18.10.9.1.3', '18.10.9.1.4', '18.10.9.1.5', '18.10.9.1.6', '18.10.9.1.7', '18.10.9.1.8', '18.10.9.1.9', '18.10.9.2.1', '18.10.9.2.10', '18.10.9.2.11', '18.10.9.2.12', '18.10.9.2.13', '18.10.9.2.14', '18.10.9.2.15', '18.10.9.2.16', '18.10.9.2.17', '18.10.9.2.18', '18.10.9.2.2', '18.10.9.2.3', '18.10.9.2.4', '18.10.9.2.5', '18.10.9.2.6', '18.10.9.2.7', '18.10.9.2.8', '18.10.9.2.9', '18.10.9.3.1', '18.10.9.3.10', '18.10.9.3.11', '18.10.9.3.12', '18.10.9.3.13', '18.10.9.3.14', '18.10.9.3.15', '18.10.9.3.2', '18.10.9.3.3', '18.10.9.3.4', '18.10.9.3.5', '18.10.9.3.6', '18.10.9.3.7', '18.10.9.3.8', '18.10.9.3.9', '18.10.9.4', '18.9.24.1', '18.9.33.6.3', '18.9.33.6.4', '18.9.7.1.1', '18.9.7.1.2', '18.9.7.1.3', '18.9.7.1.4', '18.9.7.1.5', '18.9.7.1.6', '2.3.7.3']
           
UbantuL1=['1.1.1.1', '1.1.1.2', '1.1.1.3', '1.1.1.4', '1.1.1.5', '1.1.2.1.1', '1.1.2.1.2', '1.1.2.1.3', '1.1.2.1.4', '1.1.2.2.1', '1.1.2.2.2', '1.1.2.2.3', '1.1.2.2.4', '1.1.2.3.2', '1.1.2.3.3', '1.1.2.4.2', '1.1.2.4.3', '1.1.2.5.2', '1.1.2.5.3', 'Ensure', '1.1.2.6.2', '1.1.2.6.3', '1.1.2.6.4', '1.1.2.7.2', '1.1.2.7.3', '1.1.2.7.4', '1.2.1.1', '1.2.1.2', '1.2.2.1', 'Internal', '1.3.1.2', '1.3.1.3', '1.4.1', '1.4.2', '1.5.1', '1.5.2', '1.5.3', '1.5.4', '1.5.5', '1.6.1', '1.6.2', '1.6.3', '1.6.4', '1.6.5', '1.6.6', '1.7.10', '1.7.2', '1.7.3', '1.7.4', '1.7.5', '1.7.8', '1.7.9', '2.1.10', '2.1.12', '2.1.13', '2.1.14', '2.1.15', '2.1.16', '2.1.17', '2.1.18', '2.1.19', '2.1.21', '2.1.22', '2.1.3', '2.1.4', '2.1.5', '2.1.6', '2.1.7', '2.1.8', '2.1.9', '2.2.1', '2.2.2', '2.2.3', '2.2.4', '2.2.5', '2.2.6', '2.3.1.1', '2.3.2.1', '2.3.2.2', '2.3.3.1', '2.3.3.2', '2.3.3.3', '2.4.1.1', '2.4.1.2', '2.4.1.3', '2.4.1.4', '2.4.1.5', '2.4.1.6', '2.4.1.7', '2.4.1.8', '2.4.2.1', '3.1.1', '3.3.1', '3.3.10', '3.3.11', '3.3.2', '3.3.3', '3.3.4', '3.3.5', '3.3.6', '3.3.7', '3.3.8', '3.3.9', '4.1.1', '4.1.2', '4.1.3', '4.1.4', '4.1.5', '4.1.6', '4.1.7', '4.2.1', '4.2.10', '4.2.2', '4.2.3', '4.2.4', '4.2.5', '4.2.6', '4.2.7', '4.2.8', '4.2.9', '4.3.1.1', '4.3.1.2', '4.3.1.3', '4.3.2.1', '4.3.2.2', '4.3.2.3', '4.3.2.4', '4.3.3.1', '4.3.3.2', '4.3.3.3', '4.3.3.4', '5.1.1', '5.1.10', '5.1.11', '5.1.12', '5.1.13', '5.1.14', '5.1.15', '5.1.16', '5.1.17', '5.1.18', '5.1.19', '5.1.2', '5.1.20', '5.1.21', '5.1.22', '5.1.3', '5.1.4', '5.1.5', '5.1.6', '5.1.7', '5.1.8', '5.1.9', '5.2.1', '5.2.2', '5.2.3', '5.2.5', '5.2.6', '5.2.7', '5.3.1.1', '5.3.1.2', '5.3.2.1', '5.3.2.2', '5.3.2.3', '5.3.2.4', '5.3.3.1.1', '5.3.3.1.2', '5.3.3.2.1', '5.3.3.2.2', '5.3.3.2.3', '5.3.3.2.4', '5.3.3.2.5', '5.3.3.2.6', '5.3.3.2.7', '5.3.3.2.8', '5.3.3.3.1', '5.3.3.3.2', '5.3.3.3.3', '5.3.3.4.1', '5.3.3.4.2', '5.3.3.4.3', '5.3.3.4.4', '5.4.1.1', '5.4.1.3', '5.4.1.4', '5.4.1.5', '5.4.1.6', '5.4.2.1', '5.4.2.3', '5.4.2.4', '5.4.2.5', '5.4.2.6', '5.4.2.7', '5.4.2.8', '5.4.3.3', '6.1.1', '6.1.2', '6.2.1.1.1', '6.2.1.1.2', '6.2.1.1.3', '6.2.1.1.4', '6.2.1.1.5', '6.2.1.1.6', '6.2.1.2.1', '6.2.1.2.2', '6.2.1.2.3', '6.2.1.2.4', '6.2.2.1', '7.1.1', '7.1.10', '7.1.11', '7.1.12', '7.1.13', '7.1.2', '7.1.3', '7.1.4', '7.1.5', '7.1.6', '7.1.7', '7.1.8', '7.1.9', '7.2.1', '7.2.10', '7.2.2', '7.2.3', '7.2.4', '7.2.5', '7.2.7', '7.2.8', '7.2.9']          

UbantuL2=['1.1.1.6', '1.1.1.7', '1.1.1.8', '1.1.2.3.1', '1.1.2.4.1', '1.1.2.5.1', '1.1.2.6.1', '1.1.2.7.1', '1.3.1.4', '1.7.6', '1.7.7', '2.1.1', '2.1.11', '2.1.2', '3.1.3', '3.2.1', '3.2.2', '3.2.3', '3.2.4', '5.2.4', '5.3.3.1.3', '5.4.1.2', '5.4.3.1', '6.1.3', '6.3.1.1', '6.3.1.2', '6.3.1.3', '6.3.1.4', '6.3.2.1', '6.3.2.2', '6.3.2.3', '6.3.2.4', '6.3.3.1', '6.3.3.10', '6.3.3.11', '6.3.3.12', '6.3.3.13', '6.3.3.14', '6.3.3.15', '6.3.3.16', '6.3.3.17', '6.3.3.18', '6.3.3.19', '6.3.3.2', '6.3.3.20', '6.3.3.21', '6.3.3.3', '6.3.3.4', '6.3.3.5', '6.3.3.6', '6.3.3.7', '6.3.3.8', '6.3.3.9', '6.3.4.1', '6.3.4.10', '6.3.4.2', '6.3.4.3', '6.3.4.4', '6.3.4.5', '6.3.4.6', '6.3.4.7', '6.3.4.8', '6.3.4.9']

UbantuSL1=['1.1.1.1', '1.1.1.2', '1.1.1.3', '1.1.1.4', '1.1.1.5', '1.1.1.6', '1.1.1.7', '1.1.1.8', '1.1.2.1.1', '1.1.2.1.2', '1.1.2.1.3', '1.1.2.1.4', '1.1.2.2.1', '1.1.2.2.2', '1.1.2.2.3', '1.1.2.2.4', '1.1.2.3.1', '1.1.2.3.2', '1.1.2.3.3', '1.1.2.4.1', '1.1.2.4.2', '1.1.2.4.3', '1.1.2.5.1', '1.1.2.5.2', '1.1.2.5.3', 'Ensure', '1.1.2.6.1', '1.1.2.6.2', '1.1.2.6.3', '1.1.2.6.4', '1.1.2.7.1', '1.1.2.7.2', '1.1.2.7.3', '1.1.2.7.4', '1.2.1.1', '1.2.1.2', '1.2.2.1', 'Internal', '1.3.1.2', '1.3.1.3', '1.3.1.4', '1.4.1', '1.4.2', '1.5.1', '1.5.2', '1.5.3', '1.5.4', '1.5.5', '1.6.1', '1.6.2', '1.6.3', '1.6.4', '1.6.5', '1.6.6', '1.7.1', '1.7.10', '1.7.2', '1.7.3', '1.7.4', '1.7.5', '1.7.6', '1.7.7', '1.7.8', '1.7.9', '2.1.1', '2.1.10', '2.1.11', '2.1.12', '2.1.13', '2.1.14', '2.1.15', '2.1.16', '2.1.17', '2.1.18', '2.1.19', '2.1.2', '2.1.20', '2.1.21', '2.1.22', '2.1.3', '2.1.4', '2.1.5', '2.1.6', '2.1.7', '2.1.8', '2.1.9', '2.2.1', '2.2.2', '2.2.3', '2.2.4', '2.2.5', '2.2.6', '2.3.1.1', '2.3.2.1', '2.3.2.2', '2.3.3.1', '2.3.3.2', '2.3.3.3', '2.4.1.1', '2.4.1.2', '2.4.1.3', '2.4.1.4', '2.4.1.5', '2.4.1.6', '2.4.1.7', '2.4.1.8', '2.4.2.1', '3.1.1', '3.1.2', '3.1.3', '3.2.1', '3.2.2', '3.2.3', '3.2.4', '3.3.1', '3.3.10', '3.3.11', '3.3.2', '3.3.3', '3.3.4', '3.3.5', '3.3.6', '3.3.7', '3.3.8', '3.3.9', '4.1.1', '4.1.2', '4.1.3', '4.1.4', '4.1.5', '4.1.6', '4.1.7', '4.2.1', '4.2.10', '4.2.2', '4.2.3', '4.2.4', '4.2.5', '4.2.6', '4.2.7', '4.2.8', '4.2.9', '4.3.1.1', '4.3.1.2', '4.3.1.3', '4.3.2.1', '4.3.2.2', '4.3.2.3', '4.3.2.4', '4.3.3.1', '4.3.3.2', '4.3.3.3', '4.3.3.4', '5.1.1', '5.1.10', '5.1.11', '5.1.12', '5.1.13', '5.1.14', '5.1.15', '5.1.16', '5.1.17', '5.1.18', '5.1.19', '5.1.2', '5.1.20', '5.1.21', '5.1.22', '5.1.3', '5.1.4', '5.1.5', '5.1.6', '5.1.7', '5.1.8', '5.1.9', '5.2.1', '5.2.2', '5.2.3', '5.2.4', '5.2.5', '5.2.6', '5.2.7', '5.3.1.1', '5.3.1.2', '5.3.2.1', '5.3.2.2', '5.3.2.3', '5.3.2.4', '5.3.3.1.1', '5.3.3.1.2', '5.3.3.1.3', '5.3.3.2.1', '5.3.3.2.2', '5.3.3.2.3', '5.3.3.2.4', '5.3.3.2.5', '5.3.3.2.6', '5.3.3.2.7', '5.3.3.2.8', '5.3.3.3.1', '5.3.3.3.2', '5.3.3.3.3', '5.3.3.4.1', '5.3.3.4.2', '5.3.3.4.3', '5.3.3.4.4', '5.4.1.1', '5.4.1.2', '5.4.1.3', '5.4.1.4', '5.4.1.5', '5.4.1.6', '5.4.2.1', '5.4.2.3', '5.4.2.4', '5.4.2.5', '5.4.2.6', '5.4.2.7', '5.4.2.8', '5.4.3.1', '5.4.3.3', '6.1.1', '6.1.2', '6.1.3', '6.2.1.1.1', '6.2.1.1.2', '6.2.1.1.3', '6.2.1.1.4', '6.2.1.1.5', '6.2.1.1.6', '6.2.1.2.1', '6.2.1.2.2', '6.2.1.2.3', '6.2.1.2.4', '6.2.2.1', '6.3.1.1', '6.3.1.2', '6.3.1.3', '6.3.1.4', '6.3.2.1', '6.3.2.2', '6.3.2.3', '6.3.2.4', '6.3.3.1', '6.3.3.10', '6.3.3.11', '6.3.3.12', '6.3.3.13', '6.3.3.14', '6.3.3.15', '6.3.3.16', '6.3.3.17', '6.3.3.18', '6.3.3.19', '6.3.3.2', '6.3.3.20', '6.3.3.21', '6.3.3.3', '6.3.3.4', '6.3.3.5', '6.3.3.6', '6.3.3.7', '6.3.3.8', '6.3.3.9', '6.3.4.1', '6.3.4.10', '6.3.4.2', '6.3.4.3', '6.3.4.4', '6.3.4.5', '6.3.4.6', '6.3.4.7', '6.3.4.8', '6.3.4.9', '7.1.1', '7.1.10', '7.1.11', '7.1.12', '7.1.13', '7.1.2', '7.1.3', '7.1.4', '7.1.5', '7.1.6', '7.1.7', '7.1.8', '7.1.9', '7.2.1', '7.2.10', '7.2.2', '7.2.3', '7.2.4', '7.2.5', '7.2.7', '7.2.8', '7.2.9'] 

UbantuSL2=['1.1.1.6', '1.1.1.7', '1.1.2.3.1', '1.1.2.4.1', '1.1.2.5.1', '1.1.2.6.1', '1.1.2.7.1', '1.3.1.4', '1.7.1', '2.1.20', '3.2.1', '3.2.2', '3.2.3', '3.2.4', '5.1.8', '5.1.9', '5.2.4', '5.3.3.1.3', '5.4.1.2', '5.4.3.1', '6.1.3', '6.3.1.1', '6.3.1.2', '6.3.1.3', '6.3.1.4', '6.3.2.1', '6.3.2.2', '6.3.2.3', '6.3.2.4', '6.3.3.1', '6.3.3.10', '6.3.3.11', '6.3.3.12', '6.3.3.13', '6.3.3.14', '6.3.3.15', '6.3.3.16', '6.3.3.17', '6.3.3.18', '6.3.3.19', '6.3.3.2', '6.3.3.20', '6.3.3.21', '6.3.3.3', '6.3.3.4', '6.3.3.5', '6.3.3.6', '6.3.3.7', '6.3.3.8', '6.3.3.9', '6.3.4.1', '6.3.4.10', '6.3.4.2', '6.3.4.3', '6.3.4.4', '6.3.4.5', '6.3.4.6', '6.3.4.7', '6.3.4.8', '6.3.4.9']

rehlL1=['1.1.1.1', '1.1.1.2', '1.1.1.3', '1.1.1.4', '1.1.1.5', '1.1.1.9', '1.1.2.1.1', '1.1.2.1.2', '1.1.2.1.3', '1.1.2.1.4', '1.1.2.2.1', '1.1.2.2.2', '1.1.2.2.3', '1.1.2.2.4', '1.1.2.3.2', '1.1.2.3.3', '1.1.2.4.2', '1.1.2.4.3', '1.1.2.5.2', '1.1.2.5.3', '1.1.2.5.4', '1.1.2.6.2', '1.1.2.6.3', '1.1.2.6.4', '1.1.2.7.2', '1.1.2.7.3', '1.1.2.7.4', '1.2.1.1', '1.2.1.2', '1.2.1.4', '1.2.2.1', '1.3.1.1', '1.3.1.2', '1.3.1.3', '1.3.1.4', '1.3.1.7', '1.4.1', '1.4.2', '1.5.1', '1.5.2', '1.5.3', '1.5.4', '1.6.1', '1.6.2', '1.6.3', '1.6.4', '1.6.5', '1.6.6', '1.6.7', '1.7.1', '1.7.2', '1.7.3', '1.7.4', '1.7.5', '1.7.6', '1.8.10', '1.8.2', '1.8.3', '1.8.4', '1.8.5', '1.8.8', '1.8.9', '2.1.10', '2.1.12', '2.1.13', '2.1.14', '2.1.15', '2.1.16', '2.1.17', '2.1.18', '2.1.19', '2.1.21', '2.1.22', '2.1.3', '2.1.4', '2.1.5', 'CIS', '2.1.7', '2.1.8', '2.1.9', '2.2.1', '2.2.3', '2.2.4', '2.2.5', '2.3.1', '2.3.2', '2.3.3', '2.4.1.1', '2.4.1.2', '2.4.1.3', '2.4.1.4', '2.4.1.5', '2.4.1.6', '2.4.1.7', '2.4.1.8', '2.4.2.1', '3.1.1', '3.3.1', '3.3.10', '3.3.11', '3.3.2', '3.3.3', '3.3.4', '3.3.5', '3.3.6', '3.3.7', '3.3.8', '3.3.9', '4.1.1', '4.1.2', '4.2.1', '4.2.2', '4.3.1', '4.3.2', '4.3.3', '4.3.4', '5.1.1', '5.1.10', '5.1.11', '5.1.12', '5.1.13', '5.1.14', '5.1.15', '5.1.16', '5.1.17', '5.1.18', '5.1.19', '5.1.2', '5.1.20', '5.1.21', '5.1.22', '5.1.3', '5.1.4', '5.1.5', '5.1.6', '5.1.7', '5.1.8', '5.1.9', '5.2.1', '5.2.2', '5.2.3', '5.2.5', '5.2.6', '5.2.7', '5.3.1.1', '5.3.1.2', '5.3.1.3', '5.3.2.1', '5.3.2.2', '5.3.2.3', '5.3.2.4', '5.3.2.5', '5.3.3.1.1', '5.3.3.1.2', '5.3.3.2.1', '5.3.3.2.2', '5.3.3.2.3', '5.3.3.2.4', '5.3.3.2.5', '5.3.3.2.6', '5.3.3.2.7', '5.3.3.3.1', '5.3.3.3.2', '5.3.3.3.3', '5.3.3.4.1', '5.3.3.4.2', '5.3.3.4.3', '5.3.3.4.4', '5.4.1.1', '5.4.1.3', '5.4.1.4', '5.4.1.5', '5.4.1.6', '5.4.2.1', '5.4.2.2', '5.4.2.3', '5.4.2.4', '5.4.2.5', '5.4.2.6', '5.4.2.7', '5.4.2.8', '5.4.3.2', '5.4.3.3', '6.1.1', '6.1.2', '6.1.3', '6.2.1.1', '6.2.1.2', '6.2.1.3', '6.2.1.4', '6.2.2.1.2', '6.2.2.1.3', '6.2.2.1.4', '6.2.2.2', '6.2.2.3', '6.2.2.4', '6.2.3.1', '6.2.3.2', '6.2.3.3', '6.2.3.4', '6.2.3.5', '6.2.3.6', '6.2.3.7', '6.2.3.8', '6.2.4.1', '7.1.1', '7.1.10', '7.1.11', '7.1.12', '7.1.13', '7.1.2', '7.1.3', '7.1.4', '7.1.5', '7.1.6', '7.1.7', '7.1.8', '7.1.9', '7.2.1', '7.2.2', '7.2.3', '7.2.4', '7.2.5', '7.2.6', '7.2.7', '7.2.8', '7.2.9']

rehlL2=['1.1.1.6', '1.1.1.7', '1.1.1.8', '1.1.2.3.1', '1.1.2.4.1', '1.1.2.5.1', '1.1.2.6.1', '1.1.2.7.1', '1.2.1.3', '1.3.1.5', '1.3.1.6', '1.8.6', '1.8.7', '2.1.1', '2.1.2', '2.2.2', '3.1.3', '3.2.1', '3.2.2', '3.2.3', '3.2.4', '5.2.4', '5.3.3.1.3', '5.4.1.2', '5.4.3.1', '6.3.1.1', '6.3.1.2', '6.3.1.3', '6.3.1.4', '6.3.2.1', '6.3.2.2', '6.3.2.3', '6.3.2.4', '6.3.3.1', '6.3.3.10', '6.3.3.11', '6.3.3.12', '6.3.3.13', '6.3.3.14', '6.3.3.15', '6.3.3.16', '6.3.3.17', '6.3.3.18', '6.3.3.19', '6.3.3.2', '6.3.3.20', '6.3.3.21', '6.3.3.3', '6.3.3.4', '6.3.3.5', '6.3.3.6', '6.3.3.7', '6.3.3.8', '6.3.3.9', '6.3.4.1', '6.3.4.10', '6.3.4.2', '6.3.4.3', '6.3.4.4', '6.3.4.5', '6.3.4.6', '6.3.4.7', '6.3.4.8', '6.3.4.9']

rehlSL1=[['1.1.1.1', '1.1.1.2', '1.1.1.3', '1.1.1.4', '1.1.1.5', '1.1.1.6', '1.1.1.7', '1.1.1.8', '1.1.1.9', '1.1.2.1.1', '1.1.2.1.2', '1.1.2.1.3', '1.1.2.1.4', '1.1.2.2.1', '1.1.2.2.2', '1.1.2.2.3', '1.1.2.2.4', '1.1.2.3.1', '1.1.2.3.2', '1.1.2.3.3', '1.1.2.4.1', '1.1.2.4.2', '1.1.2.4.3', '1.1.2.5.1', '1.1.2.5.2', '1.1.2.5.3', '1.1.2.5.4', '1.1.2.6.1', '1.1.2.6.2', '1.1.2.6.3', '1.1.2.6.4', '1.1.2.7.1', '1.1.2.7.2', '1.1.2.7.3', '1.1.2.7.4', '1.2.1.1', '1.2.1.2', '1.2.1.3', '1.2.1.4', '1.2.2.1', '1.3.1.1', '1.3.1.2', '1.3.1.3', '1.3.1.4', '1.3.1.5', '1.3.1.6', '1.3.1.7', '1.3.1.8', '1.4.1', '1.4.2', '1.5.1', '1.5.2', '1.5.3', '1.5.4', '1.6.1', '1.6.2', '1.6.3', '1.6.4', '1.6.5', '1.6.6', '1.6.7', '1.7.1', '1.7.2', '1.7.3', '1.7.4', '1.7.5', '1.7.6', '1.8.1', '1.8.10', '1.8.2', '1.8.3', '1.8.4', '1.8.5', '1.8.6', '1.8.7', '1.8.8', '1.8.9', '2.1.1', '2.1.10', '2.1.11', '2.1.12', '2.1.13', '2.1.14', '2.1.15', '2.1.16', '2.1.17', '2.1.18', '2.1.19', '2.1.2', '2.1.20', '2.1.21', '2.1.22', '2.1.3', '2.1.4', '2.1.5', 'CIS', '2.1.7', '2.1.8', '2.1.9', '2.2.1', '2.2.2', '2.2.3', '2.2.4', '2.2.5', '2.3.1', '2.3.2', '2.3.3', '2.4.1.1', '2.4.1.2', '2.4.1.3', '2.4.1.4', '2.4.1.5', '2.4.1.6', '2.4.1.7', '2.4.1.8', '2.4.2.1', '3.1.1', '3.1.2', '3.1.3', '3.2.1', '3.2.2', '3.2.3', '3.2.4', '3.3.1', '3.3.10', '3.3.11', '3.3.2', '3.3.3', '3.3.4', '3.3.5', '3.3.6', '3.3.7', '3.3.8', '3.3.9', '4.1.1', '4.1.2', '4.2.1', '4.2.2', '4.3.1', '4.3.2', '4.3.3', '4.3.4', '5.1.1', '5.1.10', '5.1.11', '5.1.12', '5.1.13', '5.1.14', '5.1.15', '5.1.16', '5.1.17', '5.1.18', '5.1.19', '5.1.2', '5.1.20', '5.1.21', '5.1.22', '5.1.3', '5.1.4', '5.1.5', '5.1.6', '5.1.7', '5.1.8', '5.1.9', '5.2.1', '5.2.2', '5.2.3', '5.2.4', '5.2.5', '5.2.6', '5.2.7', '5.3.1.1', '5.3.1.2', '5.3.1.3', '5.3.2.1', '5.3.2.2', '5.3.2.3', '5.3.2.4', '5.3.2.5', '5.3.3.1.1', '5.3.3.1.2', '5.3.3.1.3', '5.3.3.2.1', '5.3.3.2.2', '5.3.3.2.3', '5.3.3.2.4', '5.3.3.2.5', '5.3.3.2.6', '5.3.3.2.7', '5.3.3.3.1', '5.3.3.3.2', '5.3.3.3.3', '5.3.3.4.1', '5.3.3.4.2', '5.3.3.4.3', '5.3.3.4.4', '5.4.1.1', '5.4.1.2', '5.4.1.3', '5.4.1.4', '5.4.1.5', '5.4.1.6', '5.4.2.1', '5.4.2.2', '5.4.2.3', '5.4.2.4', '5.4.2.5', '5.4.2.6', '5.4.2.7', '5.4.2.8', '5.4.3.1', '5.4.3.2', '5.4.3.3', '6.1.1', '6.1.2', '6.1.3', '6.2.1.1', '6.2.1.2', '6.2.1.3', '6.2.1.4', '6.2.2.1.2', '6.2.2.1.3', '6.2.2.1.4', '6.2.2.2', '6.2.2.3', '6.2.2.4', '6.2.3.1', '6.2.3.2', '6.2.3.3', '6.2.3.4', '6.2.3.5', '6.2.3.6', '6.2.3.7', '6.2.3.8', '6.2.4.1', '6.3.1.1', '6.3.1.2', '6.3.1.3', '6.3.1.4', '6.3.2.1', '6.3.2.2', '6.3.2.3', '6.3.2.4', '6.3.3.1', '6.3.3.10', '6.3.3.11', '6.3.3.12', '6.3.3.13', '6.3.3.14', '6.3.3.15', '6.3.3.16', '6.3.3.17', '6.3.3.18', '6.3.3.19', '6.3.3.2', '6.3.3.20', '6.3.3.21', '6.3.3.3', '6.3.3.4', '6.3.3.5', '6.3.3.6', '6.3.3.7', '6.3.3.8', '6.3.3.9', '6.3.4.1', '6.3.4.10', '6.3.4.2', '6.3.4.3', '6.3.4.4', '6.3.4.5', '6.3.4.6', '6.3.4.7', '6.3.4.8', '6.3.4.9', '7.1.1', '7.1.10', '7.1.11', '7.1.12', '7.1.13', '7.1.2', '7.1.3', '7.1.4', '7.1.5', '7.1.6', '7.1.7', '7.1.8', '7.1.9', '7.2.1', '7.2.2', '7.2.3', '7.2.4', '7.2.5', '7.2.6', '7.2.7', '7.2.8', '7.2.9'] ]

rehlL2=['1.1.1.6', '1.1.1.7', '1.1.2.3.1', '1.1.2.4.1', '1.1.2.5.1', '1.1.2.6.1', '1.1.2.7.1', '1.2.1.3', '1.3.1.5', '1.3.1.6', '1.8.1', '2.1.20', '2.2.2', '3.2.1', '3.2.2', '3.2.3', '3.2.4', '5.1.10', '5.1.11', '5.2.4', '5.3.3.1.3', '5.4.1.2', '5.4.3.1', '6.3.1.1', '6.3.1.2', '6.3.1.3', '6.3.1.4', '6.3.2.1', '6.3.2.2', '6.3.2.3', '6.3.2.4', '6.3.3.1', '6.3.3.10', '6.3.3.11', '6.3.3.12', '6.3.3.13', '6.3.3.14', '6.3.3.15', '6.3.3.16', '6.3.3.17', '6.3.3.18', '6.3.3.19', '6.3.3.2', '6.3.3.20', '6.3.3.21', '6.3.3.3', '6.3.3.4', '6.3.3.5', '6.3.3.6', '6.3.3.7', '6.3.3.8', '6.3.3.9', '6.3.4.1', '6.3.4.10', '6.3.4.2', '6.3.4.3', '6.3.4.4', '6.3.4.5', '6.3.4.6', '6.3.4.7', '6.3.4.8', '6.3.4.9']
### LOADS MODULE TO NAME DICTIONARY ###
def load_complete_json():
    os_name = check_os()
    file_name = os_name + ".json"
    file_path = os.path.join('scripts', file_name)
    with open(file_path, 'r',encoding='utf-8') as file:
        return json.load(file)

def load_module_to_name():
    os_name = check_os()
    file_name = os_name + "_moduleToName.json"
    file_path = os.path.join('scripts', file_name)
    with open(file_path, 'r') as file:
        return json.load(file)

### ADDS SCRIPTS TO THE AUDIT SELECT PAGE DISPLAY SECTION ###

def search_bar_filter_select_page():
    search_text = audit_select_page.search_bar.text()
    for i in range(audit_select_page.script_select_display.count()):
        item = audit_select_page.script_select_display.item(i)
        if search_text.lower() in item.text().lower():
            item.setHidden(False)
        else:
            item.setHidden(True)

def search_bar_filter_result_page():
    search_text = audit_result_page.search_bar.text()
    for i in range(audit_result_page.audit_results_list_widget.count()):
        item = audit_result_page.audit_results_list_widget.item(i)
        if search_text.lower() in item.text().lower():
            item.setHidden(False)
        else:
            item.setHidden(True)

def audit_select_page_populate_script_list():
    audit_select_page.script_select_display.clear()
    os_name = check_os()
    script_dir = None
    if os_name == "Ubuntu":
        script_dir = 'scripts/audits/ubuntu'
    if os_name == "rhel_9":
        script_dir = 'scripts/audits/rhel_9'
    if os_name == "Windows":
        script_dir = 'scripts/audits/windows'
    if os.path.isdir(script_dir):
        module_info = load_complete_json()
        for script in sorted(os.listdir(script_dir)):
            script_name = os.path.splitext(script)[0]
            script_name = script_name.replace(".audit", "")
            script_info = module_info[script_name] if script_name in module_info else print(f"error : {script_name}", f"script")
            description = script_info["Description"] if script_info else "NULL"
            tooltip_text = description
            module_name = audit_select_page.module_to_name.get(script_name, script_name)
            list_item = QtWidgets.QListWidgetItem(module_name)
            list_item.setFlags(list_item.flags() | QtCore.Qt.ItemIsUserCheckable)
            list_item.setCheckState(QtCore.Qt.Unchecked)
            list_item.setData(QtCore.Qt.UserRole, script)
            list_item.setToolTip(tooltip_text)
            audit_select_page.script_select_display.addItem(list_item)

### SELECTS ALL SCRIPTS ON AUDIT SELECT PAGE (SELECT ALL BUTTON SLOT) ###

def audit_select_page_select_all_scripts():
    if audit_select_page.select_all_btn.isChecked():
        loader_select_all_warning = QUiLoader()
        select_all_warning = loader_select_all_warning.load('select_all_warning.ui', audit_select_page)
        select_all_warning.show()
        for index in range(audit_select_page.script_select_display.count()):
            item = audit_select_page.script_select_display.item(index)
            item.setCheckState(QtCore.Qt.Checked)
    else:
        for index in range(audit_select_page.script_select_display.count()):
            item = audit_select_page.script_select_display.item(index)
            item.setCheckState(QtCore.Qt.Unchecked)



def audit_select_page_add_new_script():
    file_path, _ = QFileDialog.getOpenFileName(None, "Select Script", "/home", "Bash Files (*.sh)")
    if file_path:
        script_name = os.path.basename(file_path)
        audit_select_page.script_select_display.addItem(script_name)

### CREATES THE DATABASE FOR AUDIT RESULTS ###

def create_tables():
    cursor = audit_select_page.database.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS audit_results (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            script_name TEXT,
            output TEXT,
            error TEXT,
            return_code INTEGER,
            execution_time TEXT,
            session_id INTEGER
        )
    ''')
    audit_select_page.database.commit()


###

def run_script(script_path):
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

def add_audit_result(result):
    cursor = audit_select_page.database.cursor()
    cursor.execute('''
        INSERT INTO audit_results (script_name, output, error, return_code, execution_time, session_id)
        VALUES (?, ?, ?, ?, datetime('now'), ?)
    ''', (result['script_name'], result['output'], result['error'], result['return_code'], result['session_id']))
    audit_select_page.database.commit()

###
import json

def filter_json_by_criteria(data, criteria):
    """
    Filters the input JSON data based on the criteria specified for SL1, SL2, L1, L2, and BL.

    Args:
        data (dict): The input JSON data.
        criteria (dict): A dictionary containing the desired values for SL1, SL2, L1, L2, and BL.
        Example: {"SL1": "TRUE", "L1": "TRUE"}

    Returns:
        list: A list of indices that match the criteria.
    """
    filtered_indices = []

    for key, value in data.items():
        match = all(value.get(crit_key, "") == crit_value for crit_key, crit_value in criteria.items())
        if match:
            filtered_indices.append(key)

    return filtered_indices

def load_json_from_file(filepath):
    """
    Loads JSON data from a file.

    Args:
        filepath (str): Path to the JSON file.

    Returns:
        dict: The loaded JSON data.
    """
    with open(filepath, 'r') as file:
        return json.load(file)

def serach_json_for_windows(criteria):
    jsondata=load_json_from_file('windowsDB.json')
    filtered = filter_json_by_criteria(jsondata, criteria)
    return filtered


def serach_json_for_redhat(criteria):
    jsondata=load_json_from_file('redhatDB.json')
    filtered = filter_json_by_criteria(jsondata, criteria)
    return filtered
    

def serach_json_for_ubuntu(criteria):
    jsondata=load_json_from_file('ubuntuDB.json')
    filtered = filter_json_by_criteria(jsondata, criteria)
    return filtered

def serach_all_json(OPS,criteria):
    if OPS=="Windows":
        return serach_json_for_windows(criteria)
    elif OPS=="Redhat":
        return serach_json_for_redhat(criteria)
    elif OPS=="Ubuntu":
        return serach_json_for_ubuntu(criteria)   

def audit_selected_scripts():

    global logfile_name

    os_name = check_os()
    if os_name == "Ubuntu":
        logfile_name = f'/tmp/audit_log_{datetime.datetime.now().strftime("%Y%m%d%H%M%S")}.txt'
    if os_name == "rhel_9":
        logfile_name = f'/tmp/audit_log_{datetime.datetime.now().strftime("%Y%m%d%H%M%S")}.txt'
    if os_name == "Windows":
            if os.path.exists('log'):
                pass
            else:
                os.makedirs('log')
            logfile_name = f'log/.audit_log_{datetime.datetime.now().strftime("%Y%m%d%H%M%S")}.txt'
    logfile = open(f'{logfile_name}', 'w')
    selected_items = [audit_select_page.script_select_display.item(i) for i in range(audit_select_page.script_select_display.count()) if audit_select_page.script_select_display.item(i).checkState() == QtCore.Qt.Checked]
    global session_id
    session_id += 1
    item_count = len(selected_items)

    main_window.setCurrentIndex(3)

    for idx, item in enumerate(selected_items, start=1):
        QCoreApplication.processEvents()
        script_name = item.data(QtCore.Qt.UserRole)
        audit_progress_page.current_script_lbl.setText(str(script_name))

        script_path = None
        os_name = check_os()
        if os_name == "Ubuntu":
            script_path = os.path.join('scripts/audits/ubuntu', script_name)
        if os_name == "rhel_9":
            script_path = os.path.join('scripts/audits/rhel_9', script_name)
        if os_name == "Windows":
            script_path = os.path.join('scripts/audits/windows', script_name)

        if not os.path.exists(script_path):
            print(f"Script not found: {script_path}")
            continue
        stdout, stderr, return_code = run_script(script_path)
        result = { 'script_name': script_name, 'output': stdout, 'error': stderr, 'return_code': return_code, 'session_id': session_id}
        add_audit_result(result)
        QCoreApplication.processEvents()
        progress = int(idx / item_count * 100)
        audit_progress_page.script_progess_bar.setValue(progress)
        script_name = script_name.replace('.audit', '')
        script_name = script_name.replace('.sh', '')
        script_name = script_name.replace('.ps1', '')
        module_name = audit_select_page.module_to_name.get(script_name, script_name)
        
        logfile.write(f"Script: {script_name} - {module_name}\n")
        logfile.write(f"Output:{stdout}\n")
        logfile.write(f"Error:{stderr}\n")
        logfile.write(f"Return Code: {return_code}\n\n")

    print("Audit completed")

    logfile.close()

    main_window.setCurrentIndex(4)
    audit_result_page_display_result()

###

def audit_result_page_display_result():
    newdatabase = sqlite3.connect("audit_results.db")
    cursor = newdatabase.cursor()
    cursor.execute("""
            SELECT script_name, return_code, output, error
            FROM audit_results
            WHERE session_id = ?
        """, (session_id,))

    rows = cursor.fetchall()
    audit_result_page.script_result_display.clear()  # Clear previous results
    module_to_name = load_module_to_name()
    for row_idx, (script_name, return_code, output, error) in enumerate(rows):
        temp = script_name.replace('.sh', '')
        temp = temp.replace('.ps1', '')
        temp = temp.replace('.audit', '')
        module_name = module_to_name.get(temp, temp)
#################################################################################################
        audit_result_page.script_result_display.setWordWrap(True)

        # Create parent item for the script
        parent_item = QtWidgets.QTreeWidgetItem(audit_result_page.script_result_display)
        if return_code == 0:  # Pass
            parent_item.setText(0, f"PASS: {module_name}")
        else:
            parent_item.setText(0, f"FAIL: {module_name}")

        # Add placeholder details as child items

        # Truncate if output is too long

        if output != "":
            child_output = QtWidgets.QTreeWidgetItem(parent_item)
            child_output.setText(0, f"{output}")
            # child_output.setwordWrap(True)
        # Truncate if error is too long

        if error != "" :
            child_error = QtWidgets.QTreeWidgetItem(parent_item)
            child_error.setText(0, f"{error}")
            # child_error.setwordWrap(True)
        # Truncate if error is too long

        # Expand all items by default (optional)
        parent_item.setExpanded(False)


def new_audit_filters():
    isworkstation = new_audit_page.workstation_btn.isChecked()
    isserver = new_audit_page.server_btn.isChecked()
    islevel1 = new_audit_page.level1_btn.isChecked()
    islevel2 = new_audit_page.level2_btn.isChecked()
    isbitlocker = new_audit_page.bitlocker_btn.isChecked()
    print(isworkstation, isserver, islevel1, islevel2, isbitlocker)
    main_window.setCurrentIndex(2)

if __name__ == "__main__":
    session_id = 0
    app = QApplication(sys.argv)
    main_window = QStackedWidget()

    # Load the start page UI file
    loader_start_page = QUiLoader()
    start_page = loader_start_page.load("start_page.ui", main_window)
    main_window.addWidget(start_page)

    # Get system information
    system_info = get_system_info()

    # Set label text for each system information entry
    start_page.hostname_lbl.setText(system_info["hostname"])
    start_page.os_name_lbl.setText(system_info["os_name"])
    start_page.os_version_lbl.setText(system_info["os_version"])
    start_page.kernel_lbl.setText(system_info["kernel_version"])
    start_page.mach_arch_lbl.setText(system_info["machine_arch"])
    start_page.processor_lbl.setText(system_info["processor"])

    # Connect buttons to methods
    loader_new_audit_page = QUiLoader()
    new_audit_page = loader_new_audit_page.load("new_audit_page.ui", main_window)
    main_window.addWidget(new_audit_page)
    start_page.new_audit_btn.clicked.connect(lambda: main_window.setCurrentIndex(1))

    loader_audit_select_page = QUiLoader()
    audit_select_page = loader_audit_select_page.load("audit_select_page.ui", main_window)
    main_window.addWidget(audit_select_page)

    audit_select_page.search_bar.returnPressed.connect(search_bar_filter_select_page)

    loader_audit_progess_page = QUiLoader()
    audit_progress_page = loader_audit_progess_page.load("audit_progress_page.ui", None)
    main_window.addWidget(audit_progress_page)

    isworkstation = None
    isserver = None
    islevel1 = None
    islevel2 = None
    isbitlocker = None

    new_audit_page.continue_btn.clicked.connect(new_audit_filters)

###########################################################################
    audit_select_page.module_to_name = load_module_to_name()
    audit_select_page.database = sqlite3.connect('audit_results.db')
    create_tables()
    audit_select_page_populate_script_list()
    audit_select_page.select_all_btn.clicked.connect(audit_select_page_select_all_scripts)
    if os.path.exists("audit_results.db"):
        cursor = audit_select_page.database.cursor()
        cursor.execute('''select max(session_id) from audit_results''')
        result = cursor.fetchone()
        cursor.close()
        session_id = result[0] if result[0] else 0
    audit_select_page.back_btn.clicked.connect(lambda: main_window.setCurrentIndex(0))
    # audit_select_page.add_script_btn.clicked.connect(audit_select_page_add_new_script)

    loader_audit_result_page = QUiLoader()
    audit_result_page = loader_audit_result_page.load("audit_result_page.ui", main_window)

    audit_result_page.search_bar.returnPressed.connect(search_bar_filter_result_page)
    
    main_window.addWidget(audit_result_page)

    audit_select_page.audit_btn.clicked.connect(audit_selected_scripts)
    audit_result_page.home_btn.clicked.connect(lambda: main_window.setCurrentIndex(0))

    start_page.cis_benchmark_btn.clicked.connect(open_cis_website)
    new_audit_page.cis_benchmark_btn.clicked.connect(open_cis_website)

    logfile_name = None

    def save_logs():
        log_data = open(f'{logfile_name}', 'r').read()
        pdf = FPDF() 
        pdf.add_page()
        pdf.set_font("Arial", size = 15)
        pdf.multi_cell(0, 5, txt = log_data)
        filename = QFileDialog.getSaveFileName(audit_result_page, "Save Log PDF", "", "PDF File (*.pdf)")
        if filename[0]:
            pdf.output(f"{filename[0]}.pdf")

    audit_result_page.export_btn.clicked.connect(save_logs)

    main_window.show()
    sys.exit(app.exec())
