#!/bin/sh

kubectl delete configmap genesis
kubectl create configmap genesis --from-file=./production_config/genesis.json


kubectl delete secret node0-all-keys
kubectl delete secret node1-all-keys
kubectl delete secret node2-all-keys

kubectl create secret generic node0-all-keys --from-file=./production_config/node0/pylonsd/config/priv_validator_key.json --from-file=./production_config/node0/pylonsd/config/config.toml --from-file=./production_config/node0/pylonsd/config/node_key.json
kubectl apply -f node0-deployment.yaml
kubectl get pods

kubectl create secret generic node1-all-keys --from-file=./production_config/node1/pylonsd/config/priv_validator_key.json --from-file=./production_config/node1/pylonsd/config/config.toml --from-file=./production_config/node1/pylonsd/config/node_key.json
kubectl apply -f node1-deployment.yaml
kubectl get pods

kubectl create secret generic node2-all-keys --from-file=./production_config/node2/pylonsd/config/priv_validator_key.json --from-file=./production_config/node2/pylonsd/config/config.toml --from-file=./production_config/node2/pylonsd/config/node_key.json
kubectl apply -f node2-deployment.yaml
kubectl get pods
