import sys
from PySide6.QtWidgets import QApplication, QStackedWidget
from start_page import MainMenu

class MainWindow(QStackedWidget):
    def __init__(self):
        super().__init__()

        # Initialize the main menu page
        self.start_page = MainMenu()
        self.addWidget(self.start_page.ui)

        # Set main menu as the first page
        self.setCurrentWidget(self.start_page.ui)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())