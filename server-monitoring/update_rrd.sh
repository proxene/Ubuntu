#!/bin/bash

# Get System Values
cpu_usage=$(ps aux --sort=-%cpu | head -n 2 | tail -n 1 | awk '{print $3}')
io_delay=$(iostat -x | grep '^sda' | awk '{print $4}')
total_mem=$(free -m | grep Mem | awk '{print $2}')
used_mem=$(free -m | grep Mem | awk '{print $3}')
total_disk=$(df / | grep / | awk '{print $2}' | sed 's/%//g')
used_disk=$(df / | grep / | awk '{print $3}' | sed 's/%//g')

# Updating RRD Database
rrdtool update /opt/server-monitoring/system.rrd N:$cpu_usage:$io_delay:$total_mem:$used_mem:$total_disk:$used_disk
