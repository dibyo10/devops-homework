import json
import os
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

STARTED = time.monotonic()


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == "/metrics":
            body = f"# TYPE app_uptime_seconds gauge\napp_uptime_seconds {time.monotonic() - STARTED:.3f}\n"
            content_type = "text/plain; version=0.0.4"
        elif self.path in ("/", "/health", "/ready"):
            body = json.dumps({"status": "ok", "student": "Dibyo Chakraborty", "enrollment": "24BCS10302", "message": os.getenv("APP_MESSAGE", "DevOps final project")})
            content_type = "application/json"
        else:
            self.send_error(404)
            return
        payload = body.encode()
        self.send_response(200)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(payload)))
        self.end_headers()
        self.wfile.write(payload)


if __name__ == "__main__":
    ThreadingHTTPServer((os.getenv("APP_HOST", "127.0.0.1"), int(os.getenv("PORT", "8080"))), Handler).serve_forever()
