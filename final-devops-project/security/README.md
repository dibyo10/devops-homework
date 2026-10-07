# Security gates

The root workflow runs unit tests, Bandit SAST, pip-audit SCA, Trivy secret scanning, and Trivy image scanning before publication. HIGH/CRITICAL fixable image vulnerabilities fail the pipeline (`ignore-unfixed` excludes vulnerabilities with no published fix); secret findings and SAST findings also fail it. Full scan output is retained as a workflow artifact.

The application deliberately has no third-party Python runtime packages; `pip-audit -r application/requirements.txt` checks that empty dependency set, while Trivy scans the operating-system and interpreter image. This is not a claim that the base image has no vulnerabilities.

The initial image scan found HIGH vulnerabilities in the base image's bundled packaging tools. Because runtime package installation is unnecessary, the Dockerfile removes pip and ensurepip. See the [actual blocked run and remediation](../../devsecops/README.md#observed-gate-failure-and-remediation).

GHCR authentication uses the temporary, scoped `GITHUB_TOKEN`, not a hard-coded credential. Kubernetes runs the container without root, write access to its root filesystem, Linux capabilities, or a mounted service-account token. `DEMO_LABEL` demonstrates Secret wiring with non-sensitive data; real secrets must be provisioned outside Git. Kubernetes Secrets are base64 encoded, not inherently encrypted.
