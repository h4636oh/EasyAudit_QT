# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'audit_progress_page.ui'
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
from PySide6.QtWidgets import (QApplication, QHBoxLayout, QLabel, QProgressBar,
    QSizePolicy, QSpacerItem, QVBoxLayout, QWidget)

class Ui_audit_progress_page(object):
    def setupUi(self, audit_progress_page):
        if not audit_progress_page.objectName():
            audit_progress_page.setObjectName(u"audit_progress_page")
        audit_progress_page.resize(753, 690)
        sizePolicy = QSizePolicy(QSizePolicy.Policy.Fixed, QSizePolicy.Policy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(audit_progress_page.sizePolicy().hasHeightForWidth())
        audit_progress_page.setSizePolicy(sizePolicy)
        self.verticalLayout = QVBoxLayout(audit_progress_page)
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.verticalSpacer = QSpacerItem(20, 283, QSizePolicy.Policy.Minimum, QSizePolicy.Policy.Expanding)

        self.verticalLayout.addItem(self.verticalSpacer)

        self.horizontalLayout = QHBoxLayout()
        self.horizontalLayout.setObjectName(u"horizontalLayout")
        self.horizontalSpacer = QSpacerItem(40, 20, QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Minimum)

        self.horizontalLayout.addItem(self.horizontalSpacer)

        self.info_lbl = QLabel(audit_progress_page)
        self.info_lbl.setObjectName(u"info_lbl")
        self.info_lbl.setMinimumSize(QSize(400, 0))
        font = QFont()
        font.setFamilies([u"DM Mono Medium"])
        font.setPointSize(14)
        self.info_lbl.setFont(font)
        self.info_lbl.setAlignment(Qt.AlignmentFlag.AlignCenter)

        self.horizontalLayout.addWidget(self.info_lbl)

        self.horizontalSpacer_2 = QSpacerItem(40, 20, QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Minimum)

        self.horizontalLayout.addItem(self.horizontalSpacer_2)


        self.verticalLayout.addLayout(self.horizontalLayout)

        self.horizontalLayout_2 = QHBoxLayout()
        self.horizontalLayout_2.setObjectName(u"horizontalLayout_2")
        self.horizontalSpacer_3 = QSpacerItem(40, 20, QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Minimum)

        self.horizontalLayout_2.addItem(self.horizontalSpacer_3)

        self.script_progess_bar = QProgressBar(audit_progress_page)
        self.script_progess_bar.setObjectName(u"script_progess_bar")
        self.script_progess_bar.setMinimumSize(QSize(550, 0))
        self.script_progess_bar.setFont(font)
        self.script_progess_bar.setValue(0)
        self.script_progess_bar.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.script_progess_bar.setTextVisible(True)
        self.script_progess_bar.setOrientation(Qt.Orientation.Horizontal)
        self.script_progess_bar.setInvertedAppearance(False)

        self.horizontalLayout_2.addWidget(self.script_progess_bar)

        self.horizontalSpacer_4 = QSpacerItem(40, 20, QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Minimum)

        self.horizontalLayout_2.addItem(self.horizontalSpacer_4)


        self.verticalLayout.addLayout(self.horizontalLayout_2)

        self.horizontalLayout_3 = QHBoxLayout()
        self.horizontalLayout_3.setObjectName(u"horizontalLayout_3")
        self.horizontalSpacer_5 = QSpacerItem(40, 20, QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Minimum)

        self.horizontalLayout_3.addItem(self.horizontalSpacer_5)

        self.current_script_lbl = QLabel(audit_progress_page)
        self.current_script_lbl.setObjectName(u"current_script_lbl")
        self.current_script_lbl.setMinimumSize(QSize(400, 0))
        self.current_script_lbl.setFont(font)
        self.current_script_lbl.setAlignment(Qt.AlignmentFlag.AlignCenter)

        self.horizontalLayout_3.addWidget(self.current_script_lbl)

        self.horizontalSpacer_6 = QSpacerItem(40, 20, QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Minimum)

        self.horizontalLayout_3.addItem(self.horizontalSpacer_6)


        self.verticalLayout.addLayout(self.horizontalLayout_3)

        self.verticalSpacer_3 = QSpacerItem(20, 282, QSizePolicy.Policy.Minimum, QSizePolicy.Policy.Expanding)

        self.verticalLayout.addItem(self.verticalSpacer_3)


        self.retranslateUi(audit_progress_page)

        QMetaObject.connectSlotsByName(audit_progress_page)
    # setupUi

    def retranslateUi(self, audit_progress_page):
        audit_progress_page.setWindowTitle(QCoreApplication.translate("audit_progress_page", u"Form", None))
        self.info_lbl.setText(QCoreApplication.translate("audit_progress_page", u"Selected audit scripts are running have patience", None))
        self.current_script_lbl.setText(QCoreApplication.translate("audit_progress_page", u"current running script", None))
    # retranslateUi

