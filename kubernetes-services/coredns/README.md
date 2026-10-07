# CoreDNS

CoreDNS provides cluster DNS discovery, allowing clients to use names as Pods change. Its Kubernetes plugin watches API resources to answer Service queries. Other names are usually forwarded upstream; caching reduces repeated work.

The Pod's `/etc/resolv.conf` names the cluster DNS Service and search domains. Do not assume a fixed DNS IP: inspect the cluster. In common installations, the Service is named `kube-dns`, the Deployment is `coredns`, and the configuration is the `coredns` ConfigMap in `kube-system`.

```bash
kubectl -n kube-system get pods -l k8s-app=kube-dns
kubectl -n kube-system get svc kube-dns
kubectl -n kube-system get endpointslice -l kubernetes.io/service-name=kube-dns
kubectl -n kube-system get configmap coredns -o yaml
kubectl -n kube-system logs -l k8s-app=kube-dns --tail=50
kubectl -n hw-services exec client -- cat /etc/resolv.conf
kubectl -n hw-services exec client -- nslookup kubernetes.default.svc.cluster.local
kubectl -n hw-services exec client -- nslookup example.com
```

The Corefile commonly includes `errors`, `health`, `ready`, `kubernetes`, `forward`, `cache`, `loop` and `reload` plugins. Read the actual ConfigMap rather than overwriting it with a generic example.

If internal names fail, check CoreDNS readiness, DNS Service endpoints, namespace/name spelling, UDP/TCP port 53 reachability, and NetworkPolicies. If only external names fail, inspect upstream forwarding and external DNS reachability. If DNS works but HTTP fails, inspect application readiness, Service selectors and target ports; that is not necessarily a DNS fault.

Reference: [DNS debugging](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/).
