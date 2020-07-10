#!/bin/sh

export PROD_DIR=./production_config_temp
# export PROD_DIR=./production_config
export NODE0_CONFIG_PATH=$PROD_DIR/node0/pylonsd/config
export NODE1_CONFIG_PATH=$PROD_DIR/node1/pylonsd/config
export NODE2_CONFIG_PATH=$PROD_DIR/node2/pylonsd/config
export NODE0_IP=${1:-10.107.138.2}  
export NODE1_IP=${2:-10.107.138.3}  
export NODE2_IP=${3:-10.107.138.4}  

# remove production directory
echo '-------remove production directory-----'
rm -rf $PROD_DIR

# build configuration into production_config_temp directory
echo '-------building the genesis-----'
STARTINGIP=$NODE0_IP NODEIPS="$NODE1_IP,$NODE2_IP" docker-compose --file docker-compose.genesis.yml up --build --remove-orphans
# docker-compose --file docker-compose.genesis.yml up

# minikube env setup
eval $(minikube docker-env)

# build genesis and config files

# build docker image
echo '-------building the image-----'
docker build -t pylons_node . --target test_server

# generate genesis config map
echo '-------genesis config map-----'
kubectl delete configmap genesis
kubectl create configmap genesis --from-file=$PROD_DIR/genesis.json

# secrets generation
echo '-------node0 secrets-----'
kubectl delete secret node0-all-keys
sed -i '' 's/addr_book_strict = true/addr_book_strict = false/g' $NODE0_CONFIG_PATH/config.toml
# sed -i '' "s/10.107.138.2/$NODE0_IP/g" $NODE0_CONFIG_PATH/config.toml
# sed -i '' "s/10.107.138.3/$NODE1_IP/g" $NODE0_CONFIG_PATH/config.toml
# sed -i '' "s/10.107.138.4/$NODE2_IP/g" $NODE0_CONFIG_PATH/config.toml
kubectl create secret generic node0-all-keys --from-file=$NODE0_CONFIG_PATH/priv_validator_key.json --from-file=$NODE0_CONFIG_PATH/config.toml --from-file=$NODE0_CONFIG_PATH/node_key.json

echo '-------node1 secrets-----'
kubectl delete secret node1-all-keys
sed -i '' 's/addr_book_strict = true/addr_book_strict = false/g' $NODE1_CONFIG_PATH/config.toml
# sed -i '' "s/10.107.138.2/$NODE0_IP/g" $NODE1_CONFIG_PATH/config.toml
# sed -i '' "s/10.107.138.3/$NODE1_IP/g" $NODE1_CONFIG_PATH/config.toml
# sed -i '' "s/10.107.138.4/$NODE2_IP/g" $NODE1_CONFIG_PATH/config.toml
kubectl create secret generic node1-all-keys --from-file=$NODE1_CONFIG_PATH/priv_validator_key.json --from-file=$NODE1_CONFIG_PATH/config.toml --from-file=$NODE1_CONFIG_PATH/node_key.json
echo '-------node2 secrets-----'
kubectl delete secret node2-all-keys
sed -i '' 's/addr_book_strict = true/addr_book_strict = false/g' $NODE2_CONFIG_PATH/config.toml
# sed -i '' "s/10.107.138.2/$NODE0_IP/g" $NODE2_CONFIG_PATH/config.toml
# sed -i '' "s/10.107.138.3/$NODE1_IP/g" $NODE2_CONFIG_PATH/config.toml
# sed -i '' "s/10.107.138.4/$NODE2_IP/g" $NODE2_CONFIG_PATH/config.toml
kubectl create secret generic node2-all-keys --from-file=$NODE2_CONFIG_PATH/priv_validator_key.json --from-file=$NODE2_CONFIG_PATH/config.toml --from-file=$NODE2_CONFIG_PATH/node_key.json

# nodes cleanup
echo '-------node0 cleaning-----'
kubectl delete service/node0
kubectl delete statefulset.apps/node0
kubectl delete pod/node0-0

echo '-------node1 cleaning-----'
kubectl delete service/node1
kubectl delete statefulset.apps/node1
kubectl delete pod/node1-0

echo '-------node2 cleaning-----'
kubectl delete service/node2
kubectl delete statefulset.apps/node2
kubectl delete pod/node2-0

# nodes deployment
echo '-------node deployment-----'
sed -i '' "s/10.107.138.2/$NODE0_IP/g" node-deployment.yaml
sed -i '' "s/10.107.138.3/$NODE1_IP/g" node-deployment.yaml
sed -i '' "s/10.107.138.4/$NODE2_IP/g" node-deployment.yaml
kubectl apply -f node-deployment.yaml
kubectl get all

# echo '-------node0 deployment-----'
# kubectl apply -f node0-deployment.yaml
# kubectl get all

# echo '-------node1 deployment-----'
# kubectl apply -f node1-deployment.yaml
# kubectl get all

# echo '-------node2 deployment-----'
# kubectl apply -f node2-deployment.yaml
# kubectl get all

sleep 5
# node logs
echo '-------node0 logs-----'
kubectl logs pod/node0-0
pylonscli status --node tcp://$(minikube ip):30007
echo '-------node1 logs-----'
kubectl logs pod/node1-0
pylonscli status --node tcp://$(minikube ip):30009
echo '-------node2 logs-----'
kubectl logs pod/node2-0
pylonscli status --node tcp://$(minikube ip):30011


# minikube env setup
eval $(minikube docker-env -u)