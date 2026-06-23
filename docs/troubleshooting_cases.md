# Linux Troubleshooting Cases

## Overview

This document contains basic Linux troubleshooting cases for the Linux Server Operations Lab.

The purpose is to document how common Linux server problems can be investigated using system logs, service status checks, firewall checks, user permission checks and resource monitoring commands.

These cases are written as support-style examples for a junior sysadmin or IT support portfolio. Each case includes a short scenario, common symptoms, useful investigation commands, command purpose and possible fixes.

The goal is not only to fix the problem, but also to understand which Linux component is involved and why the command is useful.

---

## Case 1 — SSH service is not running

### Scenario

A user cannot connect to the Linux server through SSH.

SSH, or Secure Shell, is the main method used to remotely administer Linux servers from another machine. If SSH is not running, administrators may lose remote terminal access and may need local console access to repair the issue.

### Possible symptoms

* SSH connection fails.
* Remote administration from Windows PowerShell does not work.
* The server does not respond on port 22.

### Investigation commands

```bash
systemctl status sshd
sudo ss -tulpn
journalctl -u sshd --no-pager | tail -n 20
```

### Command purpose

| Command                                    | Purpose                              |
| ------------------------------------------ | ------------------------------------ |
| systemctl status sshd                      | Checks if the SSH daemon is running. |
| sudo ss -tulpn                             | Checks if port 22 is listening.      |
| journalctl -u sshd --no-pager | tail -n 20 | Shows recent SSH service logs.       |

### Possible fix

```bash
sudo systemctl enable --now sshd
```

### Fix explanation

This command starts the SSH daemon immediately and enables it to start automatically after reboot.

The `sshd` service is the server-side SSH daemon. Enabling it makes the change persistent, while `--now` starts it right away without waiting for a reboot.

---

## Case 2 — Firewall blocks SSH

### Scenario

The SSH service is running, but remote login still fails.

A Linux firewall controls which network traffic is allowed to reach the server. On RHEL-based systems, `firewalld` is commonly used to manage firewall rules and allowed services.

### Possible symptoms

* SSH service is active.
* Port 22 may be listening.
* Remote connection from another machine fails.

### Investigation commands

```bash
sudo firewall-cmd --state
sudo firewall-cmd --list-all
```

### Command purpose

| Command                      | Purpose                                             |
| ---------------------------- | --------------------------------------------------- |
| sudo firewall-cmd --state    | Checks if firewalld is running.                     |
| sudo firewall-cmd --list-all | Shows allowed services in the active firewall zone. |

### Possible fix

```bash
sudo firewall-cmd --permanent --add-service=ssh
sudo firewall-cmd --reload
```

### Fix explanation

The first command permanently allows SSH through the firewall. The second command reloads firewalld so the rule becomes active.

This is important because a service can be running correctly but still be unreachable if the firewall blocks incoming traffic. The firewall rule and the listening service both need to be correct.

---

## Case 3 — Backup job failed

### Scenario

The scheduled backup did not create a new backup archive.

Backups are used to protect important files from mistakes, corruption or system failure. In this lab, the backup job creates compressed `.tar.gz` archives from `/etc` and `/home`.

### Possible symptoms

* No new .tar.gz file appears in /backups.
* Backup log shows a failure.
* The systemd backup service reports an error.

### Investigation commands

```bash
sudo systemctl status linuxops-backup.service --no-pager
journalctl -u linuxops-backup.service --no-pager
sudo tail -n 20 /var/log/linuxops-backup.log
sudo ls -lh /backups
```

### Command purpose

| Command                                                  | Purpose                                                   |
| -------------------------------------------------------- | --------------------------------------------------------- |
| sudo systemctl status linuxops-backup.service --no-pager | Checks whether the backup service completed successfully. |
| journalctl -u linuxops-backup.service --no-pager         | Shows systemd journal logs for the backup service.        |
| sudo tail -n 20 /var/log/linuxops-backup.log             | Shows the latest backup log entries.                      |
| sudo ls -lh /backups                                     | Checks whether backup archives exist.                     |

