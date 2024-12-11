import sys
import os
import subprocess
import sqlite3
from PySide6.QtWidgets import QApplication, QMainWindow, QListWidget, QPushButton, QStackedWidget, QLineEdit, QLabel, QCheckBox, QMessageBox, QListWidgetItem, QComboBox
from PySide6.QtUiTools import QUiLoader
from PySide6.QtCore import QFile, QIODevice, Qt

class MainWindow(QMainWindow):
    def __init__(self):
        super(MainWindow, self).__init__()
        loader = QUiLoader()
        self.failed_scripts = []

        self.stacked_widget = QStackedWidget()
        self.setCentralWidget(self.stacked_widget)

        self.load_ui(loader, 'main.ui')
        self.load_ui(loader, 'serverPage.ui')
        self.load_ui(loader, 'auditResultsPage.ui')
        self.load_ui(loader, 'edit_script.ui')
        self.load_ui(loader, 'remediationPage.ui')

        self.init_main_page()
        self.init_server_page()
        self.init_audit_results_page()
        self.init_edit_script_page()
        #self.init_remediation_page()

        # Initialize database connection
        self.conn = sqlite3.connect('audit_results.db')
        self.create_tables()

    def load_ui(self, loader, ui_file):
        file = QFile(f"templates3/{ui_file}")
        file.open(QIODevice.ReadOnly)
        widget = loader.load(file, self)
        self.stacked_widget.addWidget(widget)
        file.close()

    def create_tables(self):
        cursor = self.conn.cursor()
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS results (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                script_name TEXT,
                output TEXT,
                error TEXT,
                return_code INTEGER,
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP
            )
        ''')
        self.conn.commit()

    def init_main_page(self):
        main_page = self.stacked_widget.widget(0)
        server_button = main_page.findChild(QPushButton, 'Server')
        workstation_button = main_page.findChild(QPushButton, 'Workstation')
        cis_benchmark_button = main_page.findChild(QPushButton, 'Benchmark')

        server_button.clicked.connect(lambda: self.stacked_widget.setCurrentIndex(1))
        workstation_button.clicked.connect(lambda: self.stacked_widget.setCurrentIndex(1))  # Assuming same page for now
        cis_benchmark_button.clicked.connect(lambda: self.stacked_widget.setCurrentIndex(1))  # Assuming same page for now

        # Display system information
        os_label = main_page.findChild(QLabel, 'OS')
        os_version_label = main_page.findChild(QLabel, 'OSVersion')
        hostname_label = main_page.findChild(QLabel, 'Hostname')
        kernel_version_label = main_page.findChild(QLabel, 'KernalVersion')
        machine_type_label = main_page.findChild(QLabel, 'MachineType')
        processor_label = main_page.findChild(QLabel, 'Processor')

        os_info = self.get_os_info()
        os_label.setText(f"Operating System: {os_info['os']}")
        os_version_label.setText(f"OS Version: {os_info['version']}")
        hostname_label.setText(f"Hostname: {os_info['hostname']}")
        kernel_version_label.setText(f"Kernel Version: {os_info['kernel']}")
        machine_type_label.setText(f"Machine Type: {os_info['machine']}")
        processor_label.setText(f"Processor: {os_info['processor']}")

    def get_os_info(self):
        return {
            "os": os.uname().sysname,
            "version": os.uname().release,
            "hostname": os.uname().nodename,
            "kernel": os.uname().version,
            "machine": os.uname().machine,
            "processor": os.uname().machine
        }


########
    def init_server_page(self):
        server_page = self.stacked_widget.widget(1)
        self.script_list_widget = server_page.findChild(QListWidget, 'scriptListWidget')
        run_button = server_page.findChild(QPushButton, 'runScripts')
        edit_button = server_page.findChild(QPushButton, 'editScripts')
        select_all_checkbox = server_page.findChild(QCheckBox, 'checkBox')
        clear_all_checkbox = server_page.findChild(QCheckBox, 'clearAll')
        go_back_button = server_page.findChild(QPushButton, 'pushButton')
        filter_line_edit = server_page.findChild(QLineEdit, 'filter')
        search_line_edit = server_page.findChild(QLineEdit, 'search')

        run_button.clicked.connect(self.run_selected_scripts)
        edit_button.clicked.connect(lambda: self.stacked_widget.setCurrentIndex(3))  # Go to edit script page
        select_all_checkbox.stateChanged.connect(self.select_all_scripts)
        clear_all_checkbox.stateChanged.connect(self.clear_all_scripts)
        go_back_button.clicked.connect(lambda: self.stacked_widget.setCurrentIndex(0))
        filter_line_edit.textChanged.connect(self.filter_scripts)
        search_line_edit.textChanged.connect(self.search_scripts)

        self.populate_script_list_with_checkboxes()

    def populate_script_list_with_checkboxes(self):
        self.script_list_widget.clear()
        script_dir = 'scripts'
        module_path = os.path.join(script_dir, "audits")
        for script in sorted(os.listdir(module_path)):
            script_path = os.path.join(module_path, script)
            list_item = QListWidgetItem(script_path)
            list_item.setFlags(list_item.flags() | Qt.ItemIsUserCheckable)
            list_item.setCheckState(Qt.Unchecked)
            self.script_list_widget.addItem(list_item)

    def run_selected_scripts(self):
        selected_items = [self.script_list_widget.item(i) for i in range(self.script_list_widget.count()) if self.script_list_widget.item(i).checkState() == Qt.Checked]
        for item in selected_items:
            script_path = item.text()
            stdout, stderr, return_code = self.run_script(script_path)
            result = { 'script_name': script_path, 'output': stdout, 'error': stderr, 'return_code': return_code }
            if return_code != 0:
                self.failed_scripts.append(script_path)
            self.add_audit_result(result)
        self.stacked_widget.setCurrentIndex(2)
        self.init_remediation_page()



##########

    def init_audit_results_page(self):
        audit_results_page = self.stacked_widget.widget(2)
        self.audit_results_list_widget = audit_results_page.findChild(QListWidget, 'auditResultsListWidget')
        self.save_audit_results_button = audit_results_page.findChild(QPushButton, 'saveAuditResults')
        self.remediate_button = audit_results_page.findChild(QPushButton, 'remediate')
        self.search_line_edit = audit_results_page.findChild(QLineEdit, 'searchBar')
        go_to_home_button = audit_results_page.findChild(QPushButton, 'goToHome')

        self.save_audit_results_button.clicked.connect(self.save_audit_results)
        self.init_remediation_page()
        self.remediate_button.clicked.connect(lambda: self.stacked_widget.setCurrentIndex(4))  # Go to remediation page
        self.search_line_edit.textChanged.connect(self.filter_audit_results)
        go_to_home_button.clicked.connect(lambda: self.stacked_widget.setCurrentIndex(0))

    def init_edit_script_page(self):
        edit_script_page = self.stacked_widget.widget(3)
        # Initialize widgets and add functionality for the edit script page


    def run_script(self, script_path):
        try:
            # Give execution permission to the script
            os.chmod(script_path, 0o755)
            result = subprocess.run(script_path, shell=True, check=True, capture_output=True, text=True)
            return result.stdout, result.stderr, result.returncode
        except subprocess.CalledProcessError as e:
            return e.stdout, e.stderr, e.returncode

    def add_audit_result(self, result):
        result_status = "Pass" if result['return_code'] == 0 else "Fail"
        result_text = f"{os.path.basename(result['script_name'])}: {result_status}"
        combo_box = QComboBox()
        combo_box.addItem(result_text)
        combo_box.addItem(f"Output: {result['output']}")
        if result['error']:
            combo_box.addItem(f"Error: {result['error']}")
        list_item = QListWidgetItem()
        self.audit_results_list_widget.addItem(list_item)
        self.audit_results_list_widget.setItemWidget(list_item, combo_box)




    def save_audit_results(self):
        cursor = self.conn.cursor()
        for index in range(self.audit_results_list_widget.count()):
            item_text = self.audit_results_list_widget.item(index).text()
            script_name, result = item_text.split(": ", 1)
            output, return_code = result.split(" - ", 1)
            cursor.execute('''
                INSERT INTO results (script_name, output, error, return_code)
                VALUES (?, ?, ?, ?)
            ''', (script_name, output, "", int(return_code)))
        self.conn.commit()
        QMessageBox.information(self, "Success", "Audit results saved successfully!")

    def filter_audit_results(self):
        search_text = self.search_line_edit.text().lower()
        for index in range(self.audit_results_list_widget.count()):
            item = self.audit_results_list_widget.item(index)
            item.setHidden(search_text not in item.text().lower())

    def filter_scripts(self):
        filter_text = self.filter_line_edit.text().lower()
        for index in range(self.script_list_widget.count()):
            item = self.script_list_widget.item(index)
            item.setHidden(filter_text not in item.text().lower())

    def search_scripts(self):
        search_text = self.search_line_edit.text().lower()
        for index in range(self.script_list_widget.count()):
            item = self.script_list_widget.item(index)
            item.setHidden(search_text not in item.text().lower())

    def init_remediation_page(self):
        remediation_page = self.stacked_widget.widget(4)
        self.remediation_list_widget = remediation_page.findChild(QListWidget, 'remediationlistWidget')
        run_remediation_button = remediation_page.findChild(QPushButton, 'runRemediation')
        skip_remediation_button = remediation_page.findChild(QPushButton, 'skipRemediation')

        run_remediation_button.clicked.connect(self.run_remediation_scripts)
        skip_remediation_button.clicked.connect(lambda: self.stacked_widget.setCurrentIndex(0))

        self.populate_remediation_list()
    '''
    def populate_remediation_list(self):
        remediation_dir = 'scripts/remediation'
        self.remediation_scripts = []
        if os.path.isdir(remediation_dir):
            for script in os.listdir(remediation_dir):
                script_path = os.path.join(remediation_dir, script)
                self.remediation_scripts.append(script_path)
                self.remediation_list_widget.addItem(script_path)
    '''
    def populate_remediation_list(self):
        remediation_dir = 'scripts/remediation'
        self.remediation_scripts = []
        if os.path.isdir(remediation_dir):
            for script in os.listdir(remediation_dir):
                script_path = os.path.join(remediation_dir, script)
                script_name = script.replace('_remed.sh', '.sh')
                print(script_name, self.failed_scripts)
                if any(script_name in failed_script for failed_script in self.failed_scripts):
                    self.remediation_scripts.append(script_path)
                    self.remediation_list_widget.addItem(script_path)

    def run_remediation_scripts(self):
        selected_items = [self.remediation_list_widget.item(i) for i in range(self.remediation_list_widget.count()) if self.remediation_list_widget.item(i).checkState() == Qt.Checked]
        for item in selected_items:
            script_path = item.text()
            stdout, stderr, return_code = self.run_script(script_path)
            result = {
                'script_name': script_path,
                'output': stdout,
                'error': stderr,
                'return_code': return_code
            }
            self.add_audit_result(result)
        self.stacked_widget.setCurrentIndex(2)

    def select_all_scripts(self):
        for index in range(self.script_list_widget.count()):
            item = self.script_list_widget.item(index)
            item.setSelected(True)
            item.setCheckState(Qt.Checked)

    def clear_all_scripts(self):
        for index in range(self.script_list_widget.count()):
            item = self.script_list_widget.item(index)
            item.setSelected(False)
            item.setCheckState(Qt.Unchecked)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())

