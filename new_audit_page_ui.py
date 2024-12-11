# -*- coding: utf-8 -*-

################################################################################
## Form generated from reading UI file 'new_audit_page.ui'
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
from PySide6.QtWidgets import (QApplication, QCheckBox, QGroupBox, QHBoxLayout,
    QLabel, QLayout, QPushButton, QRadioButton,
    QSizePolicy, QSpacerItem, QVBoxLayout, QWidget)

class Ui_new_audit_page(object):
    def setupUi(self, new_audit_page):
        if not new_audit_page.objectName():
            new_audit_page.setObjectName(u"new_audit_page")
        new_audit_page.resize(753, 663)
        sizePolicy = QSizePolicy(QSizePolicy.Policy.Preferred, QSizePolicy.Policy.Preferred)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(new_audit_page.sizePolicy().hasHeightForWidth())
        new_audit_page.setSizePolicy(sizePolicy)
        new_audit_page.setMinimumSize(QSize(753, 663))
        new_audit_page.setMaximumSize(QSize(753, 663))
        font = QFont()
        font.setFamilies([u"DM Mono"])
        new_audit_page.setFont(font)
        self.verticalLayout = QVBoxLayout(new_audit_page)
        self.verticalLayout.setObjectName(u"verticalLayout")
        self.vspacer_2 = QSpacerItem(20, 40, QSizePolicy.Policy.Minimum, QSizePolicy.Policy.Expanding)

        self.verticalLayout.addItem(self.vspacer_2)

        self.instruction_label = QLabel(new_audit_page)
        self.instruction_label.setObjectName(u"instruction_label")
        sizePolicy1 = QSizePolicy(QSizePolicy.Policy.Fixed, QSizePolicy.Policy.Fixed)
        sizePolicy1.setHorizontalStretch(0)
        sizePolicy1.setVerticalStretch(0)
        sizePolicy1.setHeightForWidth(self.instruction_label.sizePolicy().hasHeightForWidth())
        self.instruction_label.setSizePolicy(sizePolicy1)
        self.instruction_label.setMinimumSize(QSize(0, 25))
        self.instruction_label.setMaximumSize(QSize(750, 25))
        font1 = QFont()
        font1.setFamilies([u"DM Mono"])
        font1.setPointSize(14)
        self.instruction_label.setFont(font1)
        self.instruction_label.setAutoFillBackground(False)
        self.instruction_label.setMidLineWidth(1)
        self.instruction_label.setTextFormat(Qt.TextFormat.AutoText)
        self.instruction_label.setScaledContents(False)
        self.instruction_label.setAlignment(Qt.AlignmentFlag.AlignCenter)
        self.instruction_label.setWordWrap(False)
        self.instruction_label.setTextInteractionFlags(Qt.TextInteractionFlag.NoTextInteraction)

        self.verticalLayout.addWidget(self.instruction_label)

        self.options_hlayout = QHBoxLayout()
        self.options_hlayout.setSpacing(0)
        self.options_hlayout.setObjectName(u"options_hlayout")
        self.options_hlayout.setContentsMargins(0, 20, 0, 0)
        self.hspacer_2 = QSpacerItem(40, 20, QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Minimum)

        self.options_hlayout.addItem(self.hspacer_2)

        self.machine_type_box = QGroupBox(new_audit_page)
        self.machine_type_box.setObjectName(u"machine_type_box")
        self.machine_type_box.setMinimumSize(QSize(178, 107))
        self.machine_type_box.setMaximumSize(QSize(178, 107))
        font2 = QFont()
        font2.setFamilies([u"DM Mono Medium"])
        self.machine_type_box.setFont(font2)
        self.verticalLayout_2 = QVBoxLayout(self.machine_type_box)
        self.verticalLayout_2.setObjectName(u"verticalLayout_2")
        self.machine_type_vlayout = QVBoxLayout()
        self.machine_type_vlayout.setObjectName(u"machine_type_vlayout")
        self.workstation_btn = QRadioButton(self.machine_type_box)
        self.workstation_btn.setObjectName(u"workstation_btn")
        font3 = QFont()
        font3.setFamilies([u"DM Mono"])
        font3.setPointSize(12)
        self.workstation_btn.setFont(font3)

        self.machine_type_vlayout.addWidget(self.workstation_btn)

        self.server_btn = QRadioButton(self.machine_type_box)
        self.server_btn.setObjectName(u"server_btn")
        self.server_btn.setFont(font3)

        self.machine_type_vlayout.addWidget(self.server_btn)


        self.verticalLayout_2.addLayout(self.machine_type_vlayout)


        self.options_hlayout.addWidget(self.machine_type_box)

        self.hspacer_3 = QSpacerItem(40, 20, QSizePolicy.Policy.MinimumExpanding, QSizePolicy.Policy.Minimum)

        self.options_hlayout.addItem(self.hspacer_3)

        self.benchmark_level_box = QGroupBox(new_audit_page)
        self.benchmark_level_box.setObjectName(u"benchmark_level_box")
        self.benchmark_level_box.setMinimumSize(QSize(178, 107))
        self.benchmark_level_box.setMaximumSize(QSize(178, 107))
        self.benchmark_level_box.setFont(font1)
        self.verticalLayout_3 = QVBoxLayout(self.benchmark_level_box)
        self.verticalLayout_3.setObjectName(u"verticalLayout_3")
        self.benchmark_level_vlayout = QVBoxLayout()
        self.benchmark_level_vlayout.setObjectName(u"benchmark_level_vlayout")
        self.level1_btn = QRadioButton(self.benchmark_level_box)
        self.level1_btn.setObjectName(u"level1_btn")
        self.level1_btn.setFont(font3)

        self.benchmark_level_vlayout.addWidget(self.level1_btn)

        self.level2_btn = QRadioButton(self.benchmark_level_box)
        self.level2_btn.setObjectName(u"level2_btn")
        self.level2_btn.setFont(font3)

        self.benchmark_level_vlayout.addWidget(self.level2_btn)


        self.verticalLayout_3.addLayout(self.benchmark_level_vlayout)


        self.options_hlayout.addWidget(self.benchmark_level_box)

        self.vspacer_3 = QSpacerItem(40, 20, QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Minimum)

        self.options_hlayout.addItem(self.vspacer_3)


        self.verticalLayout.addLayout(self.options_hlayout)

        self.verticalSpacer = QSpacerItem(20, 10, QSizePolicy.Policy.Minimum, QSizePolicy.Policy.Fixed)

        self.verticalLayout.addItem(self.verticalSpacer)

        self.horizontalLayout = QHBoxLayout()
        self.horizontalLayout.setObjectName(u"horizontalLayout")
        self.horizontalSpacer = QSpacerItem(40, 20, QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Minimum)

        self.horizontalLayout.addItem(self.horizontalSpacer)

        self.bitlocker_btn = QCheckBox(new_audit_page)
        self.bitlocker_btn.setObjectName(u"bitlocker_btn")
        self.bitlocker_btn.setEnabled(True)

        self.horizontalLayout.addWidget(self.bitlocker_btn)

        self.horizontalSpacer_2 = QSpacerItem(40, 20, QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Minimum)

        self.horizontalLayout.addItem(self.horizontalSpacer_2)


        self.verticalLayout.addLayout(self.horizontalLayout)

        self.vspacer_1 = QSpacerItem(20, 40, QSizePolicy.Policy.Minimum, QSizePolicy.Policy.Expanding)

        self.verticalLayout.addItem(self.vspacer_1)

        self.bar_bottom = QHBoxLayout()
        self.bar_bottom.setSpacing(6)
        self.bar_bottom.setObjectName(u"bar_bottom")
        self.bar_bottom.setSizeConstraint(QLayout.SizeConstraint.SetFixedSize)
        self.cis_benchmark_btn = QPushButton(new_audit_page)
        self.cis_benchmark_btn.setObjectName(u"cis_benchmark_btn")

        self.bar_bottom.addWidget(self.cis_benchmark_btn)

        self.hspacer_1 = QSpacerItem(40, 20, QSizePolicy.Policy.Expanding, QSizePolicy.Policy.Minimum)

        self.bar_bottom.addItem(self.hspacer_1)

        self.continue_btn = QPushButton(new_audit_page)
        self.continue_btn.setObjectName(u"continue_btn")
        self.continue_btn.setMaximumSize(QSize(16777215, 40))
        self.continue_btn.setFont(font3)

        self.bar_bottom.addWidget(self.continue_btn)


        self.verticalLayout.addLayout(self.bar_bottom)


        self.retranslateUi(new_audit_page)

        QMetaObject.connectSlotsByName(new_audit_page)
    # setupUi

    def retranslateUi(self, new_audit_page):
        new_audit_page.setWindowTitle(QCoreApplication.translate("new_audit_page", u"Widget", None))
        self.instruction_label.setText(QCoreApplication.translate("new_audit_page", u"CHOOSE TYPE OF CIS BENCHMARK YOU WANT TO RUN", None))
        self.machine_type_box.setTitle(QCoreApplication.translate("new_audit_page", u"MACHINE TYPE", None))
        self.workstation_btn.setText(QCoreApplication.translate("new_audit_page", u"WOR&KSTATION", None))
        self.server_btn.setText(QCoreApplication.translate("new_audit_page", u"SE&RVER", None))
        self.benchmark_level_box.setTitle(QCoreApplication.translate("new_audit_page", u"BENCHMARK LEVEL", None))
        self.level1_btn.setText(QCoreApplication.translate("new_audit_page", u"&LEVEL 1", None))
        self.level2_btn.setText(QCoreApplication.translate("new_audit_page", u"LEVEL &2", None))
        self.bitlocker_btn.setText(QCoreApplication.translate("new_audit_page", u"BITLOCKER(WINDOWS ONLY)", None))
#if QT_CONFIG(tooltip)
        self.cis_benchmark_btn.setToolTip(QCoreApplication.translate("new_audit_page", u"CIS benchmark pdf in browser", None))
#endif // QT_CONFIG(tooltip)
        self.cis_benchmark_btn.setText(QCoreApplication.translate("new_audit_page", u"CIS BENCHMARKS", None))
        self.continue_btn.setText(QCoreApplication.translate("new_audit_page", u"CONTINUE", None))
    # retranslateUi

