# Pylons gRPC Relay Server

A relay server that handles message wrapping for the Pylons mobile app's gRPC communication.

## Purpose
The relay server acts as a man-in-the-middle to properly wrap messages in the `Any` type format required by the Pylons node. This fixes the HTTP 501 errors encountered by the mobile app.

## Usage
```bash
# Start the relay server
go run relay.go pylons.api.m.stavr.tech:443 :50051

# Monitor the logs
tail -f grpc_relay.log
```

## Message Format
The relay server handles the conversion between:

1. Mobile App Format:
```json
{
  "owner": "pylo1...",
  "pagination": {
    "key": "",
    "offset": 0,
    "limit": 10,
    "count_total": true
  }
}
```

2. Node Expected Format:
```json
{
  "type_url": "type.googleapis.com/pylons.pylons.QueryListItemByOwnerRequest",
  "value": "base64_encoded_data"
}
```

## Testing
See [INCIDENT_REPORT.md](INCIDENT_REPORT.md) for detailed testing procedures and data contracts. 