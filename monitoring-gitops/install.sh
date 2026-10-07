#!/usr/bin/env bash
set -euo pipefail
kubectl config use-context devops-homework
kubectl -n final-devops create configmap prometheus --from-file=final-devops-project/monitoring/prometheus.yaml --from-file=final-devops-project/monitoring/alerts.yaml --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f monitoring-gitops/prometheus.yaml
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply --server-side -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v3.5.4/manifests/install.yaml
kubectl -n argocd rollout status deployment/argocd-repo-server --timeout=300s
kubectl apply -f final-devops-project/gitops/application.yaml
