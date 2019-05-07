#!/bin/bash

kubectl create -f Kubernetes/env-variables.yaml
kubectl create -f Kubernetes/volumes.yaml
kubectl create -f Kubernetes/pg-service.yaml
kubectl create -f Kubernetes/cli-home.yaml
