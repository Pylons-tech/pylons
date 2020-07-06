#!/bin/sh

docker build -t pylons_node . --target test_server
kubectl delete statefulset.apps/node0
kubectl delete pod/node0-0
kubectl apply -f node0-deployment.yaml
kubectl get all
kubectl logs pod/node0-0
