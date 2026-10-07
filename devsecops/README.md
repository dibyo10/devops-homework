# Session 17: DevSecOps

Student: Dibyo Chakraborty, 24BCS10302.

The executable [pipeline](../.github/workflows/devops.yml) integrates these gates before a commit-tagged image can reach GHCR or Kubernetes:

| Gate | Tool | Stops publication on |
| --- | --- | --- |
| Tests | Python unittest | Failing application behavior |
| SAST | Bandit | Reported Python security issues |
| SCA | pip-audit | Vulnerable runtime dependencies |
| Secrets | Trivy filesystem scanner | Detected committed secrets |
| Image | Trivy | Fixable HIGH/CRITICAL image vulnerabilities |

SAST inspects source without running it; SCA checks dependencies against vulnerability advisories. Secret scanning detects credential patterns; image scanning checks packaged OS and language components. These checks complement one another and do not prove an application is secure.

See [security implementation and limits](../final-devops-project/security/README.md). Reports are uploaded even when a gate fails. GHCR uses GitHub's scoped temporary token; no external registry password is necessary. The pipeline deploys only after gates succeed, then checks the Kubernetes rollout and HTTP health endpoint.
