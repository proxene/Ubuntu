<a id="readme-top"></a>

[![Issues][issues-shield]][issues-url]<br /><br />

This project allows you to monitor system metrics such as CPU usage, memory, and disk usage. It uses RRDTool for data storage and Flask for serving the metrics through a web interface.<br /><br />

### Packages

Before running the application, ensure you have the required packages installed on your system:

  ```sh
  sudo apt update
  sudo apt install python3 python3-pip rrdtool sysstat
  pip install psutil flask requests
  ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### RRDTool Database

This project uses RRDTool for storing system metrics. You need to create an RRD database before running the application. Use this command to initialize a new database file system.rrd with a 5-minute step interval and several data sources (DS) for monitoring CPU, memory, disk usage, etc :

```unix
rrdtool create system.rrd --step 300 \
    DS:cpu_usage:GAUGE:600:0:100 \
    DS:io_delay:GAUGE:600:0:100 \
    DS:total_mem:GAUGE:600:0:100 \
    DS:used_mem:GAUGE:600:0:100 \
    DS:total_disk:GAUGE:600:0:100 \
    DS:used_disk:GAUGE:600:0:100 \
    RRA:AVERAGE:0.5:1:2880 \
    RRA:AVERAGE:0.5:5:576
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<hr><br />

### Usage

Once the script is running, you can access the system metrics via the following URLs in your web browser:

System Info (JSON) : http://127.0.0.1:5000/system_info<br />
CPU (Graph) : http://127.0.0.1:5000/graph/cpu<br />
Memory (Graph) : http://127.0.0.1:5000/graph/memory<br />
Disk (Graph) : http://127.0.0.1:5000/graph/disk

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
[issues-url]: https://github.com/proxene/Ubuntu/issues
[issues-shield]: https://img.shields.io/github/issues/othneildrew/Best-README-Template.svg?style=for-the-badge
