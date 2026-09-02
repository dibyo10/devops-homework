# System information script

The script uses variables, `read -p`, `mkdir`, `touch`, `echo`, `df`, `ps`, and `>` redirection as required.

## Run

```bash
chmod +x system_info.sh
./system_info.sh
```

Example interaction (the process and disk tables are shortened here; the script prints them in full):

```text
Current date: Tue Sep  2 09:05:00 IST 2026
Hostname: workstation
Username: dibyochakraborty

Disk usage:
Filesystem      Size  Used Avail Capacity Mounted on
...

Running processes:
USER  PID  %CPU %MEM ... COMMAND
...
Enter a directory for the process report: system-info-output
Running process information saved to system-info-output/running_processes.txt
```

Verify the redirected output:

```bash
test -s system-info-output/running_processes.txt
head system-info-output/running_processes.txt
```

