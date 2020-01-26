# Dockerfile References: https://docs.docker.com/engine/reference/builder/

# Start from the latest golang base image
FROM golang:latest

# Add Maintainer Info
LABEL maintainer="Michael Sofaer <m@pylons.tech>"

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the Go app
RUN go build ./cmd/pylonsd/

RUN GO111MODULE=on make unit_tests

RUN ./pylonsd init --chain-id pylonschain

# Command to run the executable
#Run please, GCB
CMD ["/app/pylonsd", "start", "--rpc.laddr", "tcp://0.0.0.0:26657"]
