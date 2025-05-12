# gRPC Relay Service

A gRPC relay service that forwards gRPC requests to a target server while providing comprehensive logging and monitoring.

## Features

- gRPC request forwarding
- Comprehensive logging
- Docker support
- Local development with ngrok
- Systemd service support for production deployment

## Logging

The service provides detailed logging for all operations. Logs are written to both stdout and a log file (`grpc_relay.log`).

### Log Categories

- `[REQUEST]`: Initial request received
- `[METADATA]`: Request metadata and headers
- `[CONNECTING]`: Connection attempt to target server
- `[CONNECTED]`: Successful connection to target server
- `[ERROR]`: Any errors that occur
- `[SUCCESS]`: Successful request completion

### Log Format

```
[REQUEST] 2024-03-14T10:00:00Z /service/method
[METADATA] /service/method - Headers: map[key:value]
[CONNECTING] /service/method - Attempting to connect to target.address:443
[CONNECTED] /service/method - Successfully connected to target.address:443
[SUCCESS] /service/method (150ms)
```

Error logs include detailed error information:
```
[ERROR] /service/method - Connection failed: connection refused
[ERROR] /service/method (50ms) - client recv error: connection reset
```

## Configuration

### Environment Variables

- `TARGET_ADDRESS`: Target gRPC server address (default: "pylons.api.m.stavr.tech:443")
- `PORT`: Port to listen on (default: "50051")

## Local Development

### Prerequisites

- Docker and Docker Compose
- ngrok (for exposing local service)

### Running Locally

1. Start the service:
```bash
docker-compose up --build
```

2. In a separate terminal, start ngrok:
```bash
ngrok tcp 50051
```

3. Use the ngrok URL (e.g., `0.tcp.ngrok.io:12345`) to connect to your local service.

## Production Deployment

### Docker Deployment

1. Build the image:
```bash
docker build -t grpc-relay .
```

2. Run the container:
```bash
docker run -d \
  -p 50051:50051 \
  -e TARGET_ADDRESS=your.target.address:443 \
  -e PORT=50051 \
  --name grpc-relay \
  grpc-relay
```

### Systemd Deployment

1. Copy the service file:
```bash
sudo cp grpc-relay.service /etc/systemd/system/
```

2. Copy the binary:
```bash
sudo cp relay /opt/grpc-relay/
```

3. Enable and start the service:
```bash
sudo systemctl enable grpc-relay
sudo systemctl start grpc-relay
```

## Monitoring

### Log Files

- Container logs: `docker logs grpc-relay`
- File logs: `/app/grpc_relay.log` (in container) or `/opt/grpc-relay/grpc_relay.log` (systemd)

### Service Status

- Docker: `docker ps` and `docker logs`
- Systemd: `systemctl status grpc-relay`

## Troubleshooting

### Common Issues

1. **Connection Refused**
   - Check if target server is accessible
   - Verify TARGET_ADDRESS is correct
   - Check firewall settings

2. **Port Already in Use**
   - Change PORT environment variable
   - Check if another instance is running

3. **Log File Issues**
   - Service falls back to stdout-only logging if file writing fails
   - Check directory permissions

## Security Considerations

- The service uses TLS for target connections
- Consider implementing authentication if needed
- Review and adjust firewall rules
- Monitor log files for unusual patterns

## Maintenance

### Log Rotation

Consider implementing log rotation for the log file. Example logrotate configuration:

```
/opt/grpc-relay/grpc_relay.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 0640 grpc-relay grpc-relay
}
```

### Updates

1. Stop the service
2. Update the binary
3. Restart the service

For Docker:
```bash
docker-compose down
docker-compose up --build -d
```

For Systemd:
```bash
sudo systemctl stop grpc-relay
sudo cp new-relay /opt/grpc-relay/relay
sudo systemctl start grpc-relay
```

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

## Enhanced Diagnostics and Patching (May 2025)

The gRPC relay has been significantly enhanced to aid in diagnosing and incrementally fixing issues with gRPC calls, particularly those originating from clients that might not correctly wrap messages in the `google.protobuf.Any` type as expected by the target Pylons node.

### Key Features:

