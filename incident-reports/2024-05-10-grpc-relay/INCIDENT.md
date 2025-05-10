# Incident Report: gRPC Relay Service Investigation (2024-05-10)

## Summary
Investigation into gRPC relay service failures revealed fundamental connectivity issues between the wallet application and the blockchain node. While REST API endpoints were accessible, all gRPC communication attempts failed with 501 Not Implemented errors.

## Test Files
The investigation used three main test files:
1. `test_grpc.sh` - Tests the relay service against production endpoints
2. `blockchain_grpc_test.sh` - Tests direct blockchain node connectivity
3. `wallet/test/grpc_test.dart` - Dart client integration tests

## Timeline

### Initial Investigation
- Identified issue with gRPC relay service not properly forwarding requests
- Found working commit (ce37b8715) as reference point
- Attempted to replicate working configuration

### Testing Performed

#### 1. REST API Verification
- Successfully connected to REST endpoints
- Confirmed API functionality at `pylons.api.m.stavr.tech`
- REST endpoints returned proper JSON responses

#### 2. gRPC Testing Attempts
We attempted several gRPC calls using different configurations:

a. Direct gRPC call to production endpoint (`test_grpc.sh`):
```bash
# Test ListCookbooksByCreator
grpcurl -d '{
  "creator": "pylons1a5fqm0y3wvxp4x3keqwkp7q3v6kd0ayx3v4pzr",
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
  pylons.api.m.stavr.tech:443 \
  pylons.pylons.Query/ListCookbooksByCreator

# Test ListItemByOwner
grpcurl -d '{
  "owner": "pylons1a5fqm0y3wvxp4x3keqwkp7q3v6kd0ayx3v4pzr",
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
  pylons.api.m.stavr.tech:443 \
  pylons.pylons.Query/ListItemByOwner
```
Result: 501 Not Implemented, application/json content type

b. Local blockchain node test attempt (`blockchain_grpc_test.sh`):
```bash
# Test basic Tendermint endpoint
grpcurl -plaintext \
  localhost:9090 \
  cosmos.base.tendermint.v1beta1.Service/GetNodeInfo

# Test Pylons-specific endpoint
grpcurl -plaintext -d '{
  "creator": "pylo1fhvaknqx2ngyltz2qzychlm75cyp4tkh09d539",
  "pagination": {
    "key": "",
    "offset": "0",
    "limit": "10",
    "count_total": true
  }
}' \
  localhost:9090 \
  pylons.pylons.Query/ListCookbooksByCreator
```
Result: Connection refused - no local node available for testing

#### 3. Dart Client Tests
Located in `wallet/test/grpc_test.dart`, the tests attempt to establish gRPC connections using the Dart client:

```dart
channel = ClientChannel(
  'pylons.api.m.stavr.tech',
  port: 443,
  options: ChannelOptions(
    credentials: ChannelCredentials.secure(),
  ),
);

nodeClient = ServiceClient(channel);
itemsClient = QueryClient(channel);
cookbooksClient = QueryClient(channel);
```

## Key Findings

1. Protocol Mismatch
   - Server returns application/json content type
   - HTTP/2 protocol not properly handled
   - gRPC requests treated as HTTP requests

2. Infrastructure Questions
   - Unclear if gRPC endpoints are exposed
   - TLS/SSL configuration may need verification
   - Proxy/load balancer configuration unknown

3. Test Coverage Gaps
   - No baseline tests against blockchain node
   - No acceptance criteria for gRPC functionality
   - Limited documentation on expected behavior

## Blockers

1. No Access to Working gRPC Endpoint
   - Cannot verify correct behavior
   - No baseline for comparison
   - Unable to validate protocol handling

2. Missing Infrastructure Details
   - Load balancer configuration unknown
   - Proxy settings unclear
   - TLS termination point uncertain

## Recommendations

1. Establish Acceptance Criteria
   - Create baseline tests against blockchain node
   - Document expected gRPC behavior
   - Define success criteria for relay service

2. Infrastructure Verification
   - Confirm gRPC port exposure (default: 9090)
   - Verify TLS configuration
   - Document proxy/load balancer setup

3. Testing Framework
   - Implement comprehensive test suite
   - Include both REST and gRPC tests
   - Add monitoring for protocol-specific issues

## Next Steps

1. [ ] Run baseline tests against blockchain node
2. [ ] Document working gRPC configuration
3. [ ] Create acceptance test suite
4. [ ] Verify infrastructure setup
5. [ ] Update relay service based on findings

## Supporting Files
The test files used in this investigation are maintained in the repository:
- [test_grpc.sh](./test_grpc.sh) - Production relay service test script
- [blockchain_grpc_test.sh](./blockchain_grpc_test.sh) - Local blockchain node test script
- [grpc_test.dart](../../wallet/test/grpc_test.dart) - Dart client integration tests

These files can be used to reproduce the test cases and verify fixes.

## Conclusion
The investigation revealed that proper gRPC functionality cannot be verified or fixed without first establishing baseline blockchain node connectivity and acceptance criteria. A comprehensive test suite must be developed before further relay service modifications can be effectively implemented. 