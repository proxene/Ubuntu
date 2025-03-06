#!/bin/bash

# Get System Values
cpu_usage=$(ps aux --sort=-%cpu | head -n 2 | tail -n 1 | awk '{print $3}')
io_delay=$(iostat -x | grep '^sda' | awk '{print $4}')

total_mem=$(free -m | grep Mem | awk '{print $2}')
used_mem=$(free -m | grep Mem | awk '{print $3}')

total_disk=$(df / | tail -1 | awk '{print $2}')
used_disk=$(df / | tail -1 | awk '{print $3}')


# Data Processing
total_mem_gb=$(echo "scale=2; $total_mem/1024" | bc)
used_mem_gb=$(echo "scale=2; $used_mem/1024" | bc)

total_disk_gb=$(echo "scale=2; $total_disk/1048576" | bc)
used_disk_gb=$(echo "scale=2; $used_disk/1048576" | bc)


# Updating RRD Database
rrdtool update system.rrd N:$cpu_usage:$io_delay:$total_mem:$used_mem:$total_disk:$used_disk
