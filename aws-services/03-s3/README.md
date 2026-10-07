# S3 — storage

S3 stores objects in buckets. Each object has a key, content and metadata; slash-separated keys resemble folders but are not a filesystem hierarchy. General-purpose bucket names must be globally unique within the AWS partition.

Storage classes trade access cost and retrieval behavior against storage cost. Standard suits frequent access; Intelligent-Tiering manages changing access patterns; infrequent-access and Glacier classes suit cooler or archival data. Choose based on retrieval requirements, not storage price alone.

Versioning retains multiple object versions and supports recovery from overwrites. Lifecycle rules can transition or expire objects and old versions. Encryption protects stored data; new uploads receive server-side encryption by default, and KMS options provide additional key control. Encryption does not make a public bucket private: Block Public Access and access policies control authorization.

Uses include backups, logs, build artifacts and static assets. The S3 Terraform lab explicitly blocks public access and refuses automatic deletion of a nonempty bucket.

Source: [Amazon S3 user guide](https://docs.aws.amazon.com/AmazonS3/latest/userguide/Welcome.html).
