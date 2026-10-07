# Kubernetes fundamentals

Dibyo Chakraborty · 24BCS10302

## Install and configure

```bash
brew install minikube kubectl helm
minikube start -p devops-homework --driver=docker --cpus=4 --memory=5120 --kubernetes-version=v1.35.1
kubectl config use-context devops-homework
minikube -p devops-homework status
kubectl cluster-info
kubectl get nodes -o wide
kubectl get pods -n kube-system
```

This dedicated local profile keeps the homework separate from other clusters.

## Architecture

The API server accepts authenticated requests and validates objects. etcd stores cluster state. The scheduler assigns unscheduled Pods to nodes. Controllers reconcile desired state, for example replacing a missing replica. A node's kubelet starts containers through its runtime and reports health. The network plugin connects Pods; kube-proxy implements Service routing; CoreDNS supplies cluster DNS. Minikube runs these components on one local node for this exercise; production clusters commonly separate control-plane and worker nodes.

## Kubernetes Basics tutorial

```bash
kubectl create namespace hw-basics
kubectl -n hw-basics create deployment hello --image=nginx:1.29-alpine
kubectl -n hw-basics rollout status deployment/hello
kubectl -n hw-basics expose deployment hello --port=80
kubectl -n hw-basics get deployments,pods,services -o wide
kubectl -n hw-basics describe deployment hello
kubectl -n hw-basics logs deployment/hello
kubectl -n hw-basics exec deployment/hello -- wget -qO- http://localhost
kubectl -n hw-basics scale deployment hello --replicas=2
kubectl -n hw-basics set image deployment/hello nginx=nginx:1.28-alpine
kubectl -n hw-basics rollout status deployment/hello
kubectl -n hw-basics rollout undo deployment/hello
kubectl -n hw-basics rollout status deployment/hello
```

A Pod is a scheduling unit containing containers. A Deployment controls ReplicaSets, which maintain replica counts. A Service gives changing Pod addresses a stable name and virtual address. Namespaces scope names and access. Labels connect selectors to resources. ConfigMaps and Secrets inject configuration; PVCs request durable storage.

The sequence covers the tutorial's create, deploy, explore, expose, scale, and update modules. Inspect the original run in [output.txt](output.txt) and the fresh cluster check in [screenshot](screenshots/cluster.png), captured directly from macOS Terminal.

Sources: [Minikube installation](https://minikube.sigs.k8s.io/docs/start/), [Kubernetes Basics](https://kubernetes.io/docs/tutorials/kubernetes-basics/), [architecture](https://kubernetes.io/docs/concepts/architecture/).
