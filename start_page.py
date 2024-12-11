from PySide6.QtWidgets import QWidget, QPushButton
from PySide6.QtUiTools import QUiLoader
from PySide6.QtCore import QFile

class MainMenu(QWidget):
    def __init__(self):
        super().__init__()

        # Load the UI file
        ui_file = QFile("start_page.ui")
        ui_file.open(QFile.ReadOnly)
        loader = QUiLoader()
        self.ui = loader.load(ui_file, self)

        ui_file.close()

        # Connect the buttons to methods
        self.cis_benchmark_btn = self.ui.findChild(QPushButton, "cis_benchmark_btn")
        self.new_audit_btn = self.ui.findChild(QPushButton, "new_audit_btn")
        self.audit_history_btn = self.ui.findChild(QPushButton, "audit_history_btn")

        # You can connect these buttons to appropriate slots
        self.cis_benchmark_btn.clicked.connect(self.on_cis_benchmark_click)
        self.new_audit_btn.clicked.connect(self.on_new_audit_click)
        self.audit_history_btn.clicked.connect(self.on_audit_history_click)

    def on_cis_benchmark_click(self):
        print("CIS Benchmark clicked")

    def on_new_audit_click(self):
        print("New Audit clicked")

    def on_audit_history_click(self):
        print("Audit History clicked")