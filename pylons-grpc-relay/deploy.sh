#!/bin/bash

# Exit on error
set -e

# Create service user
sudo useradd -r -s /bin/false grpc-relay

# Create application directory
sudo mkdir -p /opt/grpc-relay
sudo chown grpc-relay:grpc-relay /opt/grpc-relay

# Copy binary and service file
sudo cp relay /opt/grpc-relay/
sudo cp grpc-relay.service /etc/systemd/system/

# Set permissions
sudo chown grpc-relay:grpc-relay /opt/grpc-relay/relay
sudo chmod +x /opt/grpc-relay/relay

# Reload systemd and enable service
sudo systemctl daemon-reload
sudo systemctl enable grpc-relay
sudo systemctl start grpc-relay

# Check status
sudo systemctl status grpc-relay 