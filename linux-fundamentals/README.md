# Linux fundamentals

## 1. Soft links and hard links

A hard link is another directory entry for the same inode and data. Both names are equal; deleting one does not remove the data while another hard link exists. Hard links normally cannot cross filesystems and cannot target directories.

A soft (symbolic) link is a separate file containing a path. It can cross filesystems and point to directories, but becomes broken when its target is removed.

```bash
printf 'DevOps homework\n' > original.txt
ln original.txt hard-link.txt
ln -s original.txt soft-link.txt
ls -li
rm original.txt
cat hard-link.txt
cat soft-link.txt
rm hard-link.txt soft-link.txt
```

Observed output (macOS uses the same Unix link semantics):

```text
55903460 -rw-r--r--@ 2 dibyochakraborty wheel 16 Sep 2 09:00 hard-link.txt
55903460 -rw-r--r--@ 2 dibyochakraborty wheel 16 Sep 2 09:00 original.txt
55903463 lrwxr-xr-x@ 1 dibyochakraborty wheel 12 Sep 2 09:00 soft-link.txt -> original.txt

After deleting original.txt:
hard-link.txt contains: DevOps homework
soft-link.txt: No such file or directory
```

Interview summary: a hard link references an inode; a symbolic link references a pathname.

## 2. `adduser` versus `useradd`

| Command | Behavior |
| --- | --- |
| `useradd` | Low-level binary. Defaults vary by distribution and options must often be supplied explicitly. |
| `adduser` | Debian/Ubuntu's friendly Perl front end. Interactive, creates the home directory, chooses defaults, and prompts for account details. |

On Ubuntu, `adduser` is preferred for interactive administration because its safer defaults reduce omissions. Scripts often use `useradd` with explicit flags for predictable, non-interactive behavior.

Test-user exercise on Ubuntu:

```bash
sudo adduser devopsstudent
id devopsstudent
getent passwd devopsstudent
sudo deluser --remove-home devopsstudent
```

The cleanup command is included so a temporary account is not left on the machine.

## 3. `journalctl`

`journalctl` reads logs collected by `systemd-journald`. Useful forms are:

```bash
sudo journalctl                    # all available journal entries
sudo journalctl -b                 # current boot
sudo journalctl -p err             # error priority and above
sudo journalctl --since today      # time filter
sudo journalctl -u ssh.service     # one service
sudo journalctl -u ssh.service -f  # follow one service live
sudo journalctl -n 50 --no-pager   # most recent 50 entries
```

Example service check:

```bash
sudo systemctl status ssh
sudo journalctl -u ssh.service --since '10 minutes ago' --no-pager
```

`journalctl` is Linux/systemd-specific and is not available on the macOS submission host. The commands above are ready to run on Ubuntu.

## 4. Linux command cheat sheet

| Purpose | Commands |
| --- | --- |
| Location and files | `pwd`, `ls -la`, `cd`, `find`, `locate` |
| Read files | `cat`, `less`, `head`, `tail -f` |
| Create/copy/move/delete | `touch`, `mkdir -p`, `cp`, `mv`, `rm`, `rmdir` |
| Search and transform | `grep`, `awk`, `sed`, `sort`, `uniq`, `cut`, `wc` |
| Permissions | `chmod`, `chown`, `chgrp`, `umask` |
| Users | `whoami`, `id`, `who`, `adduser`, `passwd` |
| Processes | `ps aux`, `top`, `pgrep`, `kill`, `jobs`, `bg`, `fg` |
| Storage | `df -h`, `du -sh`, `lsblk`, `mount` |
| System | `uname -a`, `hostname`, `uptime`, `free -h`, `date` |
| Networking | `ip addr`, `ip route`, `ping`, `ss`, `curl`, `dig` |
| Archives | `tar`, `gzip`, `gunzip`, `zip`, `unzip` |
| Services/logs | `systemctl`, `journalctl` |
| Help | `man`, `command --help`, `apropos` |

Common practice sequence:

```bash
mkdir -p linux-practice/logs
touch linux-practice/app.log
printf 'INFO started\nERROR example\n' > linux-practice/app.log
grep ERROR linux-practice/app.log
chmod 640 linux-practice/app.log
ls -l linux-practice/app.log
du -sh linux-practice
rm -r linux-practice
```

