# Fully Qualified Domain Names

An FQDN specifies the complete DNS name, rather than an ambiguous short name. A trailing dot explicitly anchors it at the DNS root.

Kubernetes normally uses `<service>.<namespace>.svc.<cluster-domain>`. Here the cluster domain is `cluster.local`; it can differ in other clusters. Within `hw-services`, the resolver search path expands `clusterip`; from another namespace use `clusterip.hw-services` or the complete name.

Examples:

- `clusterip.hw-services.svc.cluster.local`: normal Service resolves to its ClusterIP.
- `headless.hw-services.svc.cluster.local`: headless Service resolves to backing ready Pod addresses.
- `web-0.headless.hw-services.svc.cluster.local`: stable StatefulSet Pod identity.
- `kubernetes.default.svc.cluster.local`: Kubernetes API Service.

A client resolves the Service name through cluster DNS, then opens a connection to the returned address. Normal Service traffic is forwarded by the Service dataplane to a backend Pod.

```bash
kubectl -n hw-services exec client -- nslookup clusterip.hw-services.svc.cluster.local
kubectl -n hw-services exec client -- nslookup headless.hw-services.svc.cluster.local
kubectl -n hw-services exec client -- nslookup web-0.headless.hw-services.svc.cluster.local
kubectl -n hw-services exec client -- wget -qO- http://clusterip.hw-services.svc.cluster.local
```

Source: [Kubernetes DNS](https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/).
