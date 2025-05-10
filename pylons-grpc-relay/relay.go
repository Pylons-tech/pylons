/*
GRPC Relay Service - Known Issues (2024-05-10)

Current implementation issues:

1. Protocol Handling:
   - The service receives gRPC requests but server responds with HTTP 501
   - Response headers show application/json instead of application/grpc
   - Issue may be in proxyHandler() where HTTP/2 framing is not preserved

2. TLS Configuration:
   - Current TLS setup in main():
     ```go
     creds := credentials.NewTLS(&tls.Config{
         InsecureSkipVerify: true,
         ServerName:         "pylons.api.m.stavr.tech",
     })
     ```
   - May need additional TLS options for proper gRPC handshake
   - Consider adding gRPC-specific TLS configuration

3. Connection Setup:
   - Current dial options in main():
     ```go
     conn, err := grpc.Dial(targetAddr,
         grpc.WithTransportCredentials(creds),
         grpc.WithDefaultCallOptions(grpc.CallCustomCodec(rawCodec{})),
         grpc.WithAuthority("pylons.api.m.stavr.tech"),
     )
     ```
   - Raw codec may not properly handle protobuf messages
   - Consider using generated protobuf code instead

4. Stream Handling:
   - proxyHandler() uses generic streams
   - May need service-specific stream handling
   - Consider implementing proper gRPC service interfaces

Reference: See incident-reports/2024-05-10-grpc-relay for investigation details
*/

package main

import (
	"crypto/tls"
	"fmt"
	"io"
	"log"
	"net"
	"os"
	"strings"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/encoding"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/reflection"
)

func init() {
	encoding.RegisterCodec(rawCodec{})
}

type rawCodec struct{}

func (rawCodec) Marshal(v interface{}) ([]byte, error) {
	return v.([]byte), nil
}

func (rawCodec) Unmarshal(data []byte, v interface{}) error {
	*v.(*[]byte) = data
	return nil
}

func (rawCodec) Name() string {
	return "raw"
}

func (rawCodec) String() string {
	return "raw"
}

func main() {
	// Get target address from command line or use default
	targetAddr := "pylons.api.m.stavr.tech:443"
	if len(os.Args) > 1 {
		targetAddr = os.Args[1]
		// Remove any protocol prefix
		targetAddr = strings.TrimPrefix(targetAddr, "https://")
		targetAddr = strings.TrimPrefix(targetAddr, "http://")
	}

	listenAddr := ":50051"
	if len(os.Args) > 2 {
		listenAddr = os.Args[2]
	}

	// Create log file
	logFile, err := os.OpenFile("grpc_relay.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		log.Fatalf("Failed to open log file: %v", err)
	}
	defer logFile.Close()
	logger := log.New(io.MultiWriter(os.Stdout, logFile), "", log.LstdFlags)

	lis, err := net.Listen("tcp", listenAddr)
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}

	// Create TLS credentials
	creds := credentials.NewTLS(&tls.Config{
		InsecureSkipVerify: true,
		ServerName:         "pylons.api.m.stavr.tech",
	})

	// Create connection to target
	conn, err := grpc.Dial(targetAddr,
		grpc.WithTransportCredentials(creds),
		grpc.WithDefaultCallOptions(grpc.CallCustomCodec(rawCodec{})),
		grpc.WithAuthority("pylons.api.m.stavr.tech"),
	)
	if err != nil {
		log.Fatalf("Failed to dial target: %v", err)
	}
	defer conn.Close()

	server := grpc.NewServer(
		grpc.UnknownServiceHandler(proxyHandler(conn, logger)),
		grpc.ForceServerCodec(rawCodec{}),
	)
	reflection.Register(server)

	logger.Printf("Starting gRPC relay on %s -> %s", listenAddr, targetAddr)
	logger.Printf("Logging to both stdout and grpc_relay.log")
	log.Fatal(server.Serve(lis))
}

func proxyHandler(conn *grpc.ClientConn, logger *log.Logger) grpc.StreamHandler {
	return func(srv interface{}, stream grpc.ServerStream) error {
		fullMethodName, ok := grpc.MethodFromServerStream(stream)
		if !ok {
			return fmt.Errorf("failed to get method name")
		}

		logger.Printf("[REQUEST] %s %s", time.Now().Format(time.RFC3339), fullMethodName)

		// Log metadata
		if md, ok := metadata.FromIncomingContext(stream.Context()); ok {
			logger.Printf("[METADATA] Headers: %+v", md)
		}

		// Create client stream
		ctx := stream.Context()
		if md, ok := metadata.FromIncomingContext(ctx); ok {
			ctx = metadata.NewOutgoingContext(ctx, md)
		}

		clientStream, err := conn.NewStream(ctx, &grpc.StreamDesc{
			ServerStreams: true,
			ClientStreams: true,
		}, fullMethodName)
		if err != nil {
			logger.Printf("[ERROR] Failed to create client stream: %v", err)
			return fmt.Errorf("failed to create client stream: %v", err)
		}

		// Start proxying in both directions
		errChan := make(chan error, 2)

		// Forward client -> target
		go func() {
			for {
				var msg []byte
				err := stream.RecvMsg(&msg)
				if err == io.EOF {
					logger.Printf("[CLIENT->TARGET] EOF received")
					clientStream.CloseSend()
					errChan <- nil
					return
				}
				if err != nil {
					logger.Printf("[CLIENT->TARGET] Error receiving: %v", err)
					errChan <- fmt.Errorf("failed to receive from client: %v", err)
					return
				}

				logger.Printf("[CLIENT->TARGET] Received message (%d bytes)", len(msg))

				if err := clientStream.SendMsg(msg); err != nil {
					logger.Printf("[CLIENT->TARGET] Error sending: %v", err)
					errChan <- fmt.Errorf("failed to send to target: %v", err)
					return
				}
				logger.Printf("[CLIENT->TARGET] Message forwarded successfully")
			}
		}()

		// Forward target -> client
		go func() {
			for {
				var msg []byte
				err := clientStream.RecvMsg(&msg)
				if err == io.EOF {
					logger.Printf("[TARGET->CLIENT] EOF received")
					errChan <- nil
					return
				}
				if err != nil {
					logger.Printf("[TARGET->CLIENT] Error receiving: %v", err)
					errChan <- fmt.Errorf("failed to receive from target: %v", err)
					return
				}

				logger.Printf("[TARGET->CLIENT] Received message (%d bytes)", len(msg))

				if err := stream.SendMsg(msg); err != nil {
					logger.Printf("[TARGET->CLIENT] Error sending: %v", err)
					errChan <- fmt.Errorf("failed to send to client: %v", err)
					return
				}
				logger.Printf("[TARGET->CLIENT] Message forwarded successfully")
			}
		}()

		// Wait for both goroutines to complete
		for i := 0; i < 2; i++ {
			if err := <-errChan; err != nil {
				logger.Printf("[ERROR] Stream error: %v", err)
				return err
			}
		}

		logger.Printf("[COMPLETE] Stream completed successfully")
		return nil
	}
}