# IAM — governance

IAM controls who can do what to which AWS resources. Users represent identities, groups collect users for permissions, and roles are assumed to obtain temporary credentials. JSON policies specify effects, actions, resources and optional conditions. An explicit deny overrides an allow; lack of an applicable allow means denial.

Least privilege means restricting both actions and resources: a reader of one bucket needs object-read permission on that bucket's objects, not administrator access. Bucket listing and object reading are distinct permissions. Identity policies attach to users, groups or roles; resource policies attach to resources such as S3 buckets.

Use federated login and temporary credentials for people, workload roles for applications, MFA for privileged access, and regular reviews of unused permissions. Protect root credentials and avoid root for daily work. Never commit access keys or Terraform state containing secrets. IAM Access Analyzer helps review policies and external access.

Examples: an EC2 role reading configuration from S3, a CI role deploying only its application, or a read-only auditor.

Sources: [IAM best practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html), [Identity and resource policies](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_identity-vs-resource.html).
