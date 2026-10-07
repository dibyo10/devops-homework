# Kubernetes manifests

`application.yaml` is rendered from the Helm chart for the `final-devops` release. Regenerate after editing the chart:

```bash
helm template final-devops ../helm --namespace final-devops > application.yaml
kubectl create namespace final-devops --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n final-devops -f application.yaml
kubectl rollout status -n final-devops deployment/final-devops
```

Load `devops-final:local` into the cluster first, or render with `--set image.repository=ghcr.io/dibyo10/devops-homework --set image.tag=<commit-sha>` after pulling the published image. Ingress requires an ingress-nginx controller; HPA requires metrics-server. The application is stateless, so no persistent volume is needed. The storage assignment demonstrates PVCs separately.
