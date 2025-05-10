package main

import (
	"context"
	"crypto/tls"
	"encoding/hex"
	"fmt"
	"io"
	"log"
	"net"
	"os"
	"strings"
	"time"

	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
	"google.golang.org/grpc/metadata"
	"google.golang.org/grpc/reflection"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/anypb"
)

var (
	targetAddr string
	port       string
	logger     *log.Logger

	knownRequestPayloadTypeURLs = map[string]string{
		"/pylons.pylons.Query/ListItemByOwner":         "type.googleapis.com/pylons.pylons.QueryListItemByOwnerRequest",
		"/pylons.pylons.Query/ListCookbooksByCreator": "type.googleapis.com/pylons.pylons.QueryListCookbooksByCreatorRequest",
		"/pylons.pylons.Query/ListTradesByCreator":    "type.googleapis.com/pylons.pylons.QueryListTradesByCreatorRequest",
		"/cosmos.bank.v1beta1.Query/AllBalances":      "type.googleapis.com/cosmos.bank.v1beta1.QueryAllBalancesRequest",
		"/pylons.pylons.Query/Cookbook":               "type.googleapis.com/pylons.pylons.QueryGetCookbookRequest",    // From logs, assumed Get
		"/pylons.pylons.Query/Recipe":                 "type.googleapis.com/pylons.pylons.QueryGetRecipeRequest",      // From logs, assumed Get
		"/cosmos.base.tendermint.v1beta1.Service/GetNodeInfo": "type.googleapis.com/cosmos.base.tendermint.v1beta1.GetNodeInfoRequest",
		// Add other known direct-to-Any mappings here as they are discovered
	}
)

// patchResultInfo holds information about the patching attempt for a message.
type patchResultInfo struct {
	Attempted       bool
	Successful      bool
	PatchName       string
	OriginalTypeURL string
	PatchedTypeURL  string
	Error           error
}

func (p patchResultInfo) String() string {
	if !p.Attempted {
		return "PatchNotAttempted"
	}
	if p.Error != nil {
		return fmt.Sprintf("PatchAttempted(Name:%s, Success:false, Error:'%v', OriginalURL:'%s')", p.PatchName, p.Error, p.OriginalTypeURL)
	}
	if p.Successful {
		return fmt.Sprintf("PatchApplied(Name:%s, Success:true, OriginalURL:'%s', PatchedURL:'%s')", p.PatchName, p.OriginalTypeURL, p.PatchedTypeURL)
	}
	return fmt.Sprintf("PatchAttempted(Name:%s, Success:false, OriginalURL:'%s')", p.PatchName, p.OriginalTypeURL)
}

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
		grpc.UnknownServiceHandler(proxyHandler),
	)
	reflection.Register(server)

	logger.Printf("Starting gRPC relay on port %s -> %s\n", port, targetAddr)
	logger.Printf("Logging to both stdout and grpc_relay.log\n")
	logger.Fatal(server.Serve(lis))
}

func safePayloadSnippet(payload []byte, maxLength int) string {
	if len(payload) == 0 {
		return "empty"
	}
	if len(payload) > maxLength {
		return hex.EncodeToString(payload[:maxLength]) + "..."
	}
	return hex.EncodeToString(payload)
}

// logDetailedGrpcError logs detailed information about an error during gRPC processing.
func logDetailedGrpcError(methodName, stage string, msgContext *anypb.Any, originalErr error, md metadata.MD, patchInfo patchResultInfo) {
	errMsg := fmt.Sprintf("[ERROR_DETAIL] Method:%s Stage:%s PatchInfo:[%s] Error:'%v'",
		methodName, stage, patchInfo.String(), originalErr)
	if msgContext != nil {
		errMsg += fmt.Sprintf(" MsgTypeURL:'%s' MsgValueLen:%d MsgValueSnippet(32B):'%s'",
			msgContext.TypeUrl, len(msgContext.Value), safePayloadSnippet(msgContext.Value, 32))
	}
	if len(md) > 0 {
		errMsg += fmt.Sprintf(" Metadata:'%v'", md)
	}
	logger.Println(errMsg)
	fmt.Println(errMsg) // Also print to stdout for immediate visibility
}

// logMessageFlow logs details of a message as it flows through the relay.
func logMessageFlow(methodName, stage string, msg *anypb.Any, md metadata.MD, patchInfo patchResultInfo) {
	logMsg := fmt.Sprintf("[MSG_FLOW] Method:%s Stage:%s PatchInfo:[%s]",
		methodName, stage, patchInfo.String())
	if msg != nil {
		logMsg += fmt.Sprintf(" MsgTypeURL:'%s' MsgValueLen:%d MsgValueSnippet(32B):'%s'",
			msg.TypeUrl, len(msg.Value), safePayloadSnippet(msg.Value, 32))
	}
	if md != nil && len(md) > 0 { // md can be nil for some stages
		logMsg += fmt.Sprintf(" Metadata:'%v'", md)
	}
	logger.Println(logMsg)
	fmt.Println(logMsg) // Also print to stdout
}

