# Aiflow on Kubernetes

This is a project to a airflow app on Kubernetes. More information [here](https://airflow.apache.org/kubernetes.html).

The application uses the airflow helm chart [here](https://github.com/helm/charts/tree/master/stable/airflow).

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

Edit `.gitlab-ci.yml` file to adapt it to deploy to your own k8s namespace, please read team plateform documentation for details about gitlab runner and Kubernetes.

Create a branch will automatically deploy it on ew1d2 cluster, data-flux-dev namespace. Merge branch will deploy code on data-flux-stg and then to ew1p3 data-flux namespace.

The airflow web interface can be found on : airflow-web-[NAMSPACE].[CLUSTER-NAME].k8s.mfb.io