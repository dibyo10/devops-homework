#!/usr/bin/env bash
set -euo pipefail
kubectl() { command kubectl --context devops-homework "$@"; }
cd "$(dirname "$0")"
kubectl apply -f lab.yaml
kubectl apply -f secret.example.yaml
kubectl -n hw-configuration rollout status deployment/frontend --timeout=180s
kubectl -n hw-configuration rollout status deployment/backend --timeout=180s
kubectl -n hw-configuration exec deployment/frontend -- sh -c 'printf "%s %s %s\n" "$APP_ENV" "$STUDENT" "$ENROLLMENT"; test "$DB_PASSWORD" = demo-only-not-a-real-password; echo "Demo secret matches"'
for version in broken fixed; do
  kubectl apply -f "troubleshooting/$version-secret.yaml"
  kubectl -n hw-configuration delete pod secret-check --ignore-not-found
  kubectl apply -f troubleshooting/check-pod.yaml
  kubectl -n hw-configuration wait --for=jsonpath='{.status.phase}'=Succeeded pod/secret-check --timeout=120s
  kubectl -n hw-configuration logs secret-check
done
kubectl -n hw-configuration get configmap,secret,deploy,svc,ingress
