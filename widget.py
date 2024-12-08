# This Python file uses the following encoding: utf-8
import sys

from PySide6.QtWidgets import QApplication, QWidget
from PySide6.QtUiTools import QUiLoader

if __name__ == "__main__":
    loader = QUiLoader()
    app = QApplication(sys.argv)
    window = loader.load("page1.ui", None)
    window.show()
    app.exec()
