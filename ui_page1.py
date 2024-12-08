# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'page1.ui'
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
from PySide6.QtWidgets import (QApplication, QGroupBox, QHBoxLayout, QLabel,
    QPushButton, QRadioButton, QSizePolicy, QSpacerItem,
    QVBoxLayout, QWidget)

class Ui_page1(object):
    def setupUi(self, page1):
        if not page1.objectName():
            page1.setObjectName(u"page1")
        page1.resize(811, 551)
        font = QFont()
        font.setFamilies([u"DM Mono"])
        page1.setFont(font)
        self.verticalLayout = QVBoxLayout(page1)
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.verticalSpacer_2 = QSpacerItem(20, 40, QSizePolicy.Policy.Minimum, QSizePolicy.Policy.Maximum)

        self.verticalLayout.addItem(self.verticalSpacer_2)

        self.instruction_label = QLabel(page1)
        self.instruction_label.setObjectName(u"instruction_label")
        self.instruction_label.setMaximumSize(QSize(16777215, 30))
        font1 = QFont()
        font1.setFamilies([u"DM Mono"])
        font1.setPointSize(14)
        self.instruction_label.setFont(font1)
        self.instruction_label.setAlignment(Qt.AlignmentFlag.AlignCenter)

        self.verticalLayout.addWidget(self.instruction_label)

        self.verticalSpacer = QSpacerItem(20, 40, QSizePolicy.Policy.Minimum, QSizePolicy.Policy.Maximum)

        self.verticalLayout.addItem(self.verticalSpacer)

        self.options_hlayout = QHBoxLayout()
        self.options_hlayout.setObjectName(u"options_hlayout")
        self.machine_type_box = QGroupBox(page1)
        self.machine_type_box.setObjectName(u"machine_type_box")
        self.machine_type_box.setFont(font1)
        self.widget = QWidget(self.machine_type_box)
        self.widget.setObjectName(u"widget")
        self.widget.setGeometry(QRect(10, 30, 133, 62))
        self.machine_type_vlayout = QVBoxLayout(self.widget)
        self.machine_type_vlayout.setObjectName(u"machine_type_vlayout")
        self.machine_type_vlayout.setContentsMargins(0, 0, 0, 0)
        self.workstation_btn = QRadioButton(self.widget)
        self.workstation_btn.setObjectName(u"workstation_btn")
        font2 = QFont()
        font2.setFamilies([u"DM Mono"])
        font2.setPointSize(12)
        self.workstation_btn.setFont(font2)

        self.machine_type_vlayout.addWidget(self.workstation_btn)

        self.server_btn = QRadioButton(self.widget)
        self.server_btn.setObjectName(u"server_btn")
        self.server_btn.setFont(font2)

        self.machine_type_vlayout.addWidget(self.server_btn)


        self.options_hlayout.addWidget(self.machine_type_box)

        self.benchmark_level_box = QGroupBox(page1)
        self.benchmark_level_box.setObjectName(u"benchmark_level_box")
        self.benchmark_level_box.setFont(font1)
        self.widget1 = QWidget(self.benchmark_level_box)
        self.widget1.setObjectName(u"widget1")
        self.widget1.setGeometry(QRect(20, 40, 95, 62))
        self.benchmark_level_vlayout = QVBoxLayout(self.widget1)
        self.benchmark_level_vlayout.setObjectName(u"benchmark_level_vlayout")
        self.benchmark_level_vlayout.setContentsMargins(0, 0, 0, 0)
        self.level1_btn = QRadioButton(self.widget1)
        self.level1_btn.setObjectName(u"level1_btn")
        self.level1_btn.setFont(font2)

        self.benchmark_level_vlayout.addWidget(self.level1_btn)

        self.level2_btn = QRadioButton(self.widget1)
        self.level2_btn.setObjectName(u"level2_btn")
        self.level2_btn.setFont(font2)

        self.benchmark_level_vlayout.addWidget(self.level2_btn)


        self.options_hlayout.addWidget(self.benchmark_level_box)


        self.verticalLayout.addLayout(self.options_hlayout)

        self.bottom_btns = QHBoxLayout()
        self.bottom_btns.setObjectName(u"bottom_btns")
        self.sysInfo_btn = QPushButton(page1)
        self.sysInfo_btn.setObjectName(u"sysInfo_btn")
        self.sysInfo_btn.setFont(font2)

        self.bottom_btns.addWidget(self.sysInfo_btn)

        self.continue_btn = QPushButton(page1)
        self.continue_btn.setObjectName(u"continue_btn")
        self.continue_btn.setFont(font2)

        self.bottom_btns.addWidget(self.continue_btn)


        self.verticalLayout.addLayout(self.bottom_btns)


        self.retranslateUi(page1)

        QMetaObject.connectSlotsByName(page1)
    # setupUi

    def retranslateUi(self, page1):
        page1.setWindowTitle(QCoreApplication.translate("page1", u"Widget", None))
        self.instruction_label.setText(QCoreApplication.translate("page1", u"CHOOSE TYPE OF CIS BENCHMARK YOU WANT TO RUN", None))
        self.machine_type_box.setTitle(QCoreApplication.translate("page1", u"MACHINE TYPE", None))
        self.workstation_btn.setText(QCoreApplication.translate("page1", u"WORKSTATION", None))
        self.server_btn.setText(QCoreApplication.translate("page1", u"SERVER", None))
        self.benchmark_level_box.setTitle(QCoreApplication.translate("page1", u"BENCHMARK LEVEL", None))
        self.level1_btn.setText(QCoreApplication.translate("page1", u"LEVEL 1", None))
        self.level2_btn.setText(QCoreApplication.translate("page1", u"LEVEL 2", None))
        self.sysInfo_btn.setText(QCoreApplication.translate("page1", u"SYSTEM INFORMATION", None))
        self.continue_btn.setText(QCoreApplication.translate("page1", u"CONTINUE", None))
    # retranslateUi

