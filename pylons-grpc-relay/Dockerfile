# Use the official Go image as the base image
FROM golang:1.24-alpine

# Set the working directory
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code
COPY . .

RUN go build -v -o relay

# Build and run the application
CMD ["/app/relay"]
