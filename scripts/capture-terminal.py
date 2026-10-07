"""Run a command in macOS Terminal and capture its actual window, unmodified.

Usage: python3 scripts/capture-terminal.py OUTPUT.png 'COMMAND' [WINDOW_ID]
Requires macOS Automation and Screen Recording permission. Leaves its Terminal
session open for inspection; it never closes existing windows or tabs.
"""
import json
import subprocess
import sys
import time
from pathlib import Path


def apple(script):
    return subprocess.check_output(["osascript", "-e", script], text=True).strip()


def capture(destination, command, window=None):
    if window is None:
        window = apple('tell application "Terminal"\n do script ""\n get id of front window\nend tell')
    window = int(window)
    tab = f"selected tab of window id {window}"
    apple(f'tell application "Terminal"\n activate\n do script "clear" in {tab}\nend tell')
    time.sleep(1)
    apple(f'tell application "Terminal" to do script {json.dumps(command, ensure_ascii=False)} in {tab}')
    time.sleep(2)
    deadline = time.monotonic() + 300
    while apple(f'tell application "Terminal" to get busy of {tab}') == "true":
        if time.monotonic() > deadline:
            raise TimeoutError("Terminal command still running; screenshot not taken")
        time.sleep(1)
    time.sleep(1)
    destination = Path(destination).resolve()
    destination.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run(["/usr/sbin/screencapture", "-x", "-l", str(window), str(destination)], check=True)
    print(destination, flush=True)
    return window


if __name__ == "__main__":
    capture(sys.argv[1], sys.argv[2], sys.argv[3] if len(sys.argv) > 3 else None)
