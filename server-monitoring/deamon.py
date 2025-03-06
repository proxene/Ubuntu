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
            "--title=CPU Usage et IODelay",
            "--width=800", "--height=400",
            "DEF:cpu_usage=system.rrd:cpu_usage:AVERAGE",
            "DEF:io_delay=system.rrd:io_delay:AVERAGE",
            "LINE2:cpu_usage#00FF00:CPU Usage (%)",  # Vert pour CPU Usage
            "LINE2:io_delay#0000FF:IODelay (%)"     # Bleu pour IODelay
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
            "DEF:total_mem=system.rrd:total_mem:AVERAGE",
            "DEF:used_mem=system.rrd:used_mem:AVERAGE",
            "LINE2:total_mem#00FF00:Total Memory (MB)",  # Vert pour mémoire totale
            "LINE2:used_mem#0000FF:Used Memory (MB)"    # Bleu pour mémoire utilisée
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
            "DEF:total_disk=system.rrd:total_disk:AVERAGE",
            "DEF:used_disk=system.rrd:used_disk:AVERAGE",
            "LINE2:total_disk#00FF00:Total Disk Space (GB)",  # Vert pour espace disque total
            "LINE2:used_disk#0000FF:Used Disk Space (GB)"    # Bleu pour espace disque utilisé
        ])
        return send_file(graph_path, mimetype='image/png')
    except Exception as e:
        return jsonify({"error": str(e)})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
