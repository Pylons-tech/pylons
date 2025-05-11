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

4. REST-to-gRPC Translation Analysis
   - REST endpoints work because they use grpc-gateway's proper protocol translation
   - Found implementation in generated code (query.pb.gw.go)
   - Generated from protobuf service definitions with HTTP annotations:
     ```proto
     rpc GetTx(GetTxRequest) returns (GetTxResponse) {
       option (google.api.http).get = "/cosmos/tx/v1beta1/txs/{hash}";
     }
     ```
   - The grpc-gateway code:
     a. Automatically handles protocol translation (HTTP ↔ gRPC)
     b. Manages content type negotiation
     c. Preserves streaming capabilities
     d. Maintains proper HTTP/2 framing
   - Key components in generated code:
     a. Request handlers that convert HTTP parameters to protobuf messages
     b. Response handlers that maintain proper content types
     c. Proper stream management with context and metadata
     d. Automatic error code translation
   - Key differences from current relay implementation:
     a. REST server uses proper protobuf serialization instead of raw codec
     b. Maintains correct HTTP/2 framing and protocol handling
     c. Properly converts between HTTP parameters and gRPC messages
     d. Uses correct content types and metadata handling

## Implementation Analysis

### REST Implementation (query.pb.gw.go)
The working REST implementation uses generated code that properly handles protocol translation:

1. Message Type Handling:
```go
// Uses strongly typed protobuf messages
var protoReq QueryListTradesByCreatorRequest
var metadata runtime.ServerMetadata

// Converts HTTP parameters to proper protobuf types
protoReq.Creator, err = runtime.String(val)
```

2. Context and Metadata Management:
```go
// Properly preserves gRPC metadata
msg, err := client.ListTradesByCreator(ctx, &protoReq, 
    grpc.Header(&metadata.HeaderMD), 
    grpc.Trailer(&metadata.TrailerMD))
```

3. Error Handling:
```go
// Uses proper gRPC status codes
return nil, metadata, status.Errorf(codes.InvalidArgument, 
    "missing parameter %s", "creator")
```

### Current Relay Implementation (relay.go)
The failing relay service attempts to forward requests without proper protocol handling:

1. Message Type Handling:
```go
// Uses raw bytes instead of protobuf messages
var msg []byte
err := stream.RecvMsg(&msg)

// Uses custom raw codec
type rawCodec struct{}
func (rawCodec) Marshal(v interface{}) ([]byte, error) {
    return v.([]byte), nil
}
```

2. Context and Metadata:
```go
// Basic metadata forwarding without proper type conversion
if md, ok := metadata.FromIncomingContext(ctx); ok {
    ctx = metadata.NewOutgoingContext(ctx, md)
}
```

3. Stream Handling:
```go
// Generic stream descriptor without proper message types
clientStream, err := conn.NewStream(ctx, &grpc.StreamDesc{
    ServerStreams: true,
    ClientStreams: true,
}, fullMethodName)
```

### Critical Differences

1. Type Safety
   - REST: Uses generated protobuf types specific to each endpoint
   - Relay: Uses raw bytes without type information
   - Impact: Relay cannot properly serialize/deserialize messages

2. Protocol Translation
   - REST: Proper conversion between HTTP and gRPC protocols
   - Relay: Attempts to forward raw bytes without protocol understanding
   - Impact: Relay fails to maintain proper HTTP/2 framing

3. Message Serialization
   - REST: Uses protobuf serialization with proper message types
   - Relay: Uses custom raw codec that just passes bytes through
   - Impact: Messages lose their structure and type information

4. Stream Management
   - REST: Endpoint-specific stream handling with proper types
   - Relay: Generic stream handling without message type awareness
   - Impact: Streaming calls cannot maintain proper protocol state

### Root Cause Analysis

The REST implementation succeeds because:
1. It understands the protocol requirements for each endpoint
2. Uses proper message types and serialization
3. Maintains correct HTTP/2 framing
4. Properly handles metadata and context

The relay fails because:
1. It attempts to forward raw bytes without understanding message types
2. Doesn't properly handle HTTP/2 framing
3. Uses a custom codec that breaks protocol requirements
4. Lacks proper type information for serialization/deserialization

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

4. Relay Service Improvements
   - Remove custom raw codec in favor of proper protobuf serialization:
     ```go
     // Remove:
     grpc.WithDefaultCallOptions(grpc.CallCustomCodec(rawCodec{}))
     // Use standard protobuf codec instead
     ```
   - Implement proper HTTP/2 framing preservation using grpc-gateway patterns:
     ```go
     // Instead of raw bytes:
     var msg []byte
     // Use proper protobuf messages:
     var msg proto.Message
     ```
   - Follow grpc-gateway's protocol handling patterns:
     a. Use generated protobuf types for message handling
     b. Maintain proper content type headers (application/grpc)
     c. Preserve metadata and context through the entire chain
     d. Implement proper stream handling with context
   - Consider using grpc-gateway directly instead of custom relay:
     a. Define services using protobuf with HTTP annotations
     b. Let grpc-gateway handle the protocol translation
     c. Benefit from automatic content type and error handling
     d. Leverage generated code for proper message conversion

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

## Implementation Examples

