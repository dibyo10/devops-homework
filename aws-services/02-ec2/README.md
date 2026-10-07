# EC2 — compute

EC2 runs virtual machines. An AMI supplies the boot image; an instance type selects CPU, memory and networking capacity. Choose an architecture compatible with the image and workload. Key pairs support SSH authentication, while security groups decide which network connections can reach the instance.

EBS supplies persistent block storage. A volume can outlive an instance depending on deletion settings. An instance has a private address; internet access also needs appropriate routes, security rules and, for direct IPv4 access, a public address. Public exposure does not follow merely from assigning a public IP.

The lifecycle includes pending, running, stopping, stopped, shutting-down and terminated. Stopping differs from terminating: restart can reuse an EBS-backed instance, while termination deletes the instance. Storage and other retained resources may still cost money when compute is stopped.

Typical uses include web servers, CI workers and software needing OS-level control. The cloud lab uses a small instance, an encrypted root disk, IMDSv2 and Docker; it opens web ports but no SSH.

Source: [Amazon EC2 concepts](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html).
