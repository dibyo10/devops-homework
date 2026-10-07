import json
import subprocess
import time
import urllib.parse
import urllib.request


def kubectl(*args):
    result = subprocess.check_output(["kubectl", "--context", "devops-homework", *args], text=True)
    display = json.dumps(json.loads(result).get("status", {})) if "application" in args and "json" in args else result
    print("$ kubectl", *args, "\n", display, flush=True)
    return result


def query(expression):
    url = "http://127.0.0.1:19090/api/v1/query?" + urllib.parse.urlencode({"query": expression})
    with urllib.request.urlopen(url, timeout=10) as response:
        result = json.load(response)
    assert result["status"] == "success", result
    print(expression, json.dumps(result["data"]["result"]), flush=True)
    return result["data"]["result"]


def wait_for(check, timeout=180):
    deadline = time.monotonic() + timeout
    while time.monotonic() < deadline:
        if check():
            return
        time.sleep(5)
    raise AssertionError("Timed out waiting for expected runtime state")


def healthy():
    app = json.loads(kubectl("-n", "argocd", "get", "application", "final-devops", "-o", "json"))
    status = app.get("status", {})
    return status.get("sync", {}).get("status") == "Synced" and status.get("health", {}).get("status") == "Healthy"


wait_for(healthy)
for metric in ["up", "app_uptime_seconds", "process_cpu_seconds_total", "process_peak_resident_memory_bytes"]:
    wait_for(lambda: bool(query(metric + '{job="final-devops"}')))

original = kubectl("-n", "final-devops", "get", "configmap", "final-devops", "-o", "jsonpath={.data.APP_MESSAGE}")
kubectl("-n", "final-devops", "patch", "configmap", "final-devops", "--type=merge", "-p", json.dumps({"data": {"APP_MESSAGE": "deliberate drift"}}))
wait_for(lambda: kubectl("-n", "final-devops", "get", "configmap", "final-devops", "-o", "jsonpath={.data.APP_MESSAGE}") == original)
print("PASS: Argo CD restored ConfigMap from Git", flush=True)

kubectl("-n", "argocd", "patch", "application", "final-devops", "--type=merge", "-p", '{"spec":{"syncPolicy":{"automated":null}}}')
try:
    kubectl("-n", "final-devops", "patch", "service", "final-devops", "--type=merge", "-p", '{"spec":{"selector":{"app":"intentional-outage"}}}')
    wait_for(lambda: bool(query('ALERTS{alertname="FinalApplicationDown",alertstate="firing"}')), timeout=240)
    print("PASS: FinalApplicationDown fired", flush=True)
finally:
    kubectl("-n", "final-devops", "patch", "service", "final-devops", "--type=merge", "-p", '{"spec":{"selector":{"app":"final-devops"}}}')
    kubectl("apply", "-f", "final-devops-project/gitops/application.yaml")

wait_for(lambda: any(float(item["value"][1]) == 1 for item in query('up{job="final-devops"}')))
wait_for(lambda: not query('ALERTS{alertname="FinalApplicationDown",alertstate="firing"}'), timeout=120)
wait_for(healthy)
print("PASS: service recovered, alert cleared, GitOps Synced/Healthy", flush=True)
