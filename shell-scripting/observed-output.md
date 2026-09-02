# Observed script output

The complete script was run in a disposable Ubuntu 24.04 container on 2 September 2026. The process list is naturally short because the test environment contains only the script and its shell.

```text
Current date: Wed Sep  2 03:39:07 UTC 2026
Hostname: 092d690b690d
Username: root

Disk usage:
Filesystem            Size  Used Avail Use% Mounted on
overlay               453G   82G  348G  20% /
tmpfs                  64M     0   64M   0% /dev
shm                    64M     0   64M   0% /dev/shm
/run/host_mark/Users  461G  459G  2.0G 100% /work
/dev/vda1             453G   82G  348G  20% /etc/hosts
tmpfs                 3.9G     0  3.9G   0% /proc/scsi
tmpfs                 3.9G     0  3.9G   0% /sys/firmware

Running processes:
USER  PID %CPU %MEM VSZ  RSS  TTY STAT START TIME COMMAND
root    1  0.0  0.0 4032 2836 ?   Ss   03:38 0:00 bash -c [test command]
root  203  0.0  0.0 4032 3024 ?   S    03:39 0:00 bash /work/system_info.sh
root  208  0.0  0.0 7628 3468 ?   R    03:39 0:00 ps aux
Running process information saved to /tmp/system-info-output/running_processes.txt

Redirected file check:
USER  PID %CPU %MEM VSZ  RSS  TTY STAT START TIME COMMAND
root    1  0.0  0.0 4032 2836 ?   Ss   03:38 0:00 bash -c [test command]
root  203  0.0  0.0 4032 3024 ?   S    03:39 0:00 bash /work/system_info.sh
root  211  0.0  0.0 7628 3468 ?   R    03:39 0:00 ps aux
```

The final `test -s` passed, proving that `ps aux > running_processes.txt` produced a non-empty file.

