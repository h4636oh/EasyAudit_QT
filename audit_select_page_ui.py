# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'audit_select_page.ui'
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
from PySide6.QtWidgets import (QApplication, QHBoxLayout, QLineEdit, QListWidget,
    QListWidgetItem, QPushButton, QSizePolicy, QSpacerItem,
    QVBoxLayout, QWidget)

class Ui_audit_select_page(object):
    def setupUi(self, audit_select_page):
        if not audit_select_page.objectName():
            audit_select_page.setObjectName(u"audit_select_page")
        audit_select_page.resize(753, 663)
        sizePolicy = QSizePolicy(QSizePolicy.Policy.Fixed, QSizePolicy.Policy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(audit_select_page.sizePolicy().hasHeightForWidth())
        audit_select_page.setSizePolicy(sizePolicy)
        audit_select_page.setMinimumSize(QSize(753, 663))
        audit_select_page.setMaximumSize(QSize(753, 663))
        font = QFont()
        font.setFamilies([u"DM Mono"])
        audit_select_page.setFont(font)
        self.verticalLayout = QVBoxLayout(audit_select_page)
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.bar_top = QHBoxLayout()
        self.bar_top.setObjectName(u"bar_top")
        self.search_bar = QLineEdit(audit_select_page)
        self.search_bar.setObjectName(u"search_bar")
        self.search_bar.setFrame(True)

        self.bar_top.addWidget(self.search_bar)


        self.verticalLayout.addLayout(self.bar_top)

        self.script_select_display = QListWidget(audit_select_page)
        self.script_select_display.setObjectName(u"script_select_display")

        self.verticalLayout.addWidget(self.script_select_display)

        self.select_all_btn = QPushButton(audit_select_page)
        self.select_all_btn.setObjectName(u"select_all_btn")
        self.select_all_btn.setCheckable(True)

        self.verticalLayout.addWidget(self.select_all_btn)

        self.bar_bottom = QHBoxLayout()
        self.bar_bottom.setObjectName(u"bar_bottom")
        self.back_btn = QPushButton(audit_select_page)
        self.back_btn.setObjectName(u"back_btn")

        self.bar_bottom.addWidget(self.back_btn)

        self.horizontalSpacer_2 = QSpacerItem(40, 20, QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Minimum)

        self.bar_bottom.addItem(self.horizontalSpacer_2)

        self.audit_btn = QPushButton(audit_select_page)
        self.audit_btn.setObjectName(u"audit_btn")

        self.bar_bottom.addWidget(self.audit_btn)


        self.verticalLayout.addLayout(self.bar_bottom)


        self.retranslateUi(audit_select_page)

        QMetaObject.connectSlotsByName(audit_select_page)
    # setupUi

    def retranslateUi(self, audit_select_page):
        audit_select_page.setWindowTitle(QCoreApplication.translate("audit_select_page", u"Widget", None))
        self.search_bar.setInputMask("")
        self.search_bar.setText("")
        self.search_bar.setPlaceholderText(QCoreApplication.translate("audit_select_page", u"Type here to search audit scripts", None))
        self.select_all_btn.setText(QCoreApplication.translate("audit_select_page", u"SELECT ALL", None))
        self.back_btn.setText(QCoreApplication.translate("audit_select_page", u"BACK", None))
        self.audit_btn.setText(QCoreApplication.translate("audit_select_page", u"AUDIT", None))
    # retranslateUi

