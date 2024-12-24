import sys, os, platform, subprocess, sqlite3, json, datetime
from osinfo import check_os
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
