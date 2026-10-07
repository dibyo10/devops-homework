#!/usr/bin/env bash
set -euxo pipefail
helm template notes-prod helm/notes-chart -f helm/notes-chart/values-prod.yaml
helm upgrade notes helm/notes-chart -n hw-helm -f helm/notes-chart/values-prod.yaml --wait
kubectl -n hw-helm get deployment notes
kubectl -n hw-helm exec deployment/notes -- wget -qO- http://localhost
revision=$(helm status notes -n hw-helm -o json | python3 -c 'import json,sys; print(json.load(sys.stdin)["version"])')
if helm upgrade notes helm/notes-chart -n hw-helm -f helm/notes-chart/values-prod.yaml --set image=nginx:broken-tag-does-not-exist --wait --timeout 20s; then
  echo 'Unexpected success for deliberately invalid image' >&2
  exit 1
fi
helm status notes -n hw-helm
kubectl -n hw-helm get pods
helm rollback notes "$revision" -n hw-helm --wait
helm history notes -n hw-helm
kubectl -n hw-helm exec deployment/notes -- wget -qO- http://localhost
test "$(kubectl -n hw-helm get deployment notes -o jsonpath='{.status.readyReplicas}')" = 2
