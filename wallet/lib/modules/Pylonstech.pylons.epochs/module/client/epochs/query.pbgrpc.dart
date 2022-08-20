///
//  Generated code. Do not modify.
//  source: epochs/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'query.pb.dart' as $0;
export 'query.pb.dart';

class QueryClient extends $grpc.Client {
  static final _$epochInfos =
      $grpc.ClientMethod<$0.QueryEpochsInfoRequest, $0.QueryEpochsInfoResponse>(
          '/Pylonstech.pylons.epochs.Query/EpochInfos',
          ($0.QueryEpochsInfoRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.QueryEpochsInfoResponse.fromBuffer(value));
  static final _$currentEpoch = $grpc.ClientMethod<$0.QueryCurrentEpochRequest,
          $0.QueryCurrentEpochResponse>(
      '/Pylonstech.pylons.epochs.Query/CurrentEpoch',
      ($0.QueryCurrentEpochRequest value) => value.writeToBuffer(),
      ($core.List<$core.int> value) =>
          $0.QueryCurrentEpochResponse.fromBuffer(value));

  QueryClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.QueryEpochsInfoResponse> epochInfos(
      $0.QueryEpochsInfoRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$epochInfos, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryCurrentEpochResponse> currentEpoch(
      $0.QueryCurrentEpochRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$currentEpoch, request, options: options);
  }
}

abstract class QueryServiceBase extends $grpc.Service {
  $core.String get $name => 'Pylonstech.pylons.epochs.Query';

  QueryServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.QueryEpochsInfoRequest,
            $0.QueryEpochsInfoResponse>(
        'EpochInfos',
        epochInfos_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryEpochsInfoRequest.fromBuffer(value),
        ($0.QueryEpochsInfoResponse value) => value.writeToBuffer()));
    $addMethod($grpc.ServiceMethod<$0.QueryCurrentEpochRequest,
            $0.QueryCurrentEpochResponse>(
        'CurrentEpoch',
        currentEpoch_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryCurrentEpochRequest.fromBuffer(value),
        ($0.QueryCurrentEpochResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.QueryEpochsInfoResponse> epochInfos_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryEpochsInfoRequest> request) async {
    return epochInfos(call, await request);
  }

  $async.Future<$0.QueryCurrentEpochResponse> currentEpoch_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryCurrentEpochRequest> request) async {
    return currentEpoch(call, await request);
  }

  $async.Future<$0.QueryEpochsInfoResponse> epochInfos(
      $grpc.ServiceCall call, $0.QueryEpochsInfoRequest request);
  $async.Future<$0.QueryCurrentEpochResponse> currentEpoch(
      $grpc.ServiceCall call, $0.QueryCurrentEpochRequest request);
}
