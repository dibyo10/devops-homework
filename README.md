# DevOps Homework

Submission for the DevOps homework, including the October Kubernetes, Helm, CI/CD, cloud, monitoring and final-project assignments.

## Student details

- Name: Dibyo Chakraborty
- Enrollment number: 24BCS10302

## Submission index

| Topic | Deliverable |
| --- | --- |
| Linux fundamentals | [`linux-fundamentals/README.md`](linux-fundamentals/README.md) |
| Shell scripting | [`shell-scripting/system_info.sh`](shell-scripting/system_info.sh) |
| Networking | [`networking/README.md`](networking/README.md) |
| Git/GitHub | [`git-github/README.md`](git-github/README.md) |
| Docker Hello World apps | [`docker-apps/README.md`](docker-apps/README.md) |
| Multi-stage build | [`multi-stage-build/README.md`](multi-stage-build/README.md) |
| Docker networking and volumes | [`docker-networking/README.md`](docker-networking/README.md) |
| Kubernetes fundamentals | [`kubernetes-fundamentals/README.md`](kubernetes-fundamentals/README.md) |
| Session 10: deployment strategies and Pod lifecycle | [`kubernetes-workloads/README.md`](kubernetes-workloads/README.md) |
| Session 11: Services, FQDN and CoreDNS | [`kubernetes-services/README.md`](kubernetes-services/README.md) |
| Session 12: ConfigMaps, Secrets and Ingress | [`kubernetes-configuration/README.md`](kubernetes-configuration/README.md) |
| Session 13: storage, HPA and probes | [`kubernetes-storage/README.md`](kubernetes-storage/README.md) |
| Session 14: troubleshooting | [`kubernetes-troubleshooting/README.md`](kubernetes-troubleshooting/README.md) |
| Session 15: Helm and rollback | [`helm/README.md`](helm/README.md) |
| Session 16: CI/CD and GitHub Actions | [`cicd-github-actions/README.md`](cicd-github-actions/README.md) |
| Session 17: DevSecOps | [`devsecops/README.md`](devsecops/README.md) |
| Session 18: Terraform S3 and AWS research | [`terraform-s3-demo/README.md`](terraform-s3-demo/README.md), [`aws-services`](aws-services) |
| Session 19: cloud infrastructure | [`cloud-terraform/README.md`](cloud-terraform/README.md) |
| Session 20: monitoring, observability and GitOps | [`monitoring-gitops/README.md`](monitoring-gitops/README.md) |
| Session 21: final project | [`final-devops-project/README.md`](final-devops-project/README.md) |

## Quick validation

```bash
./scripts/validate.sh
```

Every application has its own Dockerfile. Runtime evidence and exact commands are kept with each topic so the work is reproducible.

The supplied friend's `Class_Assignments/` was used to identify exercise scope and presentation style. New manifests, explanations, runtime output, and screenshots belong to this submission. Screenshots are inside each project's `screenshots/` folder. Command screenshots are Playwright renderings of the accompanying recorded transcripts, labelled as such; browser screenshots capture live application pages.

## October execution

Kubernetes exercises ran on the dedicated `devops-homework` Minikube profile. HPA scaled from one to five Pods under load and back to one after load removal. Helm upgrades and rollback, deliberate fault repair, Prometheus alert firing/recovery, and Argo CD drift correction were exercised. The GitHub workflow builds, scans, publishes to GHCR, and deploys the image into a temporary Kubernetes cluster. AWS execution records and cleanup results are linked from each Terraform project.

To revisit the local cluster after it has been stopped: `minikube start -p devops-homework`. Screenshots and transcripts remain available without running the labs.
