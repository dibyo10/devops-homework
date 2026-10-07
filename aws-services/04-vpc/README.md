# VPC — networking

A VPC is a logically isolated network. Its CIDR defines its address range; subnets divide that range and each occupies one Availability Zone. Route tables decide where packets go.

A public subnet has a route to an internet gateway. A private subnet lacks that direct route; a NAT gateway can provide outbound IPv4 access without allowing unsolicited inbound internet connections. Public instances still need suitable addresses and firewall rules.

Security groups are stateful allow-rule firewalls attached to network interfaces. Network ACLs apply at subnet boundaries and are stateless, with allow and deny rules; return traffic must also be allowed. Neither replaces application authentication.

The lab uses 10.0.0.0/16 with subnet 10.0.1.0/24 and a 0.0.0.0/0 internet route. It omits NAT because the single demonstration host is public. A production database would normally occupy private subnets with access limited to application security groups.

Source: [Amazon VPC guide](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html).
