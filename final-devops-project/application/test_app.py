import json
import threading
import unittest
import urllib.error
import urllib.request
from http.server import ThreadingHTTPServer

from app import Handler


class AppTest(unittest.TestCase):
    def test_routes(self):
        server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
        thread = threading.Thread(target=server.serve_forever, daemon=True)
        thread.start()
        base = f"http://127.0.0.1:{server.server_port}"
        try:
            for path in ("/", "/health", "/ready"):
                with urllib.request.urlopen(base + path, timeout=3) as response:
                    self.assertEqual(json.load(response)["enrollment"], "24BCS10302")
            with urllib.request.urlopen(base + "/metrics", timeout=3) as response:
                metrics = response.read().decode()
                for name in ("app_uptime_seconds", "process_cpu_seconds_total", "process_peak_resident_memory_bytes"):
                    value = next(line.split()[1] for line in metrics.splitlines() if line.startswith(name + " "))
                    self.assertGreaterEqual(float(value), 0)
            with self.assertRaises(urllib.error.HTTPError) as error:
                urllib.request.urlopen(base + "/missing", timeout=3)
            self.assertEqual(error.exception.code, 404)
            error.exception.close()
        finally:
            server.shutdown()
            server.server_close()
            thread.join()


if __name__ == "__main__":
    unittest.main()
