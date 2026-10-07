#!/usr/bin/env bash
set -euxo pipefail
kubectl config use-context devops-homework
kubectl apply -f kubernetes-troubleshooting/namespace.yaml
kubectl apply -f kubernetes-troubleshooting/broken/
sleep 30
kubectl -n hw-troubleshooting get pods -o wide
for name in crash image pending configuration volume dns; do
  kubectl -n hw-troubleshooting describe pod "$name"
done
kubectl -n hw-troubleshooting logs crash || true
kubectl -n hw-troubleshooting exec dns -- nslookup -timeout=2 kubernetes.default.svc.cluster.local || true
kubectl -n hw-troubleshooting events
kubectl explain pod.spec.containers
kubectl -n hw-troubleshooting delete -f kubernetes-troubleshooting/broken/ --wait=true
kubectl apply -f kubernetes-troubleshooting/fixed/
kubectl -n hw-troubleshooting wait --for=condition=Ready pods --all --timeout=120s
kubectl -n hw-troubleshooting exec dns -- nslookup kubernetes.default.svc.cluster.local
kubectl -n hw-troubleshooting create deployment web --image=nginx:1.29-alpine --replicas=2
kubectl -n hw-troubleshooting rollout status deployment/web --timeout=120s
kubectl -n hw-troubleshooting expose deployment web --port=80
kubectl -n hw-troubleshooting patch service web -p '{"spec":{"selector":{"app":"wrong"}}}'
kubectl -n hw-troubleshooting get pods --show-labels
kubectl -n hw-troubleshooting get endpointslices -l kubernetes.io/service-name=web
kubectl -n hw-troubleshooting exec dns -- wget -T 3 -qO- http://web || true
kubectl -n hw-troubleshooting patch service web -p '{"spec":{"selector":{"app":"web"}}}'
kubectl -n hw-troubleshooting patch service web -p '{"spec":{"ports":[{"port":80,"targetPort":81}]}}'
kubectl -n hw-troubleshooting get service web -o yaml
kubectl -n hw-troubleshooting exec dns -- wget -T 3 -qO- http://web || true
kubectl -n hw-troubleshooting patch service web -p '{"spec":{"ports":[{"port":80,"targetPort":80}]}}'
sleep 3
kubectl -n hw-troubleshooting exec dns -- wget -T 3 -qO- http://web
kubectl -n hw-troubleshooting get pods,svc -o wide
kubectl -n hw-troubleshooting top pods || true
