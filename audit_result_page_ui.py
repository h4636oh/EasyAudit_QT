# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'audit_result_page.ui'
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
from PySide6.QtWidgets import (QApplication, QHBoxLayout, QHeaderView, QLayout,
    QLineEdit, QPushButton, QSizePolicy, QSpacerItem,
    QTreeWidget, QTreeWidgetItem, QVBoxLayout, QWidget)

class Ui_audit_result_page(object):
    def setupUi(self, audit_result_page):
        if not audit_result_page.objectName():
            audit_result_page.setObjectName(u"audit_result_page")
        audit_result_page.resize(753, 663)
        sizePolicy = QSizePolicy(QSizePolicy.Policy.Fixed, QSizePolicy.Policy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(audit_result_page.sizePolicy().hasHeightForWidth())
        audit_result_page.setSizePolicy(sizePolicy)
        audit_result_page.setMinimumSize(QSize(753, 663))
        audit_result_page.setMaximumSize(QSize(753, 663))
        self.verticalLayout = QVBoxLayout(audit_result_page)
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.bar_top = QHBoxLayout()
        self.bar_top.setObjectName(u"bar_top")
        self.bar_top.setSizeConstraint(QLayout.SizeConstraint.SetDefaultConstraint)
        self.search_bar = QLineEdit(audit_result_page)
        self.search_bar.setObjectName(u"search_bar")
        self.search_bar.setFrame(True)

        self.bar_top.addWidget(self.search_bar)


        self.verticalLayout.addLayout(self.bar_top)

        self.script_result_display = QTreeWidget(audit_result_page)
        __qtreewidgetitem = QTreeWidgetItem()
        __qtreewidgetitem.setText(0, u"1");
        self.script_result_display.setHeaderItem(__qtreewidgetitem)
        self.script_result_display.setObjectName(u"script_result_display")
        self.script_result_display.setHeaderHidden(True)
        self.script_result_display.header().setHighlightSections(False)

        self.verticalLayout.addWidget(self.script_result_display)

        self.bar_bottom = QHBoxLayout()
        self.bar_bottom.setObjectName(u"bar_bottom")
        self.home_btn = QPushButton(audit_result_page)
        self.home_btn.setObjectName(u"home_btn")

        self.bar_bottom.addWidget(self.home_btn)

        self.horizontalSpacer = QSpacerItem(40, 20, QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Minimum)

        self.bar_bottom.addItem(self.horizontalSpacer)

        self.export_btn = QPushButton(audit_result_page)
        self.export_btn.setObjectName(u"export_btn")

        self.bar_bottom.addWidget(self.export_btn)


        self.verticalLayout.addLayout(self.bar_bottom)


        self.retranslateUi(audit_result_page)

        QMetaObject.connectSlotsByName(audit_result_page)
    # setupUi

    def retranslateUi(self, audit_result_page):
        audit_result_page.setWindowTitle(QCoreApplication.translate("audit_result_page", u"Form", None))
        self.search_bar.setInputMask("")
        self.search_bar.setText("")
        self.search_bar.setPlaceholderText(QCoreApplication.translate("audit_result_page", u"Type here to search audit's result", None))
        self.home_btn.setText(QCoreApplication.translate("audit_result_page", u"HOME", None))
        self.export_btn.setText(QCoreApplication.translate("audit_result_page", u"EXPORT RESULT", None))
    # retranslateUi

