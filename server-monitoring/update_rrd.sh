#!/bin/bash

# Get all system values
CPU=$(ps -eo pcpu | awk 'NR>1' | awk '{sum+=$1} END {print sum}')
MEM=$(free | awk '/Mem/ {printf "%.2f", $3/$2 * 100}')
DISK=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

# Udpate RRD Database
rrdtool update /opt/server-monitoring/system.rrd N:$CPU:$MEM:$DISK
