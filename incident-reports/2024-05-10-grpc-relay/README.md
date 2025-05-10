# gRPC Relay Service Investigation (2024-05-10)

## Overview
Investigation into gRPC relay service failures between the wallet application and blockchain node. This incident report documents our findings, test procedures, and recommendations for establishing proper gRPC connectivity.

## Repository Structure

```
.
├── INCIDENT.md           # Full incident report and findings with test procedures
└── test-plan.md         # Acceptance criteria and test plan
```

## Related Code
- [relay.go](../../pylons-grpc-relay/relay.go) - gRPC relay service implementation
- [grpc_test.dart](../../wallet/test/grpc_test.dart) - Dart client tests

## Testing

All test procedures and commands are documented in [INCIDENT.md](./INCIDENT.md). The test plan and acceptance criteria can be found in [test-plan.md](./test-plan.md). 