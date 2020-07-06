#!/bin/sh

docker build -t pylons_node . --target test_server

kubectl delete service/node0
kubectl delete statefulset.apps/node0
kubectl delete pod/node0-0
kubectl apply -f node0-deployment.yaml

kubectl delete service/node1
kubectl delete statefulset.apps/node1
kubectl delete pod/node1-0
kubectl apply -f node1-deployment.yaml

kubectl delete service/node2
kubectl delete statefulset.apps/node2
kubectl delete pod/node2-0
kubectl apply -f node2-deployment.yaml

kubectl get all
kubectl logs pod/node0-0
