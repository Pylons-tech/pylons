///
//  Generated code. Do not modify.
//  source: cosmos/auth/v1beta1/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:async' as $async;

import 'dart:core' as $core;

import 'package:grpc/service_api.dart' as $grpc;
import 'query.pb.dart' as $0;
export 'query.pb.dart';

class QueryClient extends $grpc.Client {
  static final _$accounts =
      $grpc.ClientMethod<$0.QueryAccountsRequest, $0.QueryAccountsResponse>(
          '/cosmos.auth.v1beta1.Query/Accounts',
          ($0.QueryAccountsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.QueryAccountsResponse.fromBuffer(value));
  static final _$account =
      $grpc.ClientMethod<$0.QueryAccountRequest, $0.QueryAccountResponse>(
          '/cosmos.auth.v1beta1.Query/Account',
          ($0.QueryAccountRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.QueryAccountResponse.fromBuffer(value));
  static final _$params =
      $grpc.ClientMethod<$0.QueryParamsRequest, $0.QueryParamsResponse>(
          '/cosmos.auth.v1beta1.Query/Params',
          ($0.QueryParamsRequest value) => value.writeToBuffer(),
          ($core.List<$core.int> value) =>
              $0.QueryParamsResponse.fromBuffer(value));

  QueryClient($grpc.ClientChannel channel,
      {$grpc.CallOptions? options,
      $core.Iterable<$grpc.ClientInterceptor>? interceptors})
      : super(channel, options: options, interceptors: interceptors);

  $grpc.ResponseFuture<$0.QueryAccountsResponse> accounts(
      $0.QueryAccountsRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$accounts, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryAccountResponse> account(
      $0.QueryAccountRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$account, request, options: options);
  }

  $grpc.ResponseFuture<$0.QueryParamsResponse> params(
      $0.QueryParamsRequest request,
      {$grpc.CallOptions? options}) {
    return $createUnaryCall(_$params, request, options: options);
  }
}

abstract class QueryServiceBase extends $grpc.Service {
  $core.String get $name => 'cosmos.auth.v1beta1.Query';

  QueryServiceBase() {
    $addMethod(
        $grpc.ServiceMethod<$0.QueryAccountsRequest, $0.QueryAccountsResponse>(
            'Accounts',
            accounts_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.QueryAccountsRequest.fromBuffer(value),
            ($0.QueryAccountsResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.QueryAccountRequest, $0.QueryAccountResponse>(
            'Account',
            account_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.QueryAccountRequest.fromBuffer(value),
            ($0.QueryAccountResponse value) => value.writeToBuffer()));
    $addMethod(
        $grpc.ServiceMethod<$0.QueryParamsRequest, $0.QueryParamsResponse>(
            'Params',
            params_Pre,
            false,
            false,
            ($core.List<$core.int> value) =>
                $0.QueryParamsRequest.fromBuffer(value),
            ($0.QueryParamsResponse value) => value.writeToBuffer()));
  }

  $async.Future<$0.QueryAccountsResponse> accounts_Pre($grpc.ServiceCall call,
      $async.Future<$0.QueryAccountsRequest> request) async {
    return accounts(call, await request);
  }

  $async.Future<$0.QueryAccountResponse> account_Pre($grpc.ServiceCall call,
      $async.Future<$0.QueryAccountRequest> request) async {
    return account(call, await request);
  }

  $async.Future<$0.QueryParamsResponse> params_Pre($grpc.ServiceCall call,
      $async.Future<$0.QueryParamsRequest> request) async {
    return params(call, await request);
  }

  $async.Future<$0.QueryAccountsResponse> accounts(
      $grpc.ServiceCall call, $0.QueryAccountsRequest request);
  $async.Future<$0.QueryAccountResponse> account(
      $grpc.ServiceCall call, $0.QueryAccountRequest request);
  $async.Future<$0.QueryParamsResponse> params(
      $grpc.ServiceCall call, $0.QueryParamsRequest request);
}
