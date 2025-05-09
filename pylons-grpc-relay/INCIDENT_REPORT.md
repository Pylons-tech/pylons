# gRPC Communication Issue: Flutter Mobile App to Pylons Node

## Current Situation

### 1. The Problem
Flutter app fails to communicate with Pylons node:
```
[ERROR] 2024-03-21T10:15:23Z /pylons.pylons.Query/ListItemByOwner
Status: 501 Not Implemented
Server: nginx/1.18.0
```

### 2. The Key Difference
**App sends (fails):**
```
{
  "owner": "pylo1fhvaknqx2ngyltz2qzychlm75cyp4tkh09d539",
  "pagination": {
    "key": "",
    "offset": "0",
    "limit": "10",
    "count_total": true
  }
}
```

**Node expects (works):**
```
{
  "type_url": "type.googleapis.com/pylons.pylons.QueryListItemByOwnerRequest",
  "value": "Cg5weWxvMXNoZnZha25xeDJuZ3lsdHoycXp5Y2hsbTc1Y3lwNHRraDA5ZDUzOQ=="
}
```

The node requires all messages to be wrapped in an `Any` type with:
- `type_url`: Message type identifier
- `value`: Binary-encoded message data

### 3. Solution
Relay server that:
1. Receives raw messages
2. Wraps them in `Any` type
3. Forwards to node

Success response:
```
[REQUEST] 2024-03-21T10:20:15Z /pylons.pylons.Query/ListItemByOwner
[CONNECTED] Successfully connected
Response: {
  "items": [{
    "id": "item1",
    "owner": "pylo1fhvaknqx2ngyltz2qzychlm75cyp4tkh09d539",
    "cookbook_id": "cookbook1",
    "transferable": true
  }]
}
```

### 4. Implementation & Testing
```bash
# Start relay with logging
go run relay.go pylons.api.m.stavr.tech:443 :50051 > relay.log 2>&1
```

Key files to modify in Dart code:
- `lib/modules/Pylonstech.pylons.pylons/module/client/pylons/query.pbgrpc.dart`
  - `QueryClient` class needs message wrapping
  - Methods: `listItemByOwner`, `listCookbooksByCreator`

Data Contract:
1. Request Format:
```
Input:
{
  "owner": string,
  "pagination": {
    "key": bytes,
    "offset": int64,
    "limit": int64,
    "count_total": bool
  }
}

Expected Wrapped Format:
{
  "type_url": "type.googleapis.com/pylons.pylons.QueryListItemByOwnerRequest",
  "value": bytes  // Binary encoded request
}
```

2. Response Format:
```
Expected Wrapped Format:
{
  "type_url": "type.googleapis.com/pylons.pylons.QueryListItemByOwnerResponse",
  "value": bytes  // Binary encoded response
}

Unwrapped Response:
{
  "items": [{
    "id": string,
    "owner": string,
    "cookbook_id": string,
    "transferable": bool
  }],
  "pagination": {
    "next_key": bytes,
    "total": string
  }
}
```

Test flow:
1. Validate request wrapping matches contract
2. Start relay
3. Run app through relay
4. Verify message wrapping in logs
5. Check successful responses

## References
- [gRPC Documentation](https://grpc.io/docs/)
- [Pylons Node API](https://docs.pylons.tech) 