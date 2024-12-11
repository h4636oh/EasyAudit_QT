import sqlite3
import os
from PySide6.QtWidgets import QApplication, QWidget, QDialog, QPlainTextEdit, QPushButton
from PySide6.QtCore import Qt
from PySide6.QtGui import QColor
from PySide6.QtUiTools import QUiLoader
from PySide6.QtCore import QFile
from PySide6.QtWidgets import QApplication, QWidget, QDialog, QPlainTextEdit, QPushButton, QListWidgetItem


class OutputDialog(QDialog):
    """
    A dialog to display large output text.
    """
    def __init__(self, title, content):
        super().__init__()
        self.setWindowTitle(title)

        # Text display
        text_edit = QPlainTextEdit(content)
        text_edit.setReadOnly(True)

        # Close button
        close_button = QPushButton("Close")
        close_button.clicked.connect(self.close)

        # Layout
        layout = QVBoxLayout()
        layout.addWidget(text_edit)
        layout.addWidget(close_button)
        self.setLayout(layout)


class AuditResultsPage(QWidget):
    def __init__(self, db_path):
        super().__init__()
        # Load the UI
        ui_file = QFile("audit_result_page.ui")
        ui_file.open(QFile.ReadOnly)
        loader = QUiLoader()
        self.ui = loader.load(ui_file, self)
        ui_file.close()

        # Access UI elements
        self.search_bar = self.ui.findChild(QWidget, "search_bar")
        self.filter_btn = self.ui.findChild(QPushButton, "filter_btn")
        self.script_result_display = self.ui.findChild(QWidget, "script_result_diplay")
        self.view_logs_btn = self.ui.findChild(QPushButton, "view_logs_btn")
        self.remediate_btn = self.ui.findChild(QPushButton, "remediate_btn")

        self.populate_table(db_path)

    def populate_table(self, db_path):
        # Connect to the SQLite database
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()

        # Query the latest script and its sessionID
        cursor.execute("""
            SELECT "sessionID"
            FROM results
            ORDER BY timestamp DESC
            LIMIT 1;
        """)
        latest_session = cursor.fetchone()

        if latest_session is None:
            print("No data found in the database.")
            return

        session_id = latest_session[0]

        # Fetch all rows with the same sessionID
        cursor.execute("""
            SELECT script_name, output, error, return_code, timestamp
            FROM results
            WHERE "sessionID" = ?;
        """, (session_id,))
        rows = cursor.fetchall()

        self.script_result_display.clear()

        # Populate the list with results
        for row_idx, (script_name, output, error, return_code, timestamp) in enumerate(rows):
            item_text = f"{script_name} | {output[:50]}... | Return Code: {return_code} | {timestamp}"
            item = QListWidgetItem(item_text)
            if return_code == 0:  # Pass
                item.setBackground(QColor("#1c6000"))
            elif return_code == 1:  # Fail
                item.setBackground(QColor("red"))
            else:  # Error
                item.setBackground(QColor("blue"))

            self.script_result_display.addItem(item)

        conn.close()


def create_sample_database(db_path):
    """
    Creates a sample SQLite database with test data.
    """
    if os.path.exists(db_path):
        os.remove(db_path)  # Remove existing database for a fresh start

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    # Create the table
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS results (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            script_name TEXT,
            output TEXT,
            error TEXT,
            return_code INTEGER,
            timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
            "sessionID" INTEGER
        );
    """)

    # Insert sample data
    sample_data = [
        ("Audit Script 1", "Short output", "", 0, 1),
        ("Audit Script 2", "A" * 300, "Some error occurred", 1, 1),  # Large output
        ("Audit Script 3", "Output 3", "", 0, 1),
        ("Audit Script 4", "Output 4", "Unexpected behavior", 2, 1),
        ("Audit Script 5", "Output 5", "", 0, 2),
        ("Audit Script 6", "Output 6", "Critical failure", 1, 2),
        ("Audit Script 7", "Output 7", "", 0, 2),
         ("Audit Script 1", "Short output", "", 0, 1),
        ("Audit Script 2", "A" * 300, "Some error occurred", 1, 1),  # Large output
        ("Audit Script 3", "Output 3", "", 0, 1),
         ("Audit Script 1", "Short output", "", 0, 1),
        ("Audit Script 2", "A" * 300, "Some error occurred", 1, 1),  # Large output
        ("Audit Script 3", "Output 3", "", 0, 1),
         ("Audit Script 1", "Short output", "", 0, 1),
        ("Audit Script 2", "A" * 300, "Some error occurred", 1, 1),  # Large output
        ("Audit Script 3", "Output 3", "", 0, 1),
         ("Audit Script 1", "Short output", "", 0, 1),
        ("Audit Script 2", "A" * 300, "Some error occurred", 1, 1),  # Large output
        ("Audit Script 3", "Output 3", "", 0, 1),
         ("Audit Script 1", "Short output", "", 0, 1),
        ("Audit Script 2", "A" * 300, "Some error occurred", 1, 1),  # Large output
        ("Audit Script 3", "Output 3", "", 0, 1),
         ("Audit Script 1", "Short output", "", 0, 1),
        ("Audit Script 2", "A" * 300, "Some error occurred", 1, 1),  # Large output
        ("Audit Script 3", "Output 3", "", 0, 1),
         ("Audit Script 1", "Short output", "", 0, 1),
        ("Audit Script 2", "A" * 300, "Some error occurred", 1, 1),  # Large output
        ("Audit Script 3", "Output 3", "", 0, 1),
         ("Audit Script 1", "Short output", "", 0, 1),
        ("Audit Script 2", "A" * 300, "Some error occurred", 1, 1),  # Large output
        ("Audit Script 3", "Output 3", "", 0, 1),
         ("Audit Script 1", "Short output", "", 0, 1),
        ("Audit Script 2", "A" * 300, "Some error occurred", 1, 1),  # Large output
        ("Audit Script 3", "Output 3", "", 0, 1),
         ("Audit Script 1", "Short output", "", 0, 1),
        ("Audit Script 2", "A" * 300, "Some error occurred", 1, 1),  # Large output
        ("Audit Script 3", "Output 3", "", 0, 1),
        
    ]

    for script_name, output, error, return_code, session_id in sample_data:
        cursor.execute("""
            INSERT INTO results (script_name, output, error, return_code, "sessionID")
            VALUES (?, ?, ?, ?, ?);
        """, (script_name, output, error, return_code, session_id))

    conn.commit()
    conn.close()
    print(f"Sample database created at {db_path}")


if __name__ == "__main__":
    # Path to the sample SQLite database
    database_path = "sample_results.db"

    # Create the sample database
    create_sample_database(database_path)

    # Run the application
    app = QApplication([])
    window = AuditResultsPage(database_path)
    window.show()
    app.exec()
