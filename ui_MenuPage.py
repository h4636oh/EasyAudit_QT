# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'MenuPage.ui'
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
from PySide6.QtWidgets import (QApplication, QLabel, QPushButton, QSizePolicy,
    QWidget)

class Ui_page1(object):
    def setupUi(self, page1):
        if not page1.objectName():
            page1.setObjectName(u"page1")
        page1.resize(811, 551)
        font = QFont()
        font.setFamilies([u"DM Mono"])
        page1.setFont(font)
        self.app_logo = QLabel(page1)
        self.app_logo.setObjectName(u"app_logo")
        self.app_logo.setGeometry(QRect(360, 90, 121, 51))
        sizePolicy = QSizePolicy(QSizePolicy.Policy.Fixed, QSizePolicy.Policy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.app_logo.sizePolicy().hasHeightForWidth())
        self.app_logo.setSizePolicy(sizePolicy)
        self.new_audit_btn = QPushButton(page1)
        self.new_audit_btn.setObjectName(u"new_audit_btn")
        self.new_audit_btn.setGeometry(QRect(530, 270, 98, 28))
        self.prev_audt_btn = QPushButton(page1)
        self.prev_audt_btn.setObjectName(u"prev_audt_btn")
        self.prev_audt_btn.setGeometry(QRect(350, 270, 111, 27))
        self.cis_benchmark_pdf_btn = QPushButton(page1)
        self.cis_benchmark_pdf_btn.setObjectName(u"cis_benchmark_pdf_btn")
        self.cis_benchmark_pdf_btn.setGeometry(QRect(190, 270, 101, 27))

        self.retranslateUi(page1)

        QMetaObject.connectSlotsByName(page1)
    # setupUi

    def retranslateUi(self, page1):
        page1.setWindowTitle(QCoreApplication.translate("page1", u"Widget", None))
        self.app_logo.setText(QCoreApplication.translate("page1", u"TextLabel", None))
        self.new_audit_btn.setText(QCoreApplication.translate("page1", u"PushButton", None))
        self.prev_audt_btn.setText(QCoreApplication.translate("page1", u"PushButton", None))
        self.cis_benchmark_pdf_btn.setText(QCoreApplication.translate("page1", u"PushButton", None))
    # retranslateUi

