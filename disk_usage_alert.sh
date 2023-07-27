#!/bin/bash

# Set the threshold for disk usage (in percentage)
threshold=90

# Get the disk usage of the root mount point
disk_usage=$(df -h / | tail -n 1 | awk '{print $5}' | sed 's/%//')

# Check if disk usage is above the threshold
if [ "$disk_usage" -gt "$threshold" ]; then
    # Replace 'rohan77x@gmail.com' with the actual email address to receive the alert
    email="rohan77x@gmail.com"
    subject="Disk Usage Alert on $(hostname)"
    message="Disk usage on $(hostname) is above ${threshold}%.\n\nCurrent Disk Usage: ${disk_usage}%"
    echo -e "$message" | mail -s "$subject" "$email"
fi
