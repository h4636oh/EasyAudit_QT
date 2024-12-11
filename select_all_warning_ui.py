# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'select_all_warning.ui'
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
from PySide6.QtWidgets import (QAbstractButton, QApplication, QDialog, QDialogButtonBox,
    QLabel, QSizePolicy, QWidget)

class Ui_select_all_warning(object):
    def setupUi(self, select_all_warning):
        if not select_all_warning.objectName():
            select_all_warning.setObjectName(u"select_all_warning")
        select_all_warning.resize(400, 300)
        self.buttonBox = QDialogButtonBox(select_all_warning)
        self.buttonBox.setObjectName(u"buttonBox")
        self.buttonBox.setGeometry(QRect(40, 240, 341, 32))
        self.buttonBox.setOrientation(Qt.Orientation.Horizontal)
        self.buttonBox.setStandardButtons(QDialogButtonBox.StandardButton.Ok)
        self.buttonBox.setCenterButtons(True)
        self.label = QLabel(select_all_warning)
        self.label.setObjectName(u"label")
        self.label.setGeometry(QRect(60, 70, 291, 151))
        font = QFont()
        font.setFamilies([u"DM Mono"])
        font.setPointSize(16)
        self.label.setFont(font)
        self.label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.label.setWordWrap(True)
        self.label_2 = QLabel(select_all_warning)
        self.label_2.setObjectName(u"label_2")
        self.label_2.setGeometry(QRect(150, 10, 131, 61))
        font1 = QFont()
        font1.setFamilies([u"DM Mono"])
        font1.setPointSize(20)
        self.label_2.setFont(font1)
        self.label_2.setAlignment(Qt.AlignmentFlag.AlignCenter)

        self.retranslateUi(select_all_warning)
        self.buttonBox.accepted.connect(select_all_warning.accept)
        self.buttonBox.rejected.connect(select_all_warning.reject)

        QMetaObject.connectSlotsByName(select_all_warning)
    # setupUi

    def retranslateUi(self, select_all_warning):
        select_all_warning.setWindowTitle(QCoreApplication.translate("select_all_warning", u"Dialog", None))
        self.label.setText(QCoreApplication.translate("select_all_warning", u"Due to large number of scripts it may take a long time to run depending on hardware configuration", None))
        self.label_2.setText(QCoreApplication.translate("select_all_warning", u"WARNING", None))
    # retranslateUi

