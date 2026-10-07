# DynamoDB and RDS — databases

DynamoDB is a managed NoSQL database. Tables contain items, and items contain attributes. A primary key is either a partition key alone or a partition key plus sort key. Design keys around access patterns: the partition key locates an item group and the sort key orders items within that group. Sessions, carts and predictable key-based lookups are common uses. It does not provide SQL joins.

Source: [DynamoDB core components](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/HowItWorks.CoreComponents.html).

RDS manages relational database operations for engines such as PostgreSQL, MySQL, MariaDB, Oracle and SQL Server. Applications use tables, constraints, SQL and transactions. Restrict network access, encrypt storage and connections, manage credentials securely, and configure backups and restore testing. A DB instance supplies database compute and memory; backups and snapshots support recovery.

Multi-AZ provides availability, while read replicas generally provide read scaling. A traditional Multi-AZ DB instance standby does not serve reads; Multi-AZ DB clusters have reader instances, so the deployment type matters. Orders, accounting and relational reporting commonly fit RDS.

| Need | Typical fit |
| --- | --- |
| Predictable key lookups at variable scale | DynamoDB |
| Joins, relational integrity and SQL queries | RDS |
| Database availability | Choose each service's appropriate replication and recovery features |

Sources: [RDS introduction](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/), [Multi-AZ deployments](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html).
