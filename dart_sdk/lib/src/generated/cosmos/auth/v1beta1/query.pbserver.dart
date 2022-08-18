///
//  Generated code. Do not modify.
//  source: cosmos/auth/v1beta1/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import 'query.pb.dart' as $3;
import 'query.pbjson.dart';

export 'query.pb.dart';

abstract class QueryServiceBase extends $pb.GeneratedService {
  $async.Future<$3.QueryAccountsResponse> accounts(
      $pb.ServerContext ctx, $3.QueryAccountsRequest request);
  $async.Future<$3.QueryAccountResponse> account(
      $pb.ServerContext ctx, $3.QueryAccountRequest request);
  $async.Future<$3.QueryParamsResponse> params(
      $pb.ServerContext ctx, $3.QueryParamsRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'Accounts':
        return $3.QueryAccountsRequest();
      case 'Account':
        return $3.QueryAccountRequest();
      case 'Params':
        return $3.QueryParamsRequest();
      default:
        throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'Accounts':
        return this.accounts(ctx, request as $3.QueryAccountsRequest);
      case 'Account':
        return this.account(ctx, request as $3.QueryAccountRequest);
      case 'Params':
        return this.params(ctx, request as $3.QueryParamsRequest);
      default:
        throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => QueryServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => QueryServiceBase$messageJson;
}
