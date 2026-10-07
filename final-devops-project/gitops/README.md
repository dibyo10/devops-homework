# Argo CD deployment

`application.yaml` tracks this repository's `main` branch and renders `final-devops-project/helm` into the `final-devops` namespace. Automated pruning and self-healing reconcile resources with Git. The image override is intentionally the locally preloaded `devops-final:local` image; remote clusters must use a published immutable image tag.

The actual Argo CD synchronization, ConfigMap drift repair and monitoring alert/recovery exercise are recorded in [monitoring-gitops](../../monitoring-gitops/). The transcript identifies the synchronized Git commit so the result can be distinguished from a merely applied Application manifest.
