<a id="readme-top"></a>


# Ubuntu Monitoring

[![GitHub Issues](https://img.shields.io/github/issues/proxene/Ubuntu-Monitoring.svg?style=for-the-badge)](https://github.com/proxene/Ubuntu-Monitoring/issues)
[![License](https://img.shields.io/github/license/proxene/Ubuntu-Monitoring.svg?style=for-the-badge)](https://github.com/proxene/Ubuntu-Monitoring/blob/main/LICENSE)
[![Python Version](https://img.shields.io/badge/Python-3.x-blue.svg?style=for-the-badge)](https://www.python.org/)
[![RRDTool](https://img.shields.io/badge/RRDTool-1.8.0-green.svg?style=for-the-badge)](https://oss.oetiker.ch/rrdtool/)<br /><br />

This project allows you to monitor system metrics such as CPU usage, memory, and disk usage. It uses RRDTool for data storage and Flask for serving the metrics through a web interface.

<br />

## Table of Contents

1. [Installation](#installation)
2. [Usage](#usage)
3. [Uninstallation](#uninstallation)
4. [Contributing](#contributing)
5. [License](#license)

<br />

## Installation

To install the monitoring system in one command, run the following:

```bash
bash <(curl -s https://raw.githubusercontent.com/proxene/Ubuntu-Monitoring/main/setup.sh || wget -qO - https://raw.githubusercontent.com/proxene/Ubuntu-Monitoring/main/setup.sh)
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<br />

## Usage

Once the script is running, you can access the system metrics via the following URLs in your web browser:

System Info (JSON) : http://127.0.0.1:5000/system_info<br />
CPU (Graph) : http://127.0.0.1:5000/graph/cpu<br />
Memory (Graph) : http://127.0.0.1:5000/graph/memory<br />
Disk (Graph) : http://127.0.0.1:5000/graph/disk

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<br />

## Uninstallation
If you want to uninstall the monitoring system, follow these steps:

  <br />

  * Stop and disable the systemd service:
  
  ```bash
  sudo systemctl stop server-monitoring.service
  sudo systemctl disable server-monitoring.service
  sudo rm /etc/systemd/system/server-monitoring.service
  sudo systemctl daemon-reload
  ```

  <br />

  * Remove the cron job:

  ```bash
  sudo crontab -l | grep -v "/opt/server-monitoring/update_rrd.sh" | sudo crontab -
  ```
  
  <br />

  * Delete the installation directory:

  ```bash
  sudo rm -rf /opt/server-monitoring
  ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<br />

## License

This project is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International License (CC BY-NC-ND 4.0). See the [LICENSE](LICENSE) file for details.

<p align="right">(<a href="#readme-top">back to top</a>)</p>
