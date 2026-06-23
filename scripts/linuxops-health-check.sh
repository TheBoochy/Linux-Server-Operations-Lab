#!/bin/bash

echo "========================================"
echo " LinuxOps Server Health Check"
echo "========================================"
echo

echo "Hostname:"
hostname
echo

echo "Date and time:"
date
echo

echo "Uptime:"
uptime
echo

echo "Logged-in users:"
who
echo

echo "Disk usage:"
df -h
echo

echo "Memory usage:"
free -h
echo

echo "Failed systemd services:"
systemctl --failed
echo

echo "Backup timer status:"
systemctl is-enabled linuxops-backup.timer 2>/dev/null
systemctl is-active linuxops-backup.timer 2>/dev/null
echo

echo "Latest backup archive:"
sudo find /backups -name "*.tar.gz" -type f -printf "%T@ %p\n" 2>/dev/null | sort -nr | head -n 1 | cut -d' ' -f2-
echo

echo "Health check completed."