import sys
from PySide6.QtWidgets import QApplication, QStackedWidget
from start_page import MainMenu
# You can import other pages here if needed, for example:
# from cis_benchmark_page import CISBenchmarkPage
# from new_audit_page import NewAuditPage
# from audit_history_page import AuditHistoryPage

class MainWindow(QStackedWidget):
    def __init__(self):
        super().__init__()

        # Initialize main menu page
        self.start_page = MainMenu()
        self.addWidget(self.start_page.ui)

        # Set main menu as the first page
        self.setCurrentWidget(self.start_page.ui)

        # Connect buttons to actions
        # The actions are already handled in start_page.py

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())