import sys, os, platform, subprocess, sqlite3, json, datetime
from fpdf import FPDF
from PySide6.QtWidgets import QApplication, QStackedWidget, QFileDialog
from PySide6 import QtWidgets, QtCore
from PySide6.QtUiTools import QUiLoader
from PySide6.QtCore import QCoreApplication, QUrl
from PySide6.QtGui import QDesktopServices
import filterList

def bitlocker_status():
    
    """
    Enable or disable the "BitLocker" button on the "New Audit" page,
    depending on whether the system is Windows or not.
    """
    
    if platform.system() == "Windows":
        new_audit_page.bitlocker_btn.setEnabled(True)
        new_audit_page.workstation_btn.setEnabled(False)
        new_audit_page.server_btn.setEnabled(False)
    else:
        new_audit_page.bitlocker_btn.setEnabled(False)

def check_os():
    """
    Check the operating system and return the OS type.
    
    Returns:
    str: The type of the operating system: "Ubuntu", "rhel_9", or "Windows".
    """
    # Check if the system is Linux
    if platform.system() == "Linux":
        # Try to determine if it's Ubuntu or rhel_9
            with open("/etc/os-release", "r") as f:
                os_info = f.read()
            if "Ubuntu" in os_info:
                return "Ubuntu"
            elif "Red Hat" in os_info or "rhel_9" in os_info or "fedora" in os_info:
                return "rhel_9"
            else:
                return "Windows"
    else:
        return "Windows"

def open_cis_website():
    """
    Open the CIS website in a web browser.
    """
    QDesktopServices.openUrl(QUrl("https://www.cisecurity.org/"))

def get_clean_linux_version():
    """
    Try to get the clean version name of the Linux distribution.
    For example, if the PRETTY_NAME is "Red Hat Enterprise Linux 9.0 (Plow)", return "Red Hat Enterprise Linux 9.0".
    If the file does not exist, return the result of platform.system(), which is "Linux".
    Returns:
    str: The clean version name of the Linux distribution.
    """
    try:
        with open("/etc/os-release", "r") as file:
            for line in file:
                if line.startswith("PRETTY_NAME="):
                    return line.split("=")[1].strip().replace('"', '')
    except FileNotFoundError:
        return platform.system()

def get_system_info():
    """
    Get information about the system such as the hostname, OS name, OS version,
    kernel version, machine architecture, and processor.

    Returns:
    dict: A dictionary containing the system information.
    """
    os_name = platform.system()
    hostname = os.uname()[1] if hasattr(os, 'uname') else platform.node()
    os_version = None
    kernel_version = None
    machine_arch = None
    processor = None

    if os_name == "Linux":
        os_version = get_clean_linux_version()
        kernel_version = platform.release()
        machine_arch = platform.machine()
        try:
            processor = subprocess.check_output("lscpu | grep 'Model name:'", shell=True).decode('utf-8').strip().split(":")[1].strip()
        except (subprocess.CalledProcessError, IndexError):
            processor = "Unknown"

    elif os_name == "Windows":
        os_version = '.'.join(platform.win32_ver()[1].split('.')[:2])
        kernel_version = platform.release()
        machine_arch = platform.machine()
        processor = platform.processor()

    elif os_name == "Darwin":
        os_version = platform.mac_ver()[0]
        kernel_version = platform.release()
        machine_arch = platform.machine()
        processor = platform.processor()

    else:
        os_version = "Unknown"
        kernel_version = "Unknown"
        machine_arch = "Unknown"
        processor = "Unknown"

    return {
        "hostname": f"HOSTNAME - {hostname}",
        "os_name": f"OS NAME - {os_name}",
        "os_version": f"OS VERSION - {os_version}",
        "kernel_version": f"KERNEL - {kernel_version}",
        "machine_arch": f"MACHINE ARCH - {machine_arch}",
        "processor": f"PROCESSOR - {processor}"
    }

