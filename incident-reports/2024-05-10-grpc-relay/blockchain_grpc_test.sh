#!/bin/bash

# Acceptance Criteria Test Script for Pylons Blockchain gRPC Services
# This script validates core gRPC functionality directly against a blockchain node
# before testing the relay service.

# Configuration
BLOCKCHAIN_NODE="pylons.api.m.stavr.tech:443"  # Default Cosmos SDK gRPC port
TEST_ADDRESS="pylo1fhvaknqx2ngyltz2qzychlm75cyp4tkh09d539"

echo "=== Pylons Blockchain gRPC Acceptance Tests ==="
echo "Testing against node: $BLOCKCHAIN_NODE"
echo

# 1. Test Node Info (Basic Cosmos SDK endpoint)
echo "1. Testing Tendermint Node Info..."
grpcurl -plaintext \
  $BLOCKCHAIN_NODE \
  cosmos.base.tendermint.v1beta1.Service/GetNodeInfo

# 2. Test Cookbook Query
echo -e "\n2. Testing Cookbook Query..."
grpcurl -plaintext -d '{
  "creator": "'$TEST_ADDRESS'",
  "pagination": {
    "key": "",
    "offset": "0",
    "limit": "10",
    "count_total": true
  }
}' \
  $BLOCKCHAIN_NODE \
  pylons.pylons.Query/ListCookbooksByCreator

# 3. Test Item Query
echo -e "\n3. Testing Item Query..."
grpcurl -plaintext -d '{
  "owner": "'$TEST_ADDRESS'",
  "pagination": {
    "key": "",
    "offset": "0",
    "limit": "10",
    "count_total": true
  }
}' \
  $BLOCKCHAIN_NODE \
  pylons.pylons.Query/ListItemByOwner

# 4. Test Trade Query
echo -e "\n4. Testing Trade Query..."
grpcurl -plaintext -d '{
  "creator": "'$TEST_ADDRESS'",
  "pagination": {
    "key": "",
    "offset": "0",
    "limit": "10",
    "count_total": true
  }
}' \
  $BLOCKCHAIN_NODE \
  pylons.pylons.Query/ListTradesByCreator

echo -e "\n=== Test Run Complete ===" 