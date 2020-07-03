#!/bin/sh

kubectl create configmap genesis --from-file=./production_config/genesis.json

kubectl delete secret node0-val-key
kubectl delete secret node0-config
kubectl delete secret node0-key

kubectl create secret generic node0-all-keys --from-file=./production_config/node0/pylonsd/config/priv_validator_key.json --from-file=./production_config/node0/pylonsd/config/config.toml --from-file=./production_config/node0/pylonsd/config/node_key.json
kubectl create secret generic node0-val-key --from-file=./production_config/node0/pylonsd/config/priv_validator_key.json 
kubectl create secret generic node0-config --from-file=./production_config/node0/pylonsd/config/config.toml
kubectl create secret generic node0-key --from-file=./production_config/node0/pylonsd/config/node_key.json
kubectl apply -f node0-deployment.yaml
kubectl get pods

kubectl create secret generic node1-all-keys --from-file=./production_config/node1/pylonsd/config/priv_validator_key.json --from-file=./production_config/node1/pylonsd/config/config.toml --from-file=./production_config/node1/pylonsd/config/node_key.jso
kubectl create secret generic node1-val-key --from-file=./production_config/node1/pylonsd/config/priv_validator_key.json 
kubectl create secret generic node1-config --from-file=./production_config/node1/pylonsd/config/config.toml
kubectl create secret generic node1-key --from-file=./production_config/node1/pylonsd/config/node_key.json
kubectl apply -f node1-deployment.yaml
kubectl get pods

kubectl create secret generic node2-all-keys --from-file=./production_config/node2/pylonsd/config/priv_validator_key.json --from-file=./production_config/node2/pylonsd/config/config.toml --from-file=./production_config/node2/pylonsd/config/node_key.jso
kubectl create secret generic node2-val-key --from-file=./production_config/node2/pylonsd/config/priv_validator_key.json 
kubectl create secret generic node2-config --from-file=./production_config/node2/pylonsd/config/config.toml
kubectl create secret generic node2-key --from-file=./production_config/node2/pylonsd/config/node_key.json
kubectl apply -f node2-deployment.yaml
kubectl get pods