// attemptToApplyFix tries to fix a message, primarily by ensuring it's correctly wrapped in an Any type.
func attemptToApplyFix(fullMethodName string, originalMsg *anypb.Any) (*anypb.Any, patchResultInfo) {
	info := patchResultInfo{Attempted: true, OriginalTypeURL: originalMsg.TypeUrl, PatchName: "any_typeurl_rewrap"}

	expectedTypeURL, mappingExists := knownRequestPayloadTypeURLs[fullMethodName]

	if !mappingExists {
		logger.Printf("[PATCH_INFO] Method %s: No known TypeURL mapping. Passing through without patching.", fullMethodName)
		info.Attempted = false
		return originalMsg, info
	}

	// If TypeUrl is already the expected one, or if TypeUrl is not empty and Value is empty (potentially an Any wrapper with no payload)
	// we assume it's either correctly wrapped or an empty Any message that shouldn't be re-wrapped.
	if originalMsg.TypeUrl == expectedTypeURL || (originalMsg.TypeUrl != "" && len(originalMsg.Value) == 0) {
		if originalMsg.TypeUrl == expectedTypeURL {
			logger.Printf("[PATCH_INFO] Method %s: Client TypeURL '%s' matches expected. No re-wrapping needed.", fullMethodName, originalMsg.TypeUrl)
		} else {
			logger.Printf("[PATCH_INFO] Method %s: Client TypeURL '%s' is present but Value is empty. Assuming intended Any. No re-wrapping.", fullMethodName, originalMsg.TypeUrl)
		}
		info.Attempted = false // Not a failure, just no action taken.
		return originalMsg, info
	}

	// If TypeUrl is empty OR different from expected, and Value is not empty,
	// assume Value is the raw payload that needs to be wrapped (or re-wrapped with correct TypeURL).
	if (originalMsg.TypeUrl == "" || originalMsg.TypeUrl != expectedTypeURL) && len(originalMsg.Value) > 0 {
		logger.Printf("[PATCH_ATTEMPT] Method %s: Client TypeURL:'%s', Expected:'%s'. Client ValueLen:%d. Re-wrapping with expected TypeURL.",
			fullMethodName, originalMsg.TypeUrl, expectedTypeURL, len(originalMsg.Value))

		patchedMsg := &anypb.Any{
			TypeUrl: expectedTypeURL,
			Value:   originalMsg.Value, // The core assumption: originalMsg.Value IS the actual message bytes.
		}
		info.Successful = true
		info.PatchedTypeURL = expectedTypeURL
		logger.Printf("[PATCH_SUCCESS] Method %s: Re-wrapped. New TypeURL:'%s', ValueLen:%d.",
			fullMethodName, patchedMsg.TypeUrl, len(patchedMsg.Value))
		return patchedMsg, info
	}

	// Default: if none of the above conditions met, don't patch.
	// This could be if TypeURL is something unexpected and Value is also empty.
	logger.Printf("[PATCH_INFO] Method %s: Conditions for re-wrapping not met (OriginalTypeURL:'%s', ValueLen:%d). Passing through.",
		fullMethodName, originalMsg.TypeUrl, len(originalMsg.Value))
	info.Attempted = false // Or, could set an error if this state is considered invalid.
	info.Error = fmt.Errorf("unclear patching scenario: OriginalTypeURL='%s', ValueLen=%d", originalMsg.TypeUrl, len(originalMsg.Value))
	info.Successful = false
	return originalMsg, info
}

