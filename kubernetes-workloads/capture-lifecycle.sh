#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
kubectl() { command kubectl --context devops-homework "$@"; }
mkdir -p screenshots
for manifest in pod-lifecycle/*.yaml; do
  name="$(basename "$manifest" .yaml)"
  {
    printf '$ kubectl get -f %s\n' "$manifest"
    kubectl get -f "$manifest" -o wide
    printf '$ kubectl describe -f %s\n' "$manifest"
    kubectl describe -f "$manifest"
  } > "pod-lifecycle/$name-output.txt"
  printf -v capture_command 'kubectl --context devops-homework get -f %q -o wide; kubectl --context devops-homework describe -f %q | tail -28' "$PWD/$manifest" "$PWD/$manifest"
  python3 ../scripts/capture-terminal.py "screenshots/$name.png" "$capture_command"
done