def load_complete_json():
    """
    Load the complete JSON data from a file corresponding to the operating system.

    The function determines the operating system using the check_os function, constructs
    the file name by appending ".json" to the OS name, and then loads the JSON data from
    the corresponding file in the 'scripts' directory.

    Returns:
    dict: The loaded JSON data.
    """

    os_name = check_os()
    file_name = os_name + ".json"
    file_path = os.path.join('scripts', file_name)
    with open(file_path, 'r',encoding='utf-8') as file:
        return json.load(file)

def load_module_to_name():
    """
    Load the module to name data from a file corresponding to the operating system.

    The function determines the operating system using the check_os function, constructs
    the file name by appending "_moduleToName.json" to the OS name, and then loads the JSON
    data from the corresponding file in the 'scripts' directory.

    Returns:
    dict: The loaded module to name data.
    """
    os_name = check_os()
    file_name = os_name + "_moduleToName.json"
    file_path = os.path.join('scripts', file_name)
    with open(file_path, 'r') as file:
        return json.load(file)

def search_bar_filter_select_page():
    """
    Filter and display scripts in the script selection display based on search input.

    The function retrieves the text entered in the search bar and iterates through 
    the items in the script selection display. It compares the search text with each 
    item's text, hiding those that do not match the search criteria.

    This function is intended to be used as a dynamic search filter for the script 
    selection page, allowing users to easily find scripts by typing in the search bar.
    """

    search_text = audit_select_page.search_bar.text()
    for i in range(audit_select_page.script_select_display.count()):
        item = audit_select_page.script_select_display.item(i)
        if search_text.lower() in item.text().lower():
            item.setHidden(False)
        else:
            item.setHidden(True)

def search_bar_filter_result_page():
    """
    Filter and display audit results based on search input.

    This function retrieves the text entered in the search bar and iterates through 
    the items in the audit results list widget. It compares the search text with each
    item's text, hiding those that do not match the search criteria.

    This function is intended to be used as a dynamic search filter for the audit 
    results page, allowing users to easily find audit results by typing in the search bar.
    """

    search_text = audit_result_page.search_bar.text()
    for i in range(audit_result_page.audit_results_list_widget.count()):
        item = audit_result_page.audit_results_list_widget.item(i)
        if search_text.lower() in item.text().lower():
            item.setHidden(False)
        else:
            item.setHidden(True)

def isSelected(script_name):
    """
    Checks if a script is selected based on the current OS and level filter.

    The function takes a script name as input and checks if it is selected based on the current
    OS and level filter. The selection is determined by checking if the script name is in the
    corresponding filter list for the current OS and level.

    Returns:
        bool: True if the script is selected, False otherwise.
    """
    os_name = check_os()
    if os_name == "rhel_9":
        if (isworkstation and islevel1) and script_name in filterList.RehlWL1:
            return True
        if (isworkstation and islevel2) and script_name in filterList.RehlWL2:
            return True
        if (isserver and islevel1) and script_name in filterList.RehlSL1:
            return True
        if (isserver and islevel2) and script_name in filterList.RehlSL2:
            return True
    elif os_name == "Ubuntu":
        if (isworkstation and islevel1) and script_name in filterList.UbantuWL1:
            return True
        if (isworkstation and islevel2) and script_name in filterList.UbantuWL2:
            return True
        if (isserver and islevel1) and script_name in filterList.UbantuSL1:
            return True
        if (isserver and islevel2) and script_name in filterList.UbantuSL2:
            return True
    elif os_name == "Windows":
        if (isbitlocker and islevel1) and (script_name in filterList.WindowsBL and script_name in filterList.WindowsL1):
            return True
        if (isbitlocker and islevel2) and (script_name in filterList.WindowsBL and script_name in filterList.WindowsL2):
            return True
        if ((not isbitlocker) and islevel1) and (script_name not in filterList.WindowsBL and script_name in filterList.WindowsL1):
            return True
        if ((not isbitlocker) and islevel2) and (script_name not in filterList.WindowsBL and script_name in filterList.WindowsL1):
            return True
    return False


