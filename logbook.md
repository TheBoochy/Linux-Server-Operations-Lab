# Linux Server Operations Lab — Logbook

## 2026-06-23 — Part 1: Repository setup and planning

### Goal

Start the Linux Server Operations Lab by creating the local project structure, initial documentation files and Git repository.

### Work completed

* Created the local project folder.
* Created the main documentation folders:

  * docs
  * screenshots
  * scripts
  * results
  * backups
* Created README.md.
* Created logbook.md.
* Added initial project overview and planned lab parts.
* Prepared the project for the first Git commit.
* Initialized the local Git repository.
* Created the GitHub repository.
* Pushed the first project commit to GitHub.

### Notes

This lab will focus on practical Linux server operations and monitoring tasks.

The project is intended for a sysadmin portfolio and will be documented step by step with screenshots, command outputs and Git commits.

Public documentation will use the name Vulkan.

### Evidence

Screenshots:

![screenshot-01-initial-project-structure.png](screenshots/screenshot-01-initial-project-structure.png)

![screenshot-02-first-git-commit-and-push.png](screenshots/screenshot-02-first-git-commit-and-push.png)

---

## 2026-06-23 — Part 2: Linux server VM installation

### Goal

Install and verify the Linux operations server VM for the Linux Server Operations Lab.

### Work completed

* Created a VMware virtual machine named srv-linuxops01.
* Configured the VM with:

  * 2 CPU cores
  * 2048 MB RAM
  * 40 GB virtual disk
  * NAT networking
* Installed Red Hat Enterprise Linux 10.1 using Minimal Install.
* Configured the hostname as srv-linuxops01.
* Created the administrator user vulkan.
* Verified the installed operating system.
* Verified the active network interface and IP address.
* Verified disk usage.
* Verified memory and swap.
* Saved installation verification screenshots.

### Verification results

| Item                 | Result                        |
| -------------------- | ----------------------------- |
| Hostname             | srv-linuxops01                |
| User                 | vulkan                        |
| Operating system     | Red Hat Enterprise Linux 10.1 |
| Network interface    | ens160                        |
| IP address           | 192.168.80.134/24             |
| Root filesystem      | /dev/mapper/rhel-root         |
| Root filesystem size | 37 GB                         |
| Memory               | 1.6 GiB                       |
| Swap                 | 2.0 GiB                       |
| Virtualization       | VMware                        |

### Commands used

```bash
hostnamectl
whoami
cat /etc/os-release
ip addr
df -h
free -h
```

### Command purpose

| Command             | Purpose                                                                       |
| ------------------- | ----------------------------------------------------------------------------- |
| hostnamectl         | Shows the hostname, operating system, kernel and system identity information. |
| whoami              | Shows the currently logged-in user.                                           |
| cat /etc/os-release | Shows the installed Linux distribution and version.                           |
| ip addr             | Shows network interfaces and IP addresses.                                    |
| df -h               | Shows disk usage in human-readable format.                                    |
| free -h             | Shows memory and swap usage in human-readable format.                         |

### Notes

The server was installed using Minimal Install because this is closer to a real Linux server environment. A minimal server uses fewer resources and avoids unnecessary graphical software.

The VM received an IP address through VMware NAT networking. This will be used later when testing SSH administration from the Windows host.

### Evidence

Screenshots:

![screenshot-03a-linux-server-os-user-verification.png](screenshots/screenshot-03a-linux-server-os-user-verification.png)

![screenshot-03b-linux-server-network-disk-memory-verification.png](screenshots/screenshot-03b-linux-server-network-disk-memory-verification.png)

---

## 2026-06-23 — Part 3: Network and SSH administration

### Goal

Configure and verify SSH administration for the Linux operations server.

### Work completed

* Verified the active Linux network interface.
* Confirmed the server IP address.
* Checked the SSH daemon service.
* Verified that sshd is active and running.
* Verified that SSH is listening on port 22.
* Checked that firewalld is running.
* Verified that the firewall allows SSH traffic.
* Tested SSH login from Windows PowerShell.
* Confirmed remote administration access to srv-linuxops01.

### Verification results

| Item                     | Result            |
| ------------------------ | ----------------- |
| SSH service              | active running    |
| SSH daemon               | sshd              |
| SSH port                 | 22                |
| Firewall service         | firewalld         |
| Firewall state           | running           |
| Allowed firewall service | ssh               |
| Network interface        | ens160            |
| Server IP address        | 192.168.80.134/24 |
| Remote login user        | vulkan            |
| Remote login test        | Successful        |

### Commands used

```bash
systemctl status sshd
sudo firewall-cmd --state
sudo firewall-cmd --list-all
ip addr
```

```powershell
ssh vulkan@192.168.80.134
```

```bash
hostname
whoami
```

### Command purpose

| Command                      | Purpose                                                                   |
| ---------------------------- | ------------------------------------------------------------------------- |
| systemctl status sshd        | Checks whether the SSH server service is running.                         |
| sudo firewall-cmd --state    | Checks whether firewalld is running.                                      |
| sudo firewall-cmd --list-all | Shows active firewall zone settings and allowed services.                 |
| ip addr                      | Shows network interfaces and IP addresses.                                |
| ssh vulkan@192.168.80.134    | Starts a secure remote terminal session from Windows to the Linux server. |
| hostname                     | Confirms the connected system hostname.                                   |
| whoami                       | Confirms the logged-in Linux user.                                        |

### Notes

SSH is required for remote Linux administration. In a real server environment, administrators usually manage Linux systems remotely instead of using the local console.

The firewall allows SSH, which means the server can accept remote administration connections while still keeping firewall protection active.

Successful SSH login from Windows PowerShell confirms that the Linux server can be managed remotely.

### Evidence

Screenshots:

![screenshot-04-ssh-service-running.png](screenshots/screenshot-04-ssh-service-running.png)

![screenshot-05-ssh-login-success.png](screenshots/screenshot-05-ssh-login-success.png)
