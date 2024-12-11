import sys
import os
from PySide6 import QtWidgets, QtCore, QtUiTools

class Page2(QtWidgets.QWidget):
    def __init__(self):
        super().__init__()
        self.init_ui()

    def init_ui(self):
        # Load the UI from the .ui file
        loader = QtUiTools.QUiLoader()
        ui_file = QtCore.QFile('templates/page2.ui')  # Replace with the correct path to your .ui file
        if not ui_file.exists():
            print("UI file does not exist.")
            return
        ui_file.open(QtCore.QFile.ReadOnly)
        self.widget = loader.load(ui_file, self)
        ui_file.close()

        # Set up signals and slots
        self.new_audit_btn = self.findChild(QtWidgets.QPushButton, 'new_audit_btn')
        self.prev_audt_btn = self.findChild(QtWidgets.QPushButton, 'prev_audt_btn')
        self.cis_benchmark_pdf_btn = self.findChild(QtWidgets.QPushButton, 'cis_benchmark_pdf_btn')

        if not all([self.new_audit_btn, self.prev_audt_btn, self.cis_benchmark_pdf_btn]):
            raise RuntimeError("Failed to load widgets from the UI file.")

        self.new_audit_btn.clicked.connect(self.start_new_audit)
        self.prev_audt_btn.clicked.connect(self.show_previous_results)
        self.cis_benchmark_pdf_btn.clicked.connect(self.open_cis_benchmark_pdf)

    def start_new_audit(self):
        print("Starting new audit...")
        # Add functionality to start a new audit

    def show_previous_results(self):
        print("Showing previous results...")
        # Add functionality to show previous audit results

    def open_cis_benchmark_pdf(self):
        pdf_path = 'path_to_your_pdf_file.pdf'  # Replace with the correct path to your PDF file
        if os.path.exists(pdf_path):
            os.startfile(pdf_path)  # This will open the PDF with the default PDF viewer on Windows
        else:
            QtWidgets.QMessageBox.warning(self, "Warning", "PDF file not found.")

if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    window = Page2()
    window.show()
    sys.exit(app.exec())

