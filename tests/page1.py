import sys
import os
from PySide6 import QtWidgets, QtCore, QtUiTools

class Page1(QtWidgets.QWidget):
    def __init__(self, switch_to_page2):
        super().__init__()
        self.switch_to_page2 = switch_to_page2
        self.init_ui()

    def init_ui(self):
        # Load the UI from the .ui file
        loader = QtUiTools.QUiLoader()
        ui_file = QtCore.QFile('templates/page1.ui')
        if not ui_file.exists():
            print("UI file does not exist.")
            return
        ui_file.open(QtCore.QFile.ReadOnly)
        self.widget = loader.load(ui_file, self)
        ui_file.close()

        # Set up signals and slots
        self.workstation_btn = self.findChild(QtWidgets.QRadioButton, 'workstation_btn')
        self.server_btn = self.findChild(QtWidgets.QRadioButton, 'server_btn')
        self.level1_btn = self.findChild(QtWidgets.QRadioButton, 'level1_btn')
        self.level2_btn = self.findChild(QtWidgets.QRadioButton, 'level2_btn')
        self.sysInfo_btn = self.findChild(QtWidgets.QPushButton, 'sysInfo_btn')
        self.continue_btn = self.findChild(QtWidgets.QPushButton, 'continue_btn')

        if not all([self.workstation_btn, self.server_btn, self.level1_btn, self.level2_btn, self.sysInfo_btn, self.continue_btn]):
            raise RuntimeError("Failed to load widgets from the UI file.")

        self.sysInfo_btn.clicked.connect(self.show_sys_info)
        self.continue_btn.clicked.connect(self.continue_process)

    def show_sys_info(self):
        # Gather system information
        os_info = os.uname()
        info_message = (f"Operating System: {os_info.sysname}\n"
                        f"OS Version: {os_info.release}\n"
                        f"Kernel Version: {os_info.version}\n"
                        f"Hostname: {os_info.nodename}\n"
                        f"Machine Type: {os_info.machine}")

        QtWidgets.QMessageBox.information(self, "System Information", info_message)

    def continue_process(self):
        if not (self.workstation_btn.isChecked() or self.server_btn.isChecked()):
            QtWidgets.QMessageBox.warning(self, "Warning", "Please select a machine type.")
            return

        if not (self.level1_btn.isChecked() or self.level2_btn.isChecked()):
            QtWidgets.QMessageBox.warning(self, "Warning", "Please select a benchmark level.")
            return

        machine_type = "Workstation" if self.workstation_btn.isChecked() else "Server"
        benchmark_level = "Level 1" if self.level1_btn.isChecked() else "Level 2"
        QtWidgets.QMessageBox.information(self, "Selection", f"Machine Type: {machine_type}\nBenchmark Level: {benchmark_level}")

        self.switch_to_page2()

if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    window = Page1(lambda: print("Switch to page 2"))  # Pass a dummy function for testing
    window.show()
    sys.exit(app.exec())

