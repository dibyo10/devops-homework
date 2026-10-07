"""Render a saved command transcript as a clearly labelled Playwright screenshot."""
import html
import sys
from pathlib import Path
from playwright.sync_api import sync_playwright

source = Path(sys.argv[1])
destination = Path(sys.argv[2])
destination.parent.mkdir(parents=True, exist_ok=True)
with sync_playwright() as playwright:
    browser = playwright.chromium.launch()
    page = browser.new_page(viewport={"width": 1440, "height": 900})
    page.set_content('<style>body{background:#101827;color:#e2e8f0;padding:28px;font:16px monospace}pre{white-space:pre-wrap;overflow-wrap:anywhere}h1{font:24px sans-serif}</style><h1>Captured command output — ' + html.escape(source.name) + '</h1><pre>' + html.escape(source.read_text()) + '</pre>')
    page.screenshot(path=str(destination), full_page=True)
    browser.close()
