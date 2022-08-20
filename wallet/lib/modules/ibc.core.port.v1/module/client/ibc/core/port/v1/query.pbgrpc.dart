///
//  Generated code. Do not modify.
//  source: ibc/core/port/v1/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'query.pb.dart' as $0;
export 'query.pb.dart';

class QueryClient extends $grpc.Client {
  static final _$appVersion =
      $grpc.ClientMethod<$0.QueryAppVersionRequest, $0.QueryAppVersionResponse>(
          '/ibc.core.port.v1.Query/AppVersion',
          ($0.QueryAppVersionRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.QueryAppVersionResponse.fromBuffer(value));

  QueryClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.QueryAppVersionResponse> appVersion(
      $0.QueryAppVersionRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$appVersion, request, options: options);
  }
}

abstract class QueryServiceBase extends $grpc.Service {
  $core.String get $name => 'ibc.core.port.v1.Query';

  QueryServiceBase() {
    $addMethod($grpc.ServiceMethod<$0.QueryAppVersionRequest,
            $0.QueryAppVersionResponse>(
        'AppVersion',
        appVersion_Pre,
        false,
        false,
        ($core.List<$core.int> value) =>
            $0.QueryAppVersionRequest.fromBuffer(value),
        ($0.QueryAppVersionResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.QueryAppVersionResponse> appVersion_Pre(
      $grpc.ServiceCall call,
      $async.Future<$0.QueryAppVersionRequest> request) async {
    return appVersion(call, await request);
  }

  $async.Future<$0.QueryAppVersionResponse> appVersion(
      $grpc.ServiceCall call, $0.QueryAppVersionRequest request);
}