def audit_select_page_populate_script_list():
    """
    Populate the script selection display with available audit scripts.

    This function clears the script selection display, retrieves the OS name, and 
    populates the display with the available audit scripts in the corresponding 
    directory. It also loads the module information from the JSON file and adds 
    tooltips to each item in the display containing the module description.

    This function is intended to be used when the script selection page is first 
    initialized, and whenever the user navigates back to the script selection page.
    """
    audit_select_page.script_select_display.clear()
    os_name = check_os()
    script_dir = None
    if os_name == "Ubuntu":
        script_dir = 'scripts/audits/ubuntu'
    if os_name == "rhel_9":
        script_dir = 'scripts/audits/rhel_9'
    if os_name == "Windows":
        script_dir = 'scripts/audits/windows'
    if os.path.isdir(script_dir):
        module_info = load_complete_json()
        for script in sorted(os.listdir(script_dir)):
            script_name = os.path.splitext(script)[0]
            script_name = script_name.replace(".audit", "")
            script_info = module_info[script_name] if script_name in module_info else print(f"error : {script_name}", f"script")
            description = script_info["Description"] if script_info else "NULL"
            tooltip_text = description
            module_name = audit_select_page.module_to_name.get(script_name, script_name)
            list_item = QtWidgets.QListWidgetItem(module_name)
            list_item.setFlags(list_item.flags() | QtCore.Qt.ItemIsUserCheckable)
            if isSelected(script_name):
                list_item.setCheckState(QtCore.Qt.Unchecked)
            else:
                list_item.setCheckState(QtCore.Qt.Checked)
            list_item.setData(QtCore.Qt.UserRole, script)
            list_item.setToolTip(tooltip_text)
            audit_select_page.script_select_display.addItem(list_item)        

def audit_select_page_select_all_scripts():
    """
    Toggle the check state of all items in the script selection display based on the
    state of the select all button. If the button is checked, all items are checked,
    and if the button is unchecked, all items are unchecked. If the button is checked,
    a warning dialog is also shown to the user.
    """
    if audit_select_page.select_all_btn.isChecked():
        loader_select_all_warning = QUiLoader()
        select_all_warning = loader_select_all_warning.load('select_all_warning.ui', audit_select_page)
        select_all_warning.show()
        for index in range(audit_select_page.script_select_display.count()):
            item = audit_select_page.script_select_display.item(index)
            item.setCheckState(QtCore.Qt.Checked)
    else:
        for index in range(audit_select_page.script_select_display.count()):
            item = audit_select_page.script_select_display.item(index)
            item.setCheckState(QtCore.Qt.Unchecked)

def audit_select_page_add_new_script():
    """
    Open a file dialog to select a bash script to add to the script selection
    display. The selected script is added to the display as a new item. The
    script is not copied to the scripts directory, it is only added to the
    display. The user must manually copy the script to the correct directory.
    """
    file_path, _ = QFileDialog.getOpenFileName(None, "Select Script", "/home", "Bash Files (*.sh)")
    if file_path:
        script_name = os.path.basename(file_path)
        audit_select_page.script_select_display.addItem(script_name)