1.  **Detailed Logging**:
    *   The relay now produces verbose logs (to `grpc_relay.log` and stdout) for each gRPC call.
    *   **`[MSG_FLOW]`**: Traces messages at various stages:
        *   `request_received_by_relay`: Initial incoming request with metadata.
        *   `client_msg_raw_unpacked`: After the relay receives a message from the client, showing its raw `TypeUrl` and a snippet of its `Value`. This is crucial for seeing what the client actually sent.
        *   `client_msg_patched_pre_send` / `client_msg_unpatched_pre_send`: Shows the message just before it's sent to the target, indicating if a patch was applied.
        *   `target_msg_sent_successfully`: Confirmation of successful send to target.
        *   `target_response_received_by_relay`: Response received from the target.
        *   `target_response_sent_to_client`: Confirmation of successful send of target's response back to the client.
    *   **`[ERROR_DETAIL]`**: Provides detailed context when an error occurs, including:
        *   `Method`: The gRPC method name.
        *   `Stage`: Where in the relay's processing the error happened (e.g., `client_recv_error`, `target_send_error`, `patch_application_error`).
        *   `MsgTypeURL`, `MsgValueLen`, `MsgValueSnippet`: Details of the message being processed when the error occurred.
        *   `Metadata`: Incoming request metadata.
    *   **`PatchInfo`**: Both `[MSG_FLOW]` and `[ERROR_DETAIL]` logs include patch information:
        *   `PatchNotAttempted`: No patch was tried for this message.
        *   `PatchAttempted(Name:..., Success:false, ...)`: A patch was tried but was not successful (e.g., conditions for patching weren't fully met, or the patch logic itself had an issue).
        *   `PatchApplied(Name:..., Success:true, OriginalURL:..., PatchedURL:...)`: A patch was successfully applied, showing the original and new `TypeUrl`.

2.  **Message Patching (`attemptToApplyFix` function)**:
    *   The relay now includes a mechanism to "patch" incoming messages before forwarding them to the target gRPC server.
    *   Currently, the primary patch (`any_typeurl_rewrap`) focuses on fixing issues where client messages are not correctly wrapped in `google.protobuf.Any`.
    *   It uses a predefined map `knownRequestPayloadTypeURLs` in `relay.go`. This map links gRPC method names (e.g., `/pylons.pylons.Query/ListItemByOwner`) to their expected `TypeUrl` (e.g., `type.googleapis.com/pylons.pylons.QueryListItemByOwnerRequest`).
    *   **How it works**:
        1.  If an incoming message's `TypeUrl` is empty or different from the `expectedTypeURL` for that method, AND the message `Value` is not empty:
            *   The relay assumes `Value` contains the raw protobuf bytes of the actual request.
            *   It creates a new `anypb.Any` message, setting its `TypeUrl` to the `expectedTypeURL` and its `Value` to the original message's `Value`.
        2.  If the incoming message's `TypeUrl` already matches the expected one, or if no specific mapping exists for the method, the message is passed through as-is (or with minimal intervention).
    *   **Adding New Patches/Mappings**: To support fixing new methods or refining existing ones, update the `knownRequestPayloadTypeURLs` map in `relay.go`.

3.  **Identifying Incorrect Calls**:
    *   Look for `[ERROR_DETAIL]` logs, especially "target_send_error" with "failed to marshal" messages.
    *   Examine the preceding `[MSG_FLOW]` logs for that method, particularly the `client_msg_raw_unpacked` stage. This will show the `TypeUrl` and `Value` snippet sent by the client.
    *   If `TypeUrl` is empty or incorrect, and `Value` seems to contain the actual payload, this method is a candidate for adding/updating its entry in `knownRequestPayloadTypeURLs`.

### Environment Variables:

*   `TARGET_ADDRESS`: The address (host:port) of the target gRPC server (e.g., `pylons.api.m.stavr.tech:443`). Do NOT include `http://` or `https://`.
*   `PORT`: The port on which this relay server will listen (e.g., `50051`).

This enhanced relay aims to simplify debugging and allow for rapid, iterative fixes to client-server gRPC communication issues without requiring immediate client-side code changes. 