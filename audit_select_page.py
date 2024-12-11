import sys
import os
import json
import subprocess
import sqlite3
from PySide6 import QtWidgets, QtCore, QtUiTools

class AuditSelectPage(QtWidgets.QWidget):
    def __init__(self, switch_to_previous_page):
        super().__init__()
        self.switch_to_previous_page = switch_to_previous_page
        self.module_to_name = self.load_module_to_name()
        self.conn = sqlite3.connect('audit_results.db')
        self.create_tables()
        self.init_ui()

    def init_ui(self):
        loader = QtUiTools.QUiLoader()
        ui_file = QtCore.QFile('audit_select_page.ui')  # Replace with the correct path to your .ui file
        if not ui_file.exists():
            print("UI file does not exist.")
            return
        ui_file.open(QtCore.QFile.ReadOnly)
        self.widget = loader.load(ui_file, self)
        ui_file.close()

        # Set up signals and slots
        self.search_bar = self.findChild(QtWidgets.QLineEdit, 'search_bar')
        self.filter_btn = self.findChild(QtWidgets.QPushButton, 'filter_btn')
        self.script_select_display = self.findChild(QtWidgets.QListWidget, 'script_select_display')
        self.select_all_btn = self.findChild(QtWidgets.QPushButton, 'select_all_btn')
        self.back_btn = self.findChild(QtWidgets.QPushButton, 'back_btn')
        self.add_script_btn = self.findChild(QtWidgets.QPushButton, 'add_script_btn')
        self.audit_btn = self.findChild(QtWidgets.QPushButton, 'audit_btn')

        self.filter_btn.clicked.connect(self.filter_scripts)
        self.select_all_btn.clicked.connect(self.select_all_scripts)
        self.back_btn.clicked.connect(self.switch_to_previous_page)
        self.add_script_btn.clicked.connect(self.add_script)
        self.audit_btn.clicked.connect(self.audit_selected_scripts)

        self.populate_script_list()

    def create_tables(self):
        cursor = self.conn.cursor()
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS audit_results (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                script_name TEXT,
                output TEXT,
                error TEXT,
                return_code INTEGER,
                execution_time TEXT
            )
        ''')
        self.conn.commit()

    def load_module_to_name(self):
        with open('ubuntu_moduleToName.json', 'r') as file:
            return json.load(file)

    def populate_script_list(self):
        self.script_select_display.clear()
        script_dir = 'tests/scripts/audits'
        if os.path.isdir(script_dir):
            for script in sorted(os.listdir(script_dir)):
                script_name = os.path.splitext(script)[0]
                module_name = self.module_to_name.get(script_name, script_name)
                list_item = QtWidgets.QListWidgetItem(module_name)
                list_item.setFlags(list_item.flags() | QtCore.Qt.ItemIsUserCheckable)
                list_item.setCheckState(QtCore.Qt.Unchecked)
                list_item.setData(QtCore.Qt.UserRole, script)
                self.script_select_display.addItem(list_item)

    def filter_scripts(self):
        search_text = self.search_bar.text().lower()
        for index in range(self.script_select_display.count()):
            item = self.script_select_display.item(index)
            item.setHidden(search_text not in item.text().lower())

    def select_all_scripts(self):
        for index in range(self.script_select_display.count()):
            item = self.script_select_display.item(index)
            item.setCheckState(QtCore.Qt.Checked)

    def add_script(self):
        print("Add script clicked")
        # Add functionality to add a new script

    def audit_selected_scripts(self):
        selected_items = [self.script_select_display.item(i) for i in range(self.script_select_display.count()) if self.script_select_display.item(i).checkState() == QtCore.Qt.Checked]
        for item in selected_items:
            script_name = item.data(QtCore.Qt.UserRole)
            script_path = os.path.join('tests/scripts/audits', script_name)
            if not os.path.exists(script_path):
                print(f"Script not found: {script_path}")
                continue
            stdout, stderr, return_code = self.run_script(script_path)
            result = { 'script_name': script_name, 'output': stdout, 'error': stderr, 'return_code': return_code }
            self.add_audit_result(result)
        print("Audit completed")

    def run_script(self, script_path):
        try:
            os.chmod(script_path, 0o755)
            result = subprocess.run(["bash", script_path], capture_output=True, text=True)
            return result.stdout, result.stderr, result.returncode
        except subprocess.CalledProcessError as e:
            return e.stdout, e.stderr, e.returncode

    def add_audit_result(self, result):
        cursor = self.conn.cursor()
        cursor.execute('''
            INSERT INTO audit_results (script_name, output, error, return_code, execution_time)
            VALUES (?, ?, ?, ?, datetime('now'))
        ''', (result['script_name'], result['output'], result['error'], result['return_code']))
        self.conn.commit()

if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    window = AuditSelectPage(lambda: print("Switch to previous page"))  # Pass a dummy function for testing
    window.show()
    sys.exit(app.exec())

