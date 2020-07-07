# Aiflow on Kubernetes

This is a project to a airflow app on Kubernetes. More information [here](https://airflow.apache.org/kubernetes.html).

## run app locally

Install local Kubernetes cluster first. Use [minikube](https://kubernetes.io/docs/tasks/tools/install-minikube/).

Install `task` build tools [task](https://taskfile.dev/#/installation).

Run locally:
```shell script
task run.local
```
Undeploy locally:
```shell script
task airflow.undeploy
```

## deploy on EKS Kubernetes cluster
First you need to deploy manually the service account and rolebindings:
```shell script
#First login into your k8s namespace
kubectl -n $NAMESPACE apply -f k8s/rolebinding.yaml
```