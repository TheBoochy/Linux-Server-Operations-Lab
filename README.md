# Linux Server Operations Lab

## Overview

Linux Server Operations Lab is a voluntary sysadmin portfolio project focused on practical Linux server administration, operations, monitoring and troubleshooting.

The project demonstrates core Linux operations skills, including server setup, SSH administration, users and groups, sudo access, firewall review, systemd service management, backup scripting, scheduled jobs, log review, monitoring and troubleshooting documentation.

The lab is built around a Red Hat Enterprise Linux server running in VMware. Each task is documented step by step with commands, explanations, screenshots and Git commits.

Public documentation uses the name **Vulkan**.

---

## Scenario

A small organization needs a Linux operations server that can be administered remotely, monitored, backed up and documented properly.

The goal of this lab is to build, configure, test and document a Linux server environment using realistic junior sysadmin tasks.

---

## Lab environment

| Item                   | Value                            |
| ---------------------- | -------------------------------- |
| Server name            | srv-linuxops01                   |
| Operating system       | Red Hat Enterprise Linux 10.1    |
| Installation type      | Minimal Install                  |
| Virtualization         | VMware                           |
| Network mode           | NAT                              |
| Main user              | vulkan                           |
| Server IP              | 192.168.80.134                   |
| Network interface      | ens160                           |
| Project type           | Voluntary sysadmin portfolio lab |
| Repository             | Linux-Server-Operations-Lab      |
| Documentation identity | Vulkan                           |

---

## Skills demonstrated

This project demonstrates:

* Linux server installation and verification
* SSH remote administration
* Linux user and group management
* Sudo access testing
* Firewall review with firewalld
* Listening service checks with ss
* Bash scripting
* Custom systemd service creation
* Systemd timer scheduling
* Backup scripting with tar
* Backup verification
* Log review with journalctl
* Login history checks
* Disk and memory checks
* Troubleshooting documentation
* Basic Linux monitoring
* Git and GitHub documentation workflow

---

## Project structure

```text
Linux-Server-Operations-Lab/
├── backups/
├── docs/
│   └── troubleshooting_cases.md
├── results/
├── screenshots/
├── scripts/
│   └── linuxops-health-check.sh
├── logbook.md
└── README.md
```

---

## Completed lab parts

| Part    | Topic                          | Status   |
| ------- | ------------------------------ | -------- |
| Part 1  | Repository setup and planning  | Complete |
| Part 2  | Linux server VM installation   | Complete |
| Part 3  | Network and SSH administration | Complete |
| Part 4  | Users, groups and sudo access  | Complete |
| Part 5  | Firewall and basic hardening   | Complete |
| Part 6  | Systemd service management     | Complete |
| Part 7  | Backup script                  | Complete |
| Part 8  | Scheduled backup job           | Complete |
| Part 9  | Log review and troubleshooting | Complete |
| Part 10 | Monitoring script              | Complete |

---

## Main work completed

### Server setup

The Linux server was installed using Red Hat Enterprise Linux 10.1 Minimal Install. The hostname, network interface, IP address, disk usage and memory usage were verified.

### SSH administration

SSH was verified as active and listening on port 22. Remote login from Windows PowerShell was tested successfully using the `vulkan` account.

### Users, groups and sudo

Linux groups and users were created for operations, backup and limited-user testing. Sudo access was tested with an admin user, and a limited user was verified as not having sudo access.

### Firewall and hardening review

The firewall was reviewed with `firewall-cmd`, and listening services were checked with `ss`. SSH was confirmed as the main externally listening administration service.

### Systemd service management

A custom heartbeat script and systemd service were created. The service writes a timestamped message to a log file and demonstrates basic custom service management.

### Backup automation

A backup script was created to archive `/etc` and `/home` into timestamped `.tar.gz` files. The backup output and log file were verified.

### Scheduled backup job

A systemd service and timer were created for the backup script. The timer runs the backup job daily at 02:00 and uses `Persistent=true`.

### Log review and troubleshooting

System logs, SSH logs, custom service logs, backup service logs, login history, disk usage and memory usage were reviewed. A troubleshooting document was created with realistic Linux support cases.

### Monitoring script

A health-check script was created to display basic server status information, including hostname, date, uptime, logged-in users, disk usage, memory usage, failed services, backup timer status and latest backup archive.

---

## Key scripts

### LinuxOps backup script

Server path:

```text
/usr/local/bin/linuxops-backup.sh
```

Purpose:

Creates timestamped compressed backups of important Linux directories and writes backup activity to a log file.

Backup targets:

```text
/etc
/home
```

Backup directory:

```text
/backups
```

Backup log:

```text
/var/log/linuxops-backup.log
```

---

### LinuxOps health-check script

Server path:

```text
/usr/local/bin/linuxops-health-check.sh
```

Project path:

```text
scripts/linuxops-health-check.sh
```

Purpose:

Displays a basic operational health report for the Linux server.

The script reports:

* Hostname
* Date and time
* Uptime
* Logged-in users
* Disk usage
* Memory usage
* Failed systemd services
* Backup timer status
* Latest backup archive

---

## Systemd services and timers

| Unit                       | Purpose                                                 |
| -------------------------- | ------------------------------------------------------- |
| linuxops-heartbeat.service | Runs a custom heartbeat script and writes to a log file |
| linuxops-backup.service    | Runs the LinuxOps backup script                         |
| linuxops-backup.timer      | Schedules the backup service to run daily               |

The backup timer is configured to run every day at 02:00 and uses `Persistent=true`, which allows missed runs to execute after boot if the server was powered off at the scheduled time.

---

## Documentation

| File                             | Purpose                                                                                   |
| -------------------------------- | ----------------------------------------------------------------------------------------- |
| logbook.md                       | Step-by-step lab documentation with commands, explanations, notes and screenshot evidence |
| docs/troubleshooting_cases.md    | Support-style troubleshooting cases for common Linux server issues                        |
| scripts/linuxops-health-check.sh | Bash health-check script stored in the project repository                                 |

---

## Screenshot evidence

The project includes screenshot evidence for each major task.

Examples include:

* Initial repository setup
* RHEL server verification
* SSH service and login testing
* Linux users and groups
* Sudo access testing
* Firewall status
* Listening service review
* Custom systemd service creation
* Backup script creation and testing
* Systemd backup timer configuration
* Log review
* Troubleshooting document
* Health-check script output

Screenshots are stored in:

```text
screenshots/
```

---

## Example commands used

```bash
hostnamectl
ip addr
df -h
free -h
systemctl status sshd
sudo firewall-cmd --list-all
sudo ss -tulpn
id opsadmin
sudo systemctl status linuxops-backup.timer --no-pager
journalctl -u sshd --no-pager
systemctl --failed
sudo /usr/local/bin/linuxops-health-check.sh
```

---

## What this project shows

This project shows that the server was not only installed, but also operated and documented like a real Linux administration environment.

It demonstrates the ability to:

* Build a Linux server lab from scratch
* Configure remote administration
* Manage users and permissions
* Review basic security exposure
* Create and manage systemd services
* Automate backups
* Schedule recurring jobs
* Investigate logs
* Document troubleshooting cases
* Create reusable admin scripts
* Maintain project history with Git

---

## Notes

This is a lab environment and not a production system.

The project is designed for learning, documentation and portfolio demonstration. Commands and configurations are intentionally simple and clearly documented so the workflow can be reviewed and repeated.
