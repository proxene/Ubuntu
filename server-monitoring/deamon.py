import psutil
import requests
import json
import os
import subprocess
from flask import Flask, jsonify, send_file

app = Flask(__name__)

def get_system_info():
    """Gets system information (CPU, RAM, Storage)"""
    info = {
        "cpu_usage": psutil.cpu_percent(interval=1),
        "memory_usage": psutil.virtual_memory().percent,
        "disk_usage": psutil.disk_usage('/').percent
    }
    return info

@app.route('/system_info', methods=['GET'])
def system_info():
    """Returns system information in JSON format."""
    return jsonify(get_system_info())

@app.route('/graph/cpu', methods=['GET'])
def get_cpu_graph():
    """Generates and returns the CPU usage graph."""
    graph_path = "/tmp/cpu_usage.png"
    try:
        subprocess.run([
            "rrdtool", "graph", graph_path,
            "--title=CPU Usage",
            "--width=800", "--height=400",
            "DEF:cpu=system.rrd:cpu:AVERAGE",
            "LINE2:cpu#FF0000:CPU Usage"
        ])
        return send_file(graph_path, mimetype='image/png')
    except Exception as e:
        return jsonify({"error": str(e)})

@app.route('/graph/memory', methods=['GET'])
def get_memory_graph():
    """Generates and returns the memory usage graph."""
    graph_path = "/tmp/memory_usage.png"
    try:
        subprocess.run([
            "rrdtool", "graph", graph_path,
            "--title=Memory Usage",
            "--width=800", "--height=400",
            "DEF:mem=system.rrd:mem:AVERAGE",
            "LINE2:mem#00FF00:Memory Usage"
        ])
        return send_file(graph_path, mimetype='image/png')
    except Exception as e:
        return jsonify({"error": str(e)})

@app.route('/graph/disk', methods=['GET'])
def get_disk_graph():
    """Generates and returns the disk usage graph."""
    graph_path = "/tmp/disk_usage.png"
    try:
        subprocess.run([
            "rrdtool", "graph", graph_path,
            "--title=Disk Usage",
            "--width=800", "--height=400",
            "DEF:disk=system.rrd:disk:AVERAGE",
            "LINE2:disk#0000FF:Disk Usage"
        ])
        return send_file(graph_path, mimetype='image/png')
    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