### Possible fixes

```bash
sudo chmod +x /usr/local/bin/linuxops-backup.sh
sudo mkdir -p /backups
sudo chmod 750 /backups
sudo systemctl start linuxops-backup.service
```

### Fix explanation

These commands make sure the backup script is executable, the backup directory exists, the directory permissions are restricted and the service can be tested manually.

A failed backup can be caused by missing execute permissions, missing folders, bad paths or permission issues. Checking both the systemd service status and the backup log gives a clearer picture than guessing, which humanity sadly keeps trying.

---

## Case 4 — User cannot use sudo

### Scenario

A support or admin user cannot run commands with sudo.

`sudo` allows approved users to run commands with administrator privileges without logging in directly as root. On RHEL-based systems, users normally need to be in the `wheel` group to use sudo.

### Possible symptoms

* The user receives a sudo denial message.
* The user is not in the wheel group.
* Administrative commands fail.

### Investigation commands

```bash
id opsadmin
getent group wheel
```

### Command purpose

| Command            | Purpose                                         |
| ------------------ | ----------------------------------------------- |
| id opsadmin        | Shows the user group membership.                |
| getent group wheel | Shows users who are members of the wheel group. |

### Possible fix

```bash
sudo usermod -aG wheel opsadmin
```

### Fix explanation

On RHEL-based systems, users in the wheel group are normally allowed to use sudo. This command adds opsadmin to the wheel group.

The user may need to log out and back in before the new group membership applies. This is because Linux group membership is loaded when the user session starts.

---

## Case 5 — Disk space is nearly full

### Scenario

The server is running low on disk space.

Disk space problems can cause many other failures. Logs may stop writing, backups may fail and services may behave unpredictably when the filesystem is full.

### Possible symptoms

* Backups fail.
* Logs cannot be written.
* Services behave unexpectedly.
* The root filesystem has high usage.

### Investigation commands

```bash
df -h
sudo du -sh /backups
sudo ls -lh /backups
```

### Command purpose

| Command              | Purpose                                               |
| -------------------- | ----------------------------------------------------- |
| df -h                | Shows filesystem disk usage in human-readable format. |
| sudo du -sh /backups | Shows total size of the backup directory.             |
| sudo ls -lh /backups | Lists backup files and their sizes.                   |

### Possible fixes

```bash
sudo rm /backups/old-backup-file.tar.gz
sudo journalctl --vacuum-time=7d
```

### Fix explanation

The first command removes an old backup file if it is no longer needed.

The second command reduces systemd journal logs by keeping only the last seven days of logs.

Old backups should only be removed after confirming that they are no longer required. Deleting files blindly is not troubleshooting, it is gambling with a keyboard.

---

## Case 6 — Custom heartbeat service failed

### Scenario

The custom LinuxOps heartbeat service does not run correctly.

The heartbeat service is a custom systemd service created in this lab. It runs a small Bash script that writes a timestamped message to `/var/log/linuxops-heartbeat.log`.

### Possible symptoms

* No heartbeat entry appears in /var/log/linuxops-heartbeat.log.
* The service status shows failed.
* The script is missing or not executable.

### Investigation commands

```bash
sudo systemctl status linuxops-heartbeat.service --no-pager
journalctl -u linuxops-heartbeat.service --no-pager
ls -l /usr/local/bin/linuxops-heartbeat.sh
sudo cat /usr/local/bin/linuxops-heartbeat.sh
```

### Command purpose

| Command                                                     | Purpose                                     |
| ----------------------------------------------------------- | ------------------------------------------- |
| sudo systemctl status linuxops-heartbeat.service --no-pager | Checks the heartbeat service status.        |
| journalctl -u linuxops-heartbeat.service --no-pager         | Shows systemd journal logs for the service. |
| ls -l /usr/local/bin/linuxops-heartbeat.sh                  | Checks script permissions and ownership.    |
| sudo cat /usr/local/bin/linuxops-heartbeat.sh               | Displays the script content.                |

