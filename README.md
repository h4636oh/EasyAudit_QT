# EasyAudit

================

EasyAudit is an automation tool designed to simplify the process of running audit scripts according to the CIS Benchmark on various operating systems, including Ubuntu, Windows, and RHEL.

## Overview

------------

EasyAudit aims to provide a user-friendly interface for IT administrators and security professionals to ensure compliance with the CIS Benchmark standards. By automating the audit process, EasyAudit saves time and reduces the risk of human error.

## Features

------------

* Supports audit scripts for Ubuntu, Windows, and RHEL operating systems
* Automated audit process for CIS Benchmark compliance
* User-friendly interface built with PySide6 and Qt

## Requirements

------------

* Python 3.x
* Qt

## Usage

------------

### Installation

To install EasyAudit, follow these steps:

1. Clone the repository: `git clone https://github.com/your-repo/easy-audit.git`
2. Create a virtual environment: `python -m venv easy-audit-venv`
3. Activate the virtual environment:
    * On Windows: `easy-audit-venv\Scripts\activate`
    * On Linux/Mac: `source easy-audit-venv/bin/activate`
4. Install dependencies: `pip install -r requirements.txt`
5. Run the application: `python main.py`

### Running an Audit

1. Launch EasyAudit and select the operating system you want to audit
2. Choose the CIS Benchmark standard you want to comply with
3. Click "Run Audit" to start the automated audit process

## Contributing

------------

We welcome contributions to EasyAudit! If you'd like to report a bug, suggest a feature, or submit a pull request, please visit our [issue tracker](https://github.com/h4636oh/EasyAudit_QT/issues).

## License

------------

EasyAudit is licensed under [your license here]. See the [LICENSE](LICENSE) file for details.

## Acknowledgments

------------

We'd like to thank the CIS Benchmark team for their work on creating and maintaining the benchmark standards.
