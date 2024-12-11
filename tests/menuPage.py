import sys
import os
import subprocess
import sqlite3
import getpass
import json
from datetime import datetime
from uuid import uuid4
from PySide6 import QtWidgets, QtCore, QtUiTools

class MenuPage(QtWidgets.QWidget):
    def __init__(self):
        super().__init__()
        self.module_to_name = self.load_module_to_name()
        self.conn = sqlite3.connect('audit_results.db') 
        self.create_tables()
        self.session_id = str(uuid4())  # Generate a unique session ID
        self.init_ui()

    def init_ui(self):
        loader = QtUiTools.QUiLoader()
        ui_file = QtCore.QFile('templates/MenuPage.ui')
        if not ui_file.exists():
            print("UI file does not exist.")
            return
        ui_file.open(QtCore.QFile.ReadOnly)
        self.widget = loader.load(ui_file, self)
        ui_file.close()

        # Set up signals and slots
        self.search_button = self.findChild(QtWidgets.QPushButton, 'pushButton')
        self.line_edit = self.findChild(QtWidgets.QLineEdit, 'lineEdit')
        self.list_widget = self.findChild(QtWidgets.QListWidget, 'listWidget')
        self.add_button = self.findChild(QtWidgets.QPushButton, 'pushButton_2')
        self.audit_button = self.findChild(QtWidgets.QPushButton, 'pushButton_3')

        self.search_button.clicked.connect(self.search_scripts)
        self.add_button.clicked.connect(self.add_script)
        self.audit_button.clicked.connect(self.audit_scripts)

        # Populate the script list
        self.populate_script_list_with_checkboxes()

    def create_tables(self):
        cursor = self.conn.cursor()
        cursor.execute('''
            CREATE TABLE IF NOT EXISTS audit_results (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                script_name TEXT,
                output TEXT,
                error TEXT,
                return_code INTEGER,
                execution_time TEXT,
                session_id TEXT
            )
        ''')
        self.conn.commit()

    def load_module_to_name(self):
        with open('ubuntu_moduleToName.json', 'r') as file:
            return json.load(file)

    def populate_script_list_with_checkboxes(self):
        self.list_widget.clear()
        script_dir = 'scripts/audits'
        if os.path.isdir(script_dir):
            for script in sorted(os.listdir(script_dir)):
                module_key = script.replace(".sh", "")
                if module_key not in self.module_to_name:
                    print(module_key, script)
                module_name = self.module_to_name.get(module_key, script)
                list_item = QtWidgets.QListWidgetItem(module_name)
                list_item.setFlags(list_item.flags() | QtCore.Qt.ItemIsUserCheckable)
                list_item.setCheckState(QtCore.Qt.Unchecked)
                list_item.setData(QtCore.Qt.UserRole, script)  # Store the original script path
                self.list_widget.addItem(list_item)

    def search_scripts(self):
        search_text = self.line_edit.text().lower()
        for index in range(self.list_widget.count()):
            item = self.list_widget.item(index)
            item.setHidden(search_text not in item.text().lower())

    def add_script(self):
        # Implement the functionality to add a new script
        print("Add script clicked")

    def audit_scripts(self):
        # TEMPORARY : To be linked
        sudo_password = getpass.getpass("Enter sudo password: ")
        selected_items = [self.list_widget.item(i) for i in range(self.list_widget.count()) if self.list_widget.item(i).checkState() == QtCore.Qt.Checked]
        for item in selected_items:
            script_path = os.path.join('scripts/audits', item.data(QtCore.Qt.UserRole))
            stdout, stderr, return_code = self.run_script(script_path, sudo_password)
            execution_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            result = {
                'script_name': script_path,
                'output': stdout,
                'error': stderr,
                'return_code': return_code,
                'execution_time': execution_time,
                'session_id': self.session_id
            }
            self.save_audit_result(result)
        #self.print_database_contents()

    def run_script(self, script_path, sudo_password):
        try:
            # Give execution permission to the script
            os.chmod(script_path, 0o755)
            command = f"echo {sudo_password} | sudo -S {script_path}"
            result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
            return result.stdout, result.stderr, result.returncode
        except subprocess.CalledProcessError as e:
            return e.stdout, e.stderr, e.returncode

    def save_audit_result(self, result):
        cursor = self.conn.cursor()
        cursor.execute('''
            INSERT INTO audit_results (script_name, output, error, return_code, execution_time, session_id)
            VALUES (?, ?, ?, ?, ?, ?)
        ''', (result['script_name'], result['output'], result['error'], result['return_code'], result['execution_time'], result['session_id']))
        self.conn.commit()

if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    window = MenuPage()
    window.show()
    sys.exit(app.exec())