### Possible fixes

```bash
sudo chmod +x /usr/local/bin/linuxops-heartbeat.sh
sudo systemctl daemon-reload
sudo systemctl start linuxops-heartbeat.service
```

### Fix explanation

These commands make the script executable, reload systemd configuration and start the heartbeat service again.

This type of troubleshooting is useful for custom scripts and services because the issue is often caused by file permissions, wrong paths or systemd not reloading the latest unit file.

---

## Case 7 — Backup timer is not running

### Scenario

The backup script works manually, but the scheduled backup timer is not active.

A systemd timer is used to run a service automatically on a schedule. In this lab, the timer triggers `linuxops-backup.service`, which then runs the backup script.

### Possible symptoms

* No automatic backup runs.
* The timer does not appear in the timer list.
* The timer status is inactive or disabled.

### Investigation commands

```bash
sudo systemctl status linuxops-backup.timer --no-pager
systemctl list-timers --all | grep linuxops
sudo cat /etc/systemd/system/linuxops-backup.timer
```

### Command purpose

| Command                                                | Purpose                                                  |
| ------------------------------------------------------ | -------------------------------------------------------- |
| sudo systemctl status linuxops-backup.timer --no-pager | Checks whether the backup timer is active.               |
| systemctl list-timers --all | grep linuxops            | Lists systemd timers and filters for the LinuxOps timer. |
| sudo cat /etc/systemd/system/linuxops-backup.timer     | Displays the timer configuration.                        |

### Possible fix

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now linuxops-backup.timer
```

### Fix explanation

The first command reloads systemd configuration. The second command enables the timer at boot and starts it immediately.

If a timer file was recently created or edited, `daemon-reload` is required so systemd recognizes the new configuration. Without it, systemd may continue using old information, because apparently even daemons require paperwork.

---

## Case 8 — Backup archive cannot be listed

### Scenario

A backup archive exists, but listing the newest archive fails when using a wildcard.

Linux shells expand wildcards like `*.tar.gz` before the command runs. This means the normal user shell may fail to expand files inside a restricted directory before `sudo` has a chance to help.

### Possible symptoms

* The backup file exists in /backups.
* A command using /backups/*.tar.gz fails.
* Permission errors appear when using a normal user shell.

### Investigation commands

```bash
sudo ls -lh /backups
ls -ld /backups
```

### Command purpose

| Command              | Purpose                                             |
| -------------------- | --------------------------------------------------- |
| sudo ls -lh /backups | Lists backup files using administrator permissions. |
| ls -ld /backups      | Shows the permissions on the backup directory.      |

### Possible fix

```bash
LATEST_BACKUP=$(sudo find /backups -name "*.tar.gz" -type f -printf "%T@ %p\n" | sort -nr | head -n 1 | cut -d' ' -f2-)
echo "$LATEST_BACKUP"
sudo tar -tzf "$LATEST_BACKUP" | head
```

### Fix explanation

The wildcard can fail because the normal user shell expands it before sudo runs. Using sudo find searches the backup directory with administrator permissions and avoids the wildcard permission problem.

This method also selects the newest backup archive safely and then lists its contents with `tar -tzf` without extracting it.

---

## Summary

These troubleshooting cases demonstrate basic Linux operational support skills:

* Checking service status
* Reviewing system logs
* Checking firewall rules
* Verifying listening ports
* Investigating backup failures
* Checking user permissions
* Reviewing disk usage
* Testing custom systemd services
* Verifying scheduled backup timers
* Handling permission-related command issues

The same troubleshooting pattern can be used in real Linux server administration:

1. Identify the symptom.
2. Check the related service.
3. Review logs.
4. Verify permissions and configuration.
5. Apply a controlled fix.
6. Test again.
7. Document the result.
