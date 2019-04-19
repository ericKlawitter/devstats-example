#!/bin/bash

kubectl create -f Kubernetes/namespace_pg.yaml
kubectl config set-context $(kubectl config current-context) --namespace=devstats-postgres
kubectl create -f Kubernetes/nfs_pvc.yaml
kubectl create -f Kubernetes/pg_service.yaml
kubectl create -f Kubernetes/cli-statefulset.yaml
