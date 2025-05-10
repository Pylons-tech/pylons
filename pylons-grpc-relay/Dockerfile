# Use the official Go image as the base image
FROM golang:1.21-alpine

# Set the working directory
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build and run the application
CMD ["go", "run", "."] 