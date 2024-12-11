import sys
from PySide6.QtWidgets import QApplication, QStackedWidget
from start_page import MainMenu
from new_audit_page import NewAuditPage

class MainWindow(QStackedWidget):
    def __init__(self):
        super().__init__()

        # Initialize the main menu page
        self.start_page = MainMenu()
        self.addWidget(self.start_page.ui)  # Add start page to stack

        # Initialize the new audit page
        self.new_audit_page = NewAuditPage()
        self.addWidget(self.new_audit_page.ui)  # Add new audit page to stack

        # Set main menu as the first page
        self.setCurrentWidget(self.start_page.ui)

        # Connect the new audit button to switch to the new audit page
        self.start_page.new_audit_btn.clicked.connect(self.go_to_new_audit_page)

    def go_to_new_audit_page(self):
        """Switch to the New Audit page."""
        self.setCurrentWidget(self.new_audit_page.ui)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())