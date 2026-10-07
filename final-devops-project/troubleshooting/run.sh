#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
kubectl() { command kubectl --context devops-homework -n hw-final-troubleshooting "$@"; }
helm --kube-context devops-homework upgrade --install challenge ../helm --namespace hw-final-troubleshooting --create-namespace --force-conflicts --set image.tag=intentionally-missing --set image.pullPolicy=Never --set ingress.enabled=false --set hpa.enabled=false --set replicaCount=1
kubectl delete pod challenge-client --ignore-not-found
kubectl patch service challenge --type=merge -p '{"spec":{"selector":{"app":"wrong-app"},"ports":[{"name":"http","port":8080,"targetPort":9999}]}}'
sleep 5
{
  kubectl get deploy,pods,svc,endpointslice -o wide
  kubectl describe pods -l app=challenge
  kubectl logs deployment/challenge --tail=10 || true
  kubectl get service challenge -o yaml
} > before-output.txt 2>&1
kubectl set image deployment/challenge application=devops-final:local
kubectl rollout status deployment/challenge --timeout=120s
kubectl patch service challenge -p '{"spec":{"selector":{"app":"challenge"}}}'
sleep 2
{
  kubectl get pods,endpointslice -o wide
  kubectl run challenge-client --image=busybox:1.36 --restart=Never --command -- sh -c 'wget -T 5 -O- http://challenge:8080; test $? -ne 0'
  kubectl wait --for=jsonpath='{.status.phase}'=Succeeded pod/challenge-client --timeout=60s
  kubectl logs challenge-client
} > wrong-port-output.txt 2>&1
kubectl delete pod challenge-client
{
  helm --kube-context devops-homework upgrade challenge ../helm --namespace hw-final-troubleshooting --force-conflicts --set ingress.enabled=false --set hpa.enabled=false --set replicaCount=1 --wait --timeout=120s
  kubectl get deploy,pods,svc,endpointslice -o wide
  kubectl run challenge-client --image=busybox:1.36 --restart=Never --command -- wget -T 5 -O- http://challenge:8080/health
  kubectl wait --for=jsonpath='{.status.phase}'=Succeeded pod/challenge-client --timeout=60s
  kubectl logs challenge-client
  kubectl logs deployment/challenge --tail=5
  helm --kube-context devops-homework history challenge --namespace hw-final-troubleshooting
} > after-output.txt 2>&1
for stage in before wrong-port after; do
  python3 ../../scripts/capture-output.py "$stage-output.txt" "screenshots/$stage.png"
done
