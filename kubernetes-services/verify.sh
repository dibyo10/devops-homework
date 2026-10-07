#!/usr/bin/env bash
set -euo pipefail
kubectl() { command kubectl --context devops-homework "$@"; }
cd "$(dirname "$0")"
kubectl apply -f lab.yaml
kubectl -n hw-services rollout status statefulset/web --timeout=180s
kubectl -n hw-services wait --for=condition=Ready pod/client --timeout=120s
kubectl -n hw-services get svc,endpointslice,pods -o wide
for service in clusterip nodeport loadbalancer headless; do
  port=80
  if [ "$service" = loadbalancer ]; then port=8088; fi
  kubectl -n hw-services exec client -- wget -qO- "http://$service:$port"
  kubectl -n hw-services exec client -- nslookup "$service.hw-services.svc.cluster.local"
done
kubectl -n hw-services exec client -- nslookup externalname.hw-services.svc.cluster.local
kubectl -n hw-services exec client -- wget -qO- http://externalname
kubectl -n hw-services exec client -- nslookup web-0.headless.hw-services.svc.cluster.local
kubectl -n hw-services exec client -- cat /etc/resolv.conf
kubectl -n kube-system get configmap coredns -o yaml
