from PySide6.QtWidgets import QWidget, QPushButton, QLabel
from PySide6.QtUiTools import QUiLoader
from PySide6.QtCore import QFile

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