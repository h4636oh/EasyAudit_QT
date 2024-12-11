from PySide6.QtWidgets import QWidget, QRadioButton, QCheckBox, QPushButton
from PySide6.QtUiTools import QUiLoader
from PySide6.QtCore import QFile

class NewAuditPage(QWidget):
    def __init__(self):
        super().__init__()
        ui_file = QFile("new_audit_page.ui")
        if ui_file.open(QFile.ReadOnly):
            loader = QUiLoader()
            self.ui = loader.load(ui_file, self)
            ui_file.close()

        self.workstation_btn = self.ui.findChild(QRadioButton, "workstation_btn")
        self.server_btn = self.ui.findChild(QRadioButton, "server_btn")
        self.level1_btn = self.ui.findChild(QRadioButton, "level1_btn")
        self.level2_btn = self.ui.findChild(QRadioButton, "level2_btn")
        self.bitlocker_btn = self.ui.findChild(QCheckBox, "bitlocker_btn")
        self.continue_btn = self.ui.findChild(QPushButton, "continue_btn")

        self.continue_btn.clicked.connect(self.store_selection)

    def store_selection(self):
        """Store the user's selections."""
        machine_type = "Workstation" if self.workstation_btn.isChecked() else "Server"
        benchmark_level = "Level 1" if self.level1_btn.isChecked() else "Level 2"
        bitlocker_enabled = self.bitlocker_btn.isChecked()

        # Store the data for the next page to use
        self.audit_data = {
            "machine_type": machine_type,
            "benchmark_level": benchmark_level,
            "bitlocker_enabled": bitlocker_enabled
        }

        print("Audit Data:", self.audit_data)