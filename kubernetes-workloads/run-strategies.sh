#!/usr/bin/env bash
set -euo pipefail
kubectl() { command kubectl --context devops-homework "$@"; }
cd "$(dirname "$0")"
kubectl apply -f namespace.yaml
kubectl apply -f strategies.yaml -f replicaset.yaml
for name in rolling recreate bluegreen-blue bluegreen-green canary-stable canary-preview; do
  kubectl -n hw-workloads rollout status deployment/"$name" --timeout=180s
done
kubectl -n hw-workloads get pods,rs,deploy,svc -o wide
kubectl -n hw-workloads patch deployment rolling --type=json -p='[{"op":"replace","path":"/spec/template/spec/containers/0/command/2","value":"echo rolling-v2 > /usr/share/nginx/html/index.html; exec nginx -g '\''daemon off;'\''"}]'
kubectl -n hw-workloads rollout status deployment/rolling --timeout=180s
kubectl -n hw-workloads get rs -l app=rolling
kubectl -n hw-workloads patch service bluegreen -p '{"spec":{"selector":{"app":"bluegreen-green"}}}'
kubectl -n hw-workloads get endpointslice -l kubernetes.io/service-name=bluegreen
kubectl -n hw-workloads run strategy-client --image=busybox:1.36 --restart=Never --command -- sh -c 'for service in rolling bluegreen recreate; do wget -qO- http://$service; done; for i in $(seq 1 40); do wget -qO- http://canary; done'
kubectl -n hw-workloads wait --for=jsonpath='{.status.phase}'=Succeeded pod/strategy-client --timeout=120s
kubectl -n hw-workloads logs strategy-client
kubectl -n hw-workloads patch deployment recreate --type=json -p='[{"op":"replace","path":"/spec/template/spec/containers/0/command/2","value":"echo recreate-v2 > /usr/share/nginx/html/index.html; exec nginx -g '\''daemon off;'\''"}]'
kubectl -n hw-workloads rollout status deployment/recreate --timeout=180s
kubectl -n hw-workloads get events --sort-by=.metadata.creationTimestamp
kubectl -n hw-workloads delete pod strategy-client