func proxyHandler(srv interface{}, stream grpc.ServerStream) error {
	startTime := time.Now()
	fullMethodName, ok := grpc.MethodFromServerStream(stream)
	if !ok {
		err := fmt.Errorf("failed to get method name from stream")
		logger.Printf("[FATAL_PROXY_SETUP] %v", err)
		return status.Errorf(codes.Internal, "%v", err)
	}

	md, _ := metadata.FromIncomingContext(stream.Context())
	logMessageFlow(fullMethodName, "request_received_by_relay", nil, md, patchResultInfo{Attempted: false})

	// Connect to target
	logger.Printf("[CONNECTING] Method:%s Target:%s", fullMethodName, targetAddr)
	ctx, cancel := context.WithTimeout(stream.Context(), 15*time.Second) // Increased timeout
	defer cancel()

	conn, err := grpc.DialContext(ctx, targetAddr,
		grpc.WithTransportCredentials(credentials.NewTLS(&tls.Config{
			InsecureSkipVerify: true, // Consider if this is appropriate for prod
		})),
		// grpc.WithBlock(), // Can cause issues if server is slow to respond initially
		grpc.WithDefaultServiceConfig(`{"loadBalancingPolicy":"round_robin"}`),
	)
	if err != nil {
		logDetailedGrpcError(fullMethodName, "target_dial_failed", nil, err, md, patchResultInfo{Attempted: false})
		return status.Errorf(codes.Unavailable, "failed to connect to target: %v", err)
	}
	defer conn.Close()
	logger.Printf("[CONNECTED] Method:%s Target:%s", fullMethodName, targetAddr)

	// Create client stream to target
	targetStream, err := conn.NewStream(ctx, &grpc.StreamDesc{
		ServerStreams: true,
		ClientStreams: true,
	}, fullMethodName)
	if err != nil {
		logDetailedGrpcError(fullMethodName, "target_newstream_failed", nil, err, md, patchResultInfo{Attempted: false})
		return status.Errorf(codes.Internal, "failed to create target stream: %v", err)
	}

	errChan := make(chan error, 2)

	// Goroutine to forward messages from client to target
	go func() {
		var clientMsgPatchInfo patchResultInfo
		for {
			clientRequestMsg := new(anypb.Any)
			if err := stream.RecvMsg(clientRequestMsg); err != nil {
				if err != io.EOF {
					logDetailedGrpcError(fullMethodName, "client_recv_error", clientRequestMsg, err, md, clientMsgPatchInfo)
					errChan <- fmt.Errorf("client recv error: %w", err)
				} else {
					errChan <- nil // EOF, stream closed by client
				}
				return
			}
			logMessageFlow(fullMethodName, "client_msg_raw_unpacked", clientRequestMsg, md, patchResultInfo{Attempted: false})

			// Attempt to patch the message
			patchedMsg, pInfo := attemptToApplyFix(fullMethodName, clientRequestMsg)
			clientMsgPatchInfo = pInfo // Store patch info for this specific message

			finalMsgToSendToTarget := patchedMsg // Use patchedMsg by default
			if pInfo.Error != nil {
				// Log patch error, but proceed with original message as per earlier plan
				logDetailedGrpcError(fullMethodName, "patch_application_error", clientRequestMsg, pInfo.Error, md, pInfo)
				finalMsgToSendToTarget = clientRequestMsg // Revert to original on patch error
				logMessageFlow(fullMethodName, "client_msg_patch_failed_reverting_to_original", finalMsgToSendToTarget, md, pInfo)
			} else if !pInfo.Successful && pInfo.Attempted {
				logMessageFlow(fullMethodName, "client_msg_patch_not_successful_using_original", finalMsgToSendToTarget, md, pInfo)
				// finalMsgToSendToTarget is already originalMsg if patch was not successful but attempted without error
			} else if pInfo.Successful {
				logMessageFlow(fullMethodName, "client_msg_patched_pre_send", finalMsgToSendToTarget, md, pInfo)
			} else { // Not attempted
				logMessageFlow(fullMethodName, "client_msg_unpatched_pre_send", finalMsgToSendToTarget, md, pInfo)
			}

			if err := targetStream.SendMsg(finalMsgToSendToTarget); err != nil {
				logDetailedGrpcError(fullMethodName, "target_send_error", finalMsgToSendToTarget, err, md, clientMsgPatchInfo)
				errChan <- fmt.Errorf("target send error: %w", err)
				return
			}
			logMessageFlow(fullMethodName, "target_msg_sent_successfully", finalMsgToSendToTarget, nil, clientMsgPatchInfo)
		}
	}()

	// Goroutine to forward messages from target to client
	go func() {
		for {
			targetResponseMsg := new(anypb.Any)
			if err := targetStream.RecvMsg(targetResponseMsg); err != nil {
				if err != io.EOF {
					// Note: No specific patch info for server response in this direction, could be linked via correlation ID if needed
					logDetailedGrpcError(fullMethodName, "target_recv_error", targetResponseMsg, err, nil, patchResultInfo{Attempted: false})
					errChan <- fmt.Errorf("target recv error: %w", err)
				} else {
					errChan <- nil // EOF, stream closed by target
				}
				return
			}
			logMessageFlow(fullMethodName, "target_response_received_by_relay", targetResponseMsg, nil, patchResultInfo{Attempted: false})

			if err := stream.SendMsg(targetResponseMsg); err != nil {
				logDetailedGrpcError(fullMethodName, "client_send_error_on_target_response", targetResponseMsg, err, md, patchResultInfo{Attempted: false})
				errChan <- fmt.Errorf("client send error: %w", err)
				return
			}
			logMessageFlow(fullMethodName, "target_response_sent_to_client", targetResponseMsg, nil, patchResultInfo{Attempted: false})
		}
	}()

	// Wait for an error or completion from either goroutine
	err = <-errChan
	duration := time.Since(startTime)

	if err != nil {
		// General stream error, specific errors are logged in goroutines
		logger.Printf("[STREAM_ERROR] Method:%s Duration:%v Error:'%v'", fullMethodName, duration, err)
		fmt.Printf("[STREAM_ERROR] Method:%s Duration:%v Error:'%v'\n", fullMethodName, duration, err)
		// The error from errChan will be returned to the client by gRPC
		return err
	}

	logger.Printf("[STREAM_SUCCESS] Method:%s Duration:%v", fullMethodName, duration)
	fmt.Printf("[STREAM_SUCCESS] Method:%s Duration:%v\n", fullMethodName, duration)
	return nil
}