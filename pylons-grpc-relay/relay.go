package main

import (
	"context"
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
	"google.golang.org/grpc/reflection"
	"google.golang.org/grpc/metadata"
	"google.golang.org/protobuf/types/known/anypb"
)

var (
	targetAddr string
	port       string
	logger     *log.Logger
)

func init() {
	// Get target address from environment variable or use default
	targetAddr = os.Getenv("TARGET_ADDRESS")
	if targetAddr == "" {
		targetAddr = "pylons.api.m.stavr.tech:443"
	}
	// Remove any protocol prefix if present
	targetAddr = strings.TrimPrefix(targetAddr, "https://")
	targetAddr = strings.TrimPrefix(targetAddr, "http://")

	// Get port from environment variable or use default
	port = os.Getenv("PORT")
	if port == "" {
		port = "50051"
	}

	// Set up logging to both file and stdout for local development
	logFile, err := os.OpenFile("grpc_relay.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
	if err != nil {
		log.Printf("Warning: Failed to open log file: %v. Logging to stdout only.", err)
		logger = log.New(os.Stdout, "", log.LstdFlags)
	} else {
		// Create a multi-writer to log to both file and stdout
		multiWriter := io.MultiWriter(os.Stdout, logFile)
		logger = log.New(multiWriter, "", log.LstdFlags)
	}
}

func main() {
	// Set up server
	lis, err := net.Listen("tcp", ":"+port)
	if err != nil {
		logger.Fatalf("Failed to listen: %v", err)
	}

	// Create a router that passes all requests through to the target
	server := grpc.NewServer(
		grpc.UnknownServiceHandler(proxyHandler(targetAddr, logger)),
	)
	reflection.Register(server)

	logger.Printf("Starting gRPC relay on port %s -> %s\n", port, targetAddr)
	logger.Printf("Logging to both stdout and grpc_relay.log\n")
	logger.Fatal(server.Serve(lis))
}

func proxyHandler(targetAddr string, logger *log.Logger) grpc.StreamHandler {
	return func(srv interface{}, stream grpc.ServerStream) error {
		start := time.Now()
		fullMethodName, ok := grpc.MethodFromServerStream(stream)
		if !ok {
			return fmt.Errorf("failed to get method name")
		}

		// Enhanced request logging
		logMsg := fmt.Sprintf("[REQUEST] %s %s", time.Now().Format(time.RFC3339), fullMethodName)
		logger.Println(logMsg)
		fmt.Println(logMsg)

		// Log request metadata
		md, _ := metadata.FromIncomingContext(stream.Context())
		if len(md) > 0 {
			mdLog := fmt.Sprintf("[METADATA] %s - Headers: %v", fullMethodName, md)
			logger.Println(mdLog)
			fmt.Println(mdLog)
		}

		// Log connection attempt
		connMsg := fmt.Sprintf("[CONNECTING] %s - Attempting to connect to %s",
			fullMethodName, targetAddr)
		logger.Println(connMsg)
		fmt.Println(connMsg)

		// Create a context with timeout
		ctx, cancel := context.WithTimeout(stream.Context(), 5*time.Second)
		defer cancel()

		// Connect to target server with enhanced options
		conn, err := grpc.DialContext(ctx, targetAddr,
			grpc.WithTransportCredentials(credentials.NewTLS(&tls.Config{
				InsecureSkipVerify: true, // Skip certificate verification
			})),
			grpc.WithBlock(),
			grpc.WithDefaultServiceConfig(`{"loadBalancingPolicy":"round_robin"}`),
		)
		if err != nil {
			errMsg := fmt.Sprintf("[ERROR] %s %s - Connection failed: %v",
				time.Now().Format(time.RFC3339), fullMethodName, err)
			logger.Println(errMsg)
			fmt.Println(errMsg)
			return err
		}
		defer conn.Close()

		// Log connection success
		connMsg = fmt.Sprintf("[CONNECTED] %s - Successfully connected to %s",
			fullMethodName, targetAddr)
		logger.Println(connMsg)
		fmt.Println(connMsg)

		// Create a new stream to the target server
		targetStream, err := conn.NewStream(ctx, &grpc.StreamDesc{
			ServerStreams: true,
			ClientStreams: true,
		}, fullMethodName)
		if err != nil {
			errMsg := fmt.Sprintf("[ERROR] %s %s - Failed to create target stream: %v",
				time.Now().Format(time.RFC3339), fullMethodName, err)
			logger.Println(errMsg)
			fmt.Println(errMsg)
			return err
		}

		// Forward messages in both directions
		errChan := make(chan error, 2)

		// Forward from client to target
		go func() {
			for {
				msg := new(anypb.Any)
				if err := stream.RecvMsg(msg); err != nil {
					if err != io.EOF {
						errChan <- fmt.Errorf("client recv error: %v", err)
					}
					errChan <- nil
					return
				}
				if err := targetStream.SendMsg(msg); err != nil {
					errChan <- fmt.Errorf("target send error: %v", err)
					return
				}
			}
		}()

		// Forward from target to client
		go func() {
			for {
				msg := new(anypb.Any)
				if err := targetStream.RecvMsg(msg); err != nil {
					if err != io.EOF {
						errChan <- fmt.Errorf("target recv error: %v", err)
					}
					errChan <- nil
					return
				}
				if err := stream.SendMsg(msg); err != nil {
					errChan <- fmt.Errorf("client send error: %v", err)
					return
				}
			}
		}()

		// Wait for either direction to complete
		err = <-errChan

		// Enhanced result logging
		duration := time.Since(start).Milliseconds()
		if err != nil {
			errMsg := fmt.Sprintf("[ERROR] %s %s (%dms) - %v",
				time.Now().Format(time.RFC3339), fullMethodName, duration, err)
			logger.Println(errMsg)
			fmt.Println(errMsg)
		} else {
			successMsg := fmt.Sprintf("[SUCCESS] %s %s (%dms)",
				time.Now().Format(time.RFC3339), fullMethodName, duration)
			logger.Println(successMsg)
			fmt.Println(successMsg)
		}

		return err
	}
}
