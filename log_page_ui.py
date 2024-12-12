# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'log_page.ui'
##
## Created by: Qt User Interface Compiler version 6.8.1
##
## WARNING! All changes made in this file will be lost when recompiling UI file!
################################################################################

from PySide6.QtCore import (QCoreApplication, QDate, QDateTime, QLocale,
    QMetaObject, QObject, QPoint, QRect,
    QSize, QTime, QUrl, Qt)
from PySide6.QtGui import (QBrush, QColor, QConicalGradient, QCursor,
    QFont, QFontDatabase, QGradient, QIcon,
    QImage, QKeySequence, QLinearGradient, QPainter,
    QPalette, QPixmap, QRadialGradient, QTransform)
from PySide6.QtWidgets import (QApplication, QSizePolicy, QTextEdit, QVBoxLayout,
    QWidget)

class Ui_log_page(object):
    def setupUi(self, log_page):
        if not log_page.objectName():
            log_page.setObjectName(u"log_page")
        log_page.resize(675, 546)
        self.verticalLayout = QVBoxLayout(log_page)
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.textEdit = QTextEdit(log_page)
        self.textEdit.setObjectName(u"textEdit")

        self.verticalLayout.addWidget(self.textEdit)


        self.retranslateUi(log_page)

        QMetaObject.connectSlotsByName(log_page)
    # setupUi

    def retranslateUi(self, log_page):
        log_page.setWindowTitle(QCoreApplication.translate("log_page", u"Form", None))
    # retranslateUi

