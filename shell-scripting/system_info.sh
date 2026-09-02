#!/usr/bin/env bash

set -eu

current_date=$(date)
current_hostname=$(hostname)
current_username=$(whoami)

echo "Current date: $current_date"
echo "Hostname: $current_hostname"
echo "Username: $current_username"

echo
echo "Disk usage:"
df -h

echo
echo "Running processes:"
ps aux

read -r -p "Enter a directory for the process report: " output_directory

mkdir -p "$output_directory"
report_file="$output_directory/running_processes.txt"
touch "$report_file"
ps aux > "$report_file"

echo "Running process information saved to $report_file"

