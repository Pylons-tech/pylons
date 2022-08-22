///
//  Generated code. Do not modify.
//  source: ibc/core/client/v1/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'query.pb.dart' as $0;
export 'query.pb.dart';

class QueryClient extends $grpc.Client {
  static final _$clientState = $grpc.ClientMethod<$0.QueryClientStateRequest,
          $0.QueryClientStateResponse>(
      '/ibc.core.client.v1.Query/ClientState',
      ($0.QueryClientStateRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryClientStateResponse.fromBuffer(value));
  static final _$clientStates = $grpc.ClientMethod<$0.QueryClientStatesRequest,
          $0.QueryClientStatesResponse>(
      '/ibc.core.client.v1.Query/ClientStates',
      ($0.QueryClientStatesRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryClientStatesResponse.fromBuffer(value));
  static final _$consensusState = $grpc.ClientMethod<
          $0.QueryConsensusStateRequest, $0.QueryConsensusStateResponse>(
      '/ibc.core.client.v1.Query/ConsensusState',
      ($0.QueryConsensusStateRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryConsensusStateResponse.fromBuffer(value));
  static final _$consensusStates = $grpc.ClientMethod<
          $0.QueryConsensusStatesRequest, $0.QueryConsensusStatesResponse>(
      '/ibc.core.client.v1.Query/ConsensusStates',
      ($0.QueryConsensusStatesRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryConsensusStatesResponse.fromBuffer(value));
  static final _$clientStatus = $grpc.ClientMethod<$0.QueryClientStatusRequest,
          $0.QueryClientStatusResponse>(
      '/ibc.core.client.v1.Query/ClientStatus',
      ($0.QueryClientStatusRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryClientStatusResponse.fromBuffer(value));
  static final _$clientParams = $grpc.ClientMethod<$0.QueryClientParamsRequest,
          $0.QueryClientParamsResponse>(
      '/ibc.core.client.v1.Query/ClientParams',
      ($0.QueryClientParamsRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryClientParamsResponse.fromBuffer(value));
  static final _$upgradedClientState = $grpc.ClientMethod<
          $0.QueryUpgradedClientStateRequest,
          $0.QueryUpgradedClientStateResponse>(
      '/ibc.core.client.v1.Query/UpgradedClientState',
      ($0.QueryUpgradedClientStateRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryUpgradedClientStateResponse.fromBuffer(value));
  static final _$upgradedConsensusState = $grpc.ClientMethod<
          $0.QueryUpgradedConsensusStateRequest,
          $0.QueryUpgradedConsensusStateResponse>(
      '/ibc.core.client.v1.Query/UpgradedConsensusState',
      ($0.QueryUpgradedConsensusStateRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryUpgradedConsensusStateResponse.fromBuffer(value));

  QueryClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.QueryClientStateResponse> clientState(
      $0.QueryClientStateRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$clientState, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryClientStatesResponse> clientStates(
      $0.QueryClientStatesRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$clientStates, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryConsensusStateResponse> consensusState(
      $0.QueryConsensusStateRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$consensusState, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryConsensusStatesResponse> consensusStates(
      $0.QueryConsensusStatesRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$consensusStates, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryClientStatusResponse> clientStatus(
      $0.QueryClientStatusRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$clientStatus, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryClientParamsResponse> clientParams(
      $0.QueryClientParamsRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$clientParams, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryUpgradedClientStateResponse> upgradedClientState(
      $0.QueryUpgradedClientStateRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$upgradedClientState, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryUpgradedConsensusStateResponse>
      upgradedConsensusState($0.QueryUpgradedConsensusStateRequest request,
          {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$upgradedConsensusState, request,
        options: options);
  }
}

abstract class QueryServiceBase extends $grpc.Service {
  $core.String get $name => 'ibc.core.client.v1.Query';

  QueryServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.QueryClientStateRequest,
            $0.QueryClientStateResponse>(
        'ClientState',
        clientState_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryClientStateRequest.fromBuffer(value),
        ($0.QueryClientStateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryClientStatesRequest,
            $0.QueryClientStatesResponse>(
        'ClientStates',
        clientStates_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryClientStatesRequest.fromBuffer(value),
        ($0.QueryClientStatesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryConsensusStateRequest,
            $0.QueryConsensusStateResponse>(
        'ConsensusState',
        consensusState_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryConsensusStateRequest.fromBuffer(value),
        ($0.QueryConsensusStateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryConsensusStatesRequest,
            $0.QueryConsensusStatesResponse>(
        'ConsensusStates',
        consensusStates_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryConsensusStatesRequest.fromBuffer(value),
        ($0.QueryConsensusStatesResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryClientStatusRequest,
            $0.QueryClientStatusResponse>(
        'ClientStatus',
        clientStatus_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryClientStatusRequest.fromBuffer(value),
        ($0.QueryClientStatusResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryClientParamsRequest,
            $0.QueryClientParamsResponse>(
        'ClientParams',
        clientParams_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryClientParamsRequest.fromBuffer(value),
        ($0.QueryClientParamsResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryUpgradedClientStateRequest,
            $0.QueryUpgradedClientStateResponse>(
        'UpgradedClientState',
        upgradedClientState_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryUpgradedClientStateRequest.fromBuffer(value),
        ($0.QueryUpgradedClientStateResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryUpgradedConsensusStateRequest,
            $0.QueryUpgradedConsensusStateResponse>(
        'UpgradedConsensusState',
        upgradedConsensusState_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryUpgradedConsensusStateRequest.fromBuffer(value),
        ($0.QueryUpgradedConsensusStateResponse value) =>
            value.writeToBuffer()));
  }

  $async.Future<$0.QueryClientStateResponse> clientState_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryClientStateRequest> request) async {
    return clientState(call, await request);
  }

  $async.Future<$0.QueryClientStatesResponse> clientStates_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryClientStatesRequest> request) async {
    return clientStates(call, await request);
  }

  $async.Future<$0.QueryConsensusStateResponse> consensusState_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryConsensusStateRequest> request) async {
    return consensusState(call, await request);
  }

  $async.Future<$0.QueryConsensusStatesResponse> consensusStates_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryConsensusStatesRequest> request) async {
    return consensusStates(call, await request);
  }

  $async.Future<$0.QueryClientStatusResponse> clientStatus_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryClientStatusRequest> request) async {
    return clientStatus(call, await request);
  }

  $async.Future<$0.QueryClientParamsResponse> clientParams_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryClientParamsRequest> request) async {
    return clientParams(call, await request);
  }

  $async.Future<$0.QueryUpgradedClientStateResponse> upgradedClientState_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryUpgradedClientStateRequest> request) async {
    return upgradedClientState(call, await request);
  }

  $async.Future<$0.QueryUpgradedConsensusStateResponse>
      upgradedConsensusState_Pre($grpc.ServiceCall call,
          $async.Future<$0.QueryUpgradedConsensusStateRequest> request) async {
    return upgradedConsensusState(call, await request);
  }

  $async.Future<$0.QueryClientStateResponse> clientState(
      $grpc.ServiceCall call, $0.QueryClientStateRequest request);
  $async.Future<$0.QueryClientStatesResponse> clientStates(
      $grpc.ServiceCall call, $0.QueryClientStatesRequest request);
  $async.Future<$0.QueryConsensusStateResponse> consensusState(
      $grpc.ServiceCall call, $0.QueryConsensusStateRequest request);
  $async.Future<$0.QueryConsensusStatesResponse> consensusStates(
      $grpc.ServiceCall call, $0.QueryConsensusStatesRequest request);
  $async.Future<$0.QueryClientStatusResponse> clientStatus(
      $grpc.ServiceCall call, $0.QueryClientStatusRequest request);
  $async.Future<$0.QueryClientParamsResponse> clientParams(
      $grpc.ServiceCall call, $0.QueryClientParamsRequest request);
  $async.Future<$0.QueryUpgradedClientStateResponse> upgradedClientState(
      $grpc.ServiceCall call, $0.QueryUpgradedClientStateRequest request);
  $async.Future<$0.QueryUpgradedConsensusStateResponse> upgradedConsensusState(
      $grpc.ServiceCall call, $0.QueryUpgradedConsensusStateRequest request);
}