### REST API Generation
1. Service Definition with HTTP Annotations:
```proto
// Service defines a gRPC service for interacting with transactions
service Service {
  // GetTx fetches a tx by hash
  rpc GetTx(GetTxRequest) returns (GetTxResponse) {
    option (google.api.http).get = "/cosmos/tx/v1beta1/txs/{hash}";
  }
  
  // BroadcastTx broadcast transaction
  rpc BroadcastTx(BroadcastTxRequest) returns (BroadcastTxResponse) {
    option (google.api.http) = {
      post: "/cosmos/tx/v1beta1/txs"
      body: "*"
    };
  }
}
```

2. Generated Gateway Code (query.pb.gw.go):
```go
func request_Service_GetTx_0(ctx context.Context, marshaler runtime.Marshaler, client QueryClient, req *http.Request, pathParams map[string]string) (proto.Message, runtime.ServerMetadata, error) {
    var protoReq GetTxRequest
    var metadata runtime.ServerMetadata

    // Extract parameters from URL
    val, ok := pathParams["hash"]
    if !ok {
        return nil, metadata, status.Errorf(codes.InvalidArgument, "missing parameter %s", "hash")
    }

    // Convert to protobuf message
    protoReq.Hash = val

    // Make gRPC call with proper context and metadata
    msg, err := client.GetTx(ctx, &protoReq, grpc.Header(&metadata.HeaderMD), grpc.Trailer(&metadata.TrailerMD))
    return msg, metadata, err
}
```

3. Gateway Registration:
```go
func RegisterQueryHandlerFromEndpoint(ctx context.Context, mux *runtime.ServeMux, endpoint string, opts []grpc.DialOption) (err error) {
    conn, err := grpc.Dial(endpoint, opts...)
    if err != nil {
        return err
    }
    defer func() {
        if err != nil {
            if cerr := conn.Close(); cerr != nil {
                grpclog.Infof("Failed to close conn to %s: %v", endpoint, cerr)
            }
            return
        }
        go func() {
            <-ctx.Done()
            if cerr := conn.Close(); cerr != nil {
                grpclog.Infof("Failed to close conn to %s: %v", endpoint, cerr)
            }
        }()
    }()

    return RegisterQueryHandler(ctx, mux, conn)
}
```

### Applying to Relay Service

1. Remove Raw Codec:
```go
// Current problematic code:
conn, err := grpc.Dial(targetAddr,
    grpc.WithTransportCredentials(creds),
    grpc.WithDefaultCallOptions(grpc.CallCustomCodec(rawCodec{})),
    grpc.WithAuthority("pylons.api.m.stavr.tech"),
)

// Fixed version:
conn, err := grpc.Dial(targetAddr,
    grpc.WithTransportCredentials(creds),
    grpc.WithAuthority("pylons.api.m.stavr.tech"),
)
```

2. Proper Message Handling:
```go
// Current problematic code:
func proxyHandler(conn *grpc.ClientConn, logger *log.Logger) grpc.StreamHandler {
    return func(srv interface{}, stream grpc.ServerStream) error {
        var msg []byte
        err := stream.RecvMsg(&msg)
        // ...
    }
}

// Fixed version using proper protobuf messages:
func proxyHandler(conn *grpc.ClientConn, logger *log.Logger) grpc.StreamHandler {
    return func(srv interface{}, stream grpc.ServerStream) error {
        // Get method info
        fullMethodName, ok := grpc.MethodFromServerStream(stream)
        if !ok {
            return fmt.Errorf("failed to get method name")
        }

        // Create proper message type based on method
        msg := protoregistry.GlobalTypes.FindMessageByName(
            protoreflect.FullName(fullMethodName),
        )
        
        // Handle stream with proper message type
        err := stream.RecvMsg(msg)
        // ...
    }
}
```

3. Proper Stream Handling:
```go
// Current problematic code:
clientStream, err := conn.NewStream(ctx, &grpc.StreamDesc{
    ServerStreams: true,
    ClientStreams: true,
}, fullMethodName)

// Fixed version with proper context and metadata:
md, ok := metadata.FromIncomingContext(stream.Context())
if ok {
    ctx = metadata.NewOutgoingContext(ctx, md)
}

// Get proper stream descriptor
streamDesc := grpc.StreamDesc{
    StreamName:    path.Base(fullMethodName),
    ServerStreams: true,
    ClientStreams: true,
}

// Create stream with proper context
clientStream, err := conn.NewStream(ctx, &streamDesc, fullMethodName)
if err != nil {
    return status.Errorf(codes.Internal, "failed to create client stream: %v", err)
}

// Handle bidirectional streaming with proper message types
go func() {
    for {
        m := dynamicpb.New(msgDesc)
        if err := clientStream.RecvMsg(m); err != nil {
            // Handle error...
            return
        }
        if err := stream.SendMsg(m); err != nil {
            // Handle error...
            return
        }
    }
}()
```

These examples demonstrate:
1. How the REST API achieves proper protocol translation
2. Specific changes needed in the relay service
3. Proper handling of messages, streams, and metadata

## Conclusion
The investigation revealed that proper gRPC functionality cannot be verified or fixed without first establishing baseline blockchain node connectivity and acceptance criteria. A comprehensive test suite must be developed before further relay service modifications can be effectively implemented. 