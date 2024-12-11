import sys
from PySide6.QtWidgets import QApplication, QStackedWidget
from page1 import Page1
from page2 import Page2
from menuPage import MenuPage

class MainWindow(QStackedWidget):
    def __init__(self):
        super().__init__()
        self.menu_page = MenuPage()
        self.page1 = Page1()
        self.page2 = Page2()

        self.addWidget(self.menu_page)
        self.addWidget(self.page1)
        self.addWidget(self.page2)

        self.setCurrentWidget(self.menu_page)

    def switch_to_page1(self):
        self.setCurrentWidget(self.page1)

    def switch_to_page2(self):
        self.setCurrentWidget(self.page2)

    def switch_to_menu_page(self):
        self.setCurrentWidget(self.menu_page)

if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())

