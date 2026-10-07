#!/usr/bin/env bash
set -euxo pipefail
kubectl config use-context devops-homework
scratch=$(mktemp -d)
helm create "$scratch/scaffold"
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm search repo bitnami/nginx --versions | head -6 || true
helm lint helm/notes-chart
helm install notes helm/notes-chart --namespace hw-helm --create-namespace --wait
helm list -n hw-helm
helm status notes -n hw-helm
helm get values notes -n hw-helm
helm get manifest notes -n hw-helm
kubectl -n hw-helm exec deployment/notes -- wget -qO- http://localhost
helm upgrade notes helm/notes-chart -n hw-helm --set 'message=Notes application version 2' --wait
kubectl -n hw-helm exec deployment/notes -- wget -qO- http://localhost
helm upgrade notes helm/notes-chart -n hw-helm --set 'message=Notes application version 3' --wait
kubectl -n hw-helm exec deployment/notes -- wget -qO- http://localhost
helm history notes -n hw-helm
helm rollback notes 1 -n hw-helm --wait
kubectl -n hw-helm exec deployment/notes -- wget -qO- http://localhost
helm history notes -n hw-helm
helm install disposable helm/notes-chart --namespace hw-helm --wait
helm uninstall disposable -n hw-helm
helm list -n hw-helm