def create_tables():
    """
    Create the audit_results table in the database if it does not exist.
    This function should be called once when the application is first started.
    """
    cursor = audit_select_page.database.cursor()
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS audit_results (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            script_name TEXT,
            output TEXT,
            error TEXT,
            return_code INTEGER,
            execution_time TEXT,
            session_id INTEGER
        )
    ''')
    audit_select_page.database.commit()


def run_script(script_path):
    """
    Run the script at the given path with the correct interpreter based on the current
    operating system. If the script is on Ubuntu or rhel_9, it is run with bash. If the
    script is on Windows, it is run with PowerShell. The script is run with the correct
    execution policy based on the operating system.

    Returns:
    stdout (str): The output of the script
    stderr (str): The error output of the script
    returncode (int): The return code of the script
    """
    try:
        os_name = check_os()
        if os_name == "Ubuntu":
            os.chmod(script_path, 0o755)
            result = subprocess.run(["bash", script_path], capture_output=True, text=True)
        if os_name == "rhel_9":
            os.chmod(script_path, 0o755)
            result = subprocess.run(["bash", script_path], capture_output=True, text=True)
        if os_name == "Windows":
            result = subprocess.run(
                ["powershell.exe",
                "-ExecutionPolicy", "Bypass",
                "-File", script_path],
                capture_output=True, text=True
            )
        return result.stdout, result.stderr, result.returncode
    except subprocess.CalledProcessError as e:
        return e.stdout, e.stderr, e.returncode

def add_audit_result(result):
    """
    Adds a new audit result to the database. The result is a dictionary containing the
    script name, output, error, return code, and session id. The execution time is set to
    the current time.

    Args:
        result (dict): A dictionary containing the audit result data.
    """
    create_tables()
    cursor = audit_select_page.database.cursor()
    cursor.execute('''
        INSERT INTO audit_results (script_name, output, error, return_code, execution_time, session_id)
        VALUES (?, ?, ?, ?, datetime('now'), ?)
    ''', (result['script_name'], result['output'], result['error'], result['return_code'], result['session_id']))
    audit_select_page.database.commit()

def audit_selected_scripts():
    """
    Runs all selected audit scripts and saves the results to a log file.

    This function will run all selected audit scripts on the current operating system
    and save the results to a log file. The log file name is determined by the current
    timestamp and the type of operating system being used.

    The function will also update the UI to reflect the progress of the audit.

    Args:
        None

    Returns:
        None
    """
    global logfile_name

    # Get the current operating system name
    os_name = check_os()

    # Set the log file name based on the operating system
    if os_name == "Ubuntu":
        # Set the log file name for Ubuntu
        logfile_name = f'/tmp/audit_log_{datetime.datetime.now().strftime("%Y%m%d%H%M%S")}.txt'
    elif os_name == "rhel_9":
        # Set the log file name for Red Hat Enterprise Linux 9
        logfile_name = f'/tmp/audit_log_{datetime.datetime.now().strftime("%Y%m%d%H%M%S")}.txt'
    elif os_name == "Windows":
        # Create the log directory if it does not exist
        if not os.path.exists('log'):
            os.makedirs('log')
        # Set the log file name for Windows
        logfile_name = f'log/.audit_log_{datetime.datetime.now().strftime("%Y%m%d%H%M%S")}.txt'
    
    # Open the log file for writing
    logfile = open(f'{logfile_name}', 'w')

    # Get the list of selected audit scripts
    selected_items = [audit_select_page.script_select_display.item(i) for i in range(audit_select_page.script_select_display.count()) if audit_select_page.script_select_display.item(i).checkState() == QtCore.Qt.Checked]

    # Increment the session ID for the log file
    global session_id
    session_id += 1

    # Get the number of selected audit scripts
    item_count = len(selected_items)

    # Show the audit progress page
    main_window.setCurrentIndex(3)

    # Run the selected audit scripts and save the results to the log file
    for idx, item in enumerate(selected_items, start=1):
        # Process any events that may have occurred
        QCoreApplication.processEvents()

        # Get the script name from the selected item
        script_name = item.data(QtCore.Qt.UserRole)

        # Update the current script label on the audit progress page
        audit_progress_page.current_script_lbl.setText(str(script_name))

        # Get the script path based on the operating system
        script_path = None
        if os_name == "Ubuntu":
            # Set the script path for Ubuntu
            script_path = os.path.join('scripts/audits/ubuntu', script_name)
        elif os_name == "rhel_9":
            # Set the script path for Red Hat Enterprise Linux 9
            script_path = os.path.join('scripts/audits/rhel_9', script_name)
        elif os_name == "Windows":
            # Set the script path for Windows
            script_path = os.path.join('scripts/audits/windows', script_name)

        # Check if the script exists
        if not os.path.exists(script_path):
            print(f"Script not found: {script_path}")
            continue

        # Run the script and get the output, error, and return code
        stdout, stderr, return_code = run_script(script_path)

        # Create a dictionary with the result data
        result = { 'script_name': script_name, 'output': stdout, 'error': stderr, 'return_code': return_code, 'session_id': session_id}

        # Add the result to the audit results list
        add_audit_result(result)

        # Process any events that may have occurred
        QCoreApplication.processEvents()

        # Update the progress bar on the audit progress page
        progress = int(idx / item_count * 100)
        audit_progress_page.script_progess_bar.setValue(progress)

        # Get the module name from the script name
        script_name = script_name.replace('.audit', '')
        script_name = script_name.replace('.sh', '')
        script_name = script_name.replace('.ps1', '')
        module_name = audit_select_page.module_to_name.get(script_name, script_name)
        
        # Write the result to the log file
        logfile.write(f"Script: {script_name} - {module_name}\n")
        logfile.write(f"Output:{stdout}\n")
        logfile.write(f"Error:{stderr}\n")
        logfile.write(f"Return Code: {return_code}\n\n")

    # Print a message to indicate that the audit is complete
    print("Audit completed")

    # Close the log file
    logfile.close()

    # Show the audit result page
    main_window.setCurrentIndex(4)
    audit_result_page_display_result()

def audit_result_page_display_result():
    """
    This function is used to display the results of the audit on the "Audit Results" page.

    It queries the audit_results database for the results of the current session id, and
    then populates the script_result_display QTreeWidget with the results. Each script is
    represented as a parent item in the QTreeWidget, with child items for the output and
    error of the script. The parent item is colored green for a pass and red for a fail.
    """

    
    newdatabase = sqlite3.connect("audit_results.db")
    
    cursor = newdatabase.cursor()
    
    create_tables()
    cursor.execute("""
            SELECT script_name, return_code, output, error
            FROM audit_results
            WHERE session_id = ?
        """, (session_id,))

    rows = cursor.fetchall()
    audit_result_page.script_result_display.clear()  # Clear previous results
    module_to_name = load_module_to_name()
    for row_idx, (script_name, return_code, output, error) in enumerate(rows):
        temp = script_name.replace('.sh', '')
        temp = temp.replace('.ps1', '')
        temp = temp.replace('.audit', '')
        module_name = module_to_name.get(temp, temp)
        audit_result_page.script_result_display.setWordWrap(True)

        # Create parent item for the script
        parent_item = QtWidgets.QTreeWidgetItem(audit_result_page.script_result_display)
        if return_code == 0:  # Pass
            parent_item.setText(0, f"PASS: {module_name}")
        else:
            parent_item.setText(0, f"FAIL: {module_name}")

        # Add placeholder details as child items

        # Truncate if output is too long

        if output != "":
            child_output = QtWidgets.QTreeWidgetItem(parent_item)
            child_output.setText(0, f"{output}")
            # child_output.setwordWrap(True)
        # Truncate if error is too long

        if error != "" :
            child_error = QtWidgets.QTreeWidgetItem(parent_item)
            child_error.setText(0, f"{error}")
            # child_error.setwordWrap(True)
        # Truncate if error is too long

        # Expand all items by default (optional)
        parent_item.setExpanded(False)


def new_audit_filters():
    """
    Gets the current state of the filters on the new audit page and prints them.
    Switches the main window to the audit select page.
    """
    global isworkstation, isserver, islevel1, islevel2, isbitlocker
    isworkstation = new_audit_page.workstation_btn.isChecked()
    isserver = new_audit_page.server_btn.isChecked()
    islevel1 = new_audit_page.level1_btn.isChecked()
    islevel2 = new_audit_page.level2_btn.isChecked()
    isbitlocker = new_audit_page.bitlocker_btn.isChecked()
    audit_select_page_populate_script_list()
    main_window.setCurrentIndex(2)

if __name__ == "__main__":
    session_id = 0
    app = QApplication(sys.argv)
    main_window = QStackedWidget()

    # Load and set up the start page
    loader_start_page = QUiLoader()
    start_page = loader_start_page.load("start_page.ui", main_window)
    main_window.addWidget(start_page)

    # Display system information on the start page
    system_info = get_system_info()
    start_page.hostname_lbl.setText(system_info["hostname"])
    start_page.os_name_lbl.setText(system_info["os_name"])
    start_page.os_version_lbl.setText(system_info["os_version"])
    start_page.kernel_lbl.setText(system_info["kernel_version"])
    start_page.mach_arch_lbl.setText(system_info["machine_arch"])
    start_page.processor_lbl.setText(system_info["processor"])

    # Load and set up the new audit page
    loader_new_audit_page = QUiLoader()
    new_audit_page = loader_new_audit_page.load("new_audit_page.ui", main_window)
    main_window.addWidget(new_audit_page)

    # Initialize BitLocker status
    bitlocker_status()

    # Connect start page button to switch to new audit page
    start_page.new_audit_btn.clicked.connect(lambda: main_window.setCurrentIndex(1))

    # Load and set up the audit select page
    loader_audit_select_page = QUiLoader()
    audit_select_page = loader_audit_select_page.load("audit_select_page.ui", main_window)
    main_window.addWidget(audit_select_page)

    # Set up search functionality in audit select page
    audit_select_page.search_bar.returnPressed.connect(search_bar_filter_select_page)

    # Load and set up the audit progress page
    loader_audit_progess_page = QUiLoader()
    audit_progress_page = loader_audit_progess_page.load("audit_progress_page.ui", None)
    main_window.addWidget(audit_progress_page)

    # Initialize filter states
    isworkstation = None
    isserver = None
    islevel1 = None
    islevel2 = None
    isbitlocker = None

    # Connect continue button to apply filters
    new_audit_page.continue_btn.clicked.connect(new_audit_filters)

    # Set up audit select page
    audit_select_page.module_to_name = load_module_to_name()
    audit_select_page.database = sqlite3.connect('audit_results.db')
    create_tables()
    audit_select_page.select_all_btn.clicked.connect(audit_select_page_select_all_scripts)

    # Retrieve session ID from database
    if os.path.exists("audit_results.db"):
        create_tables()
        cursor = audit_select_page.database.cursor()
        cursor.execute('''select max(session_id) from audit_results''')
        result = cursor.fetchone()
        cursor.close()
        session_id = result[0] if result[0] else 0

    # Connect back button to return to start page
    audit_select_page.back_btn.clicked.connect(lambda: main_window.setCurrentIndex(0))

    # Load and set up the audit result page
    loader_audit_result_page = QUiLoader()
    audit_result_page = loader_audit_result_page.load("audit_result_page.ui", main_window)
    main_window.addWidget(audit_result_page)

    # Set up search functionality in audit result page
    audit_result_page.search_bar.returnPressed.connect(search_bar_filter_result_page)

    # Connect audit button to run selected scripts
    audit_select_page.audit_btn.clicked.connect(audit_selected_scripts)

    # Connect home button to return to start page
    audit_result_page.home_btn.clicked.connect(lambda: main_window.setCurrentIndex(0))

    # Connect benchmark buttons to open CIS website
    start_page.cis_benchmark_btn.clicked.connect(open_cis_website)
    new_audit_page.cis_benchmark_btn.clicked.connect(open_cis_website)

    logfile_name = None

    # Function to save logs as PDF
    def save_logs():
        log_data = open(f'{logfile_name}', 'r').read()
        pdf = FPDF()
        pdf.add_page()
        pdf.set_font("Arial", size = 15)
        pdf.multi_cell(0, 5, txt = log_data)
        filename = QFileDialog.getSaveFileName(audit_result_page, "Save Log PDF", "", "PDF File (*.pdf)")
        if filename[0]:
            pdf.output(f"{filename[0]}.pdf", "F")

    # Connect export button to save logs
    audit_result_page.export_btn.clicked.connect(save_logs)

    main_window.show()
    sys.exit(app.exec())
