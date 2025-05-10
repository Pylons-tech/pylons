# Pylons gRPC Service Test Plan

## Acceptance Criteria

### 1. Blockchain Node gRPC Functionality
The blockchain node must:
- [ ] Expose gRPC endpoints on the standard Cosmos SDK port (9090)
- [ ] Successfully respond to basic Tendermint queries
- [ ] Support all Pylons-specific queries (Cookbooks, Items, Trades)
- [ ] Handle pagination correctly
- [ ] Return properly formatted protobuf responses

### 2. gRPC Relay Service
The relay service must:
- [ ] Forward gRPC requests to the blockchain node
- [ ] Maintain proper HTTP/2 protocol
- [ ] Handle TLS/SSL correctly
- [ ] Preserve request/response protobuf format
- [ ] Support all required endpoints

## Test Procedure

### Step 1: Validate Blockchain Node
1. Run blockchain node tests:
```bash
# Make script executable
chmod +x blockchain_grpc_test.sh

# Run tests against local node
./blockchain_grpc_test.sh
```

### Step 2: Validate Relay Service
1. Run relay service tests:
```bash
# Make script executable
chmod +x test_grpc.sh

# Run tests against relay
./test_grpc.sh
```

### Step 3: Validate Dart Client
1. Run Dart gRPC tests:
```bash
# Navigate to wallet directory
cd wallet

# Run gRPC tests
flutter test test/grpc_test.dart
```

## Current Status

### Blockchain Tests
- Status: Not Run
- Expected: All queries should return valid protobuf responses
- Actual: TBD

### Relay Tests
- Status: Failed
- Expected: Forward requests to blockchain and return responses
- Actual: Returns 501 Not Implemented with application/json content type

### Dart Tests
- Status: Failed
- Expected: Successfully connect to relay and receive responses
- Actual: Same 501 error as relay tests

## Investigation Notes

1. The relay service appears to be handling requests as HTTP instead of gRPC:
   - Returns 501 Not Implemented
   - Returns application/json content type
   - Does not properly handle HTTP/2 protocol

2. Working commit (ce37b8715) differences to investigate:
   - Different endpoint configuration?
   - Different protocol handling?
   - Different TLS setup?

## Next Steps

1. [ ] Run blockchain node tests to establish baseline
2. [ ] Compare working commit configuration with current
3. [ ] Verify relay service protocol handling
4. [ ] Update relay service configuration if needed
5. [ ] Re-run all tests to verify fixes 