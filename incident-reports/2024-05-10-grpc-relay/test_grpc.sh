#!/bin/bash

# Set target address
TARGET="pylons.api.m.stavr.tech:443"

# Test data
TEST_CREATOR="pylons1a5fqm0y3wvxp4x3keqwkp7q3v6kd0ayx3v4pzr"  # Example address
TEST_OWNER="pylons1a5fqm0y3wvxp4x3keqwkp7q3v6kd0ayx3v4pzr"   # Example address

echo "Testing gRPC endpoints against $TARGET..."

# Test ListCookbooksByCreator
echo -e "\nTesting ListCookbooksByCreator..."
grpcurl -d '{
  "creator": "'$TEST_CREATOR'",
  "pagination": {
    "key": "",
    "offset": "0",
    "limit": "10",
    "count_total": true
  }
}' \
  -insecure \
  -authority "pylons.api.m.stavr.tech" \
  -H "Content-Type: application/grpc" \
  $TARGET \
  pylons.pylons.Query/ListCookbooksByCreator

# Test ListItemByOwner
echo -e "\nTesting ListItemByOwner..."
grpcurl -d '{
  "owner": "'$TEST_OWNER'",
  "pagination": {
    "key": "",
    "offset": "0",
    "limit": "10",
    "count_total": true
  }
}' \
  -insecure \
  -authority "pylons.api.m.stavr.tech" \
  -H "Content-Type: application/grpc" \
  $TARGET \
  pylons.pylons.Query/ListItemByOwner

# Test ListTradesByCreator
echo -e "\nTesting ListTradesByCreator..."
grpcurl -d '{
  "creator": "'$TEST_CREATOR'",
  "pagination": {
    "key": "",
    "offset": "0",
    "limit": "10",
    "count_total": true
  }
}' \
  -insecure \
  -authority "pylons.api.m.stavr.tech" \
  -H "Content-Type: application/grpc" \
  $TARGET \
  pylons.pylons.Query/ListTradesByCreator

echo -e "\n=== Test Run Complete ===" 