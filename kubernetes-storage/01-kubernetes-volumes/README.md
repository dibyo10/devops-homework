# Kubernetes volumes

Dibyo Chakraborty · 24BCS10302

| Mechanism | Lifetime and purpose | This exercise |
| --- | --- | --- |
| emptyDir | Created with a Pod; survives container restarts, disappears with Pod deletion | /scratch shared scratch space in temporary-volumes |
| hostPath | Mounts a path on a particular node; node-dependent and grants filesystem access | /tmp/devops-homework-volume in the disposable Minikube node |
| PersistentVolume | Cluster-scoped storage supply with capacity, access modes and reclaim policy | homework-static, 100Mi, Retain |
| PersistentVolumeClaim | Namespaced storage request bound to a compatible PV | static-data requests the static PV; web-data requests dynamic storage |
| StorageClass | Defines provisioner and storage parameters | Minikube standard hostpath provisioner |
| Dynamic provisioning | Creates a PV when a matching claim needs storage | web-data binds without manually creating its PV |

Apply namespace.yaml and volumes.yaml from the parent folder. The static PV uses hostPath solely for this one-node lab; use a CSI storage provider for multi-node/cloud storage. ReadWriteOnce means one node, not necessarily one Pod. Recreate avoids simultaneous deployment revisions using the same claim, but can cause downtime.

The mini-project mounts its PVC at /data without replacing Nginx's application files. We wrote persisted-24BCS10302, restarted the Deployment, and read the same content from the replacement Pod. See [actual output](../output.txt).

Source: [Kubernetes volumes](https://kubernetes.io/docs/concepts/storage/volumes/), [persistent volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/).
