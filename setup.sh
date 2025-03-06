#!/bin/bash

# Automatic installation script for Ubuntu Monitoring

# Variables
GITHUB_BASE_URL="https://raw.githubusercontent.com/proxene/Ubuntu-Monitoring/main/server-monitoring"
UPDATE_RRD_URL="${GITHUB_BASE_URL}/update_rrd.sh"
DAEMON_PY_URL="${GITHUB_BASE_URL}/daemon.py"
INSTALL_DIR="/opt/server-monitoring"
SERVICE_NAME="server-monitoring"

# Create the installation directory
echo "Creating installation directory: ${INSTALL_DIR}"
sudo mkdir -p "${INSTALL_DIR}"
cd "${INSTALL_DIR}"

# Install dependencies
echo "Installing dependencies..."
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y python3 python3-pip rrdtool sysstat bc
sudo pip3 install psutil flask requests

# Download files from GitHub
echo "Downloading files from GitHub..."
sudo curl -o "${INSTALL_DIR}/update_rrd.sh" "${UPDATE_RRD_URL}"
sudo curl -o "${INSTALL_DIR}/daemon.py" "${DAEMON_PY_URL}"

# Make scripts executable
echo "Making scripts executable..."
sudo chmod +x "${INSTALL_DIR}/update_rrd.sh"
sudo chmod +x "${INSTALL_DIR}/daemon.py"

# Create the RRD database
echo "Creating the RRD database..."
rrdtool create "${INSTALL_DIR}/system.rrd" --step 300 \
    DS:cpu_usage:GAUGE:600:0:100 \
    DS:io_delay:GAUGE:600:0:100 \
    DS:total_mem:GAUGE:600:0:U \
    DS:used_mem:GAUGE:600:0:U \
    DS:total_disk:GAUGE:600:0:U \
    DS:used_disk:GAUGE:600:0:U \
    RRA:AVERAGE:0.5:1:2880 \
    RRA:AVERAGE:0.5:5:576

# Configure cron to run update_rrd.sh every 5 minutes
echo "Configuring cron for update_rrd.sh..."
(crontab -l 2>/dev/null; echo "*/5 * * * * ${INSTALL_DIR}/update_rrd.sh") | sudo crontab -

# Configure systemd service for daemon.py
echo "Configuring systemd service for daemon.py..."
sudo bash -c "cat > /etc/systemd/system/${SERVICE_NAME}.service" <<EOF
[Unit]
Description=Server Monitoring Daemon
After=network.target

[Service]
ExecStart=/usr/bin/python3 ${INSTALL_DIR}/daemon.py
WorkingDirectory=${INSTALL_DIR}
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start the service
echo "Enabling and starting the systemd service..."
sudo systemctl daemon-reload
sudo systemctl enable "${SERVICE_NAME}.service"
sudo systemctl start "${SERVICE_NAME}.service"

# Check the service status
echo "Checking the service status..."
sudo systemctl status "${SERVICE_NAME}.service"

# Installation complete
echo "Installation complete!"
echo "The update_rrd.sh script runs every 5 minutes via cron."
echo "The daemon.py script runs as a systemd service."
echo "You can access the web interface at:"
echo "  - System Info (JSON) : http://<IP>:5000/system_info"
echo "  - CPU (Graph) : http://<IP>:5000/graph/cpu"
echo "  - Memory (Graph) : http://<IP>:5000/graph/memory"
echo "  - Disk (Graph) : http://<IP>:5000/graph/disk"
