///
//  Generated code. Do not modify.
//  source: cosmos/tx/v1beta1/service.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields,deprecated_member_use_from_same_package

import 'dart:async' as $async;

import 'package:protobuf/protobuf.dart' as $pb;

import 'dart:core' as $core;
import 'service.pb.dart' as $8;
import 'service.pbjson.dart';

export 'service.pb.dart';

abstract class ServiceBase extends $pb.GeneratedService {
  $async.Future<$8.SimulateResponse> simulate(
      $pb.ServerContext ctx, $8.SimulateRequest request);
  $async.Future<$8.GetTxResponse> getTx(
      $pb.ServerContext ctx, $8.GetTxRequest request);
  $async.Future<$8.BroadcastTxResponse> broadcastTx(
      $pb.ServerContext ctx, $8.BroadcastTxRequest request);
  $async.Future<$8.GetTxsEventResponse> getTxsEvent(
      $pb.ServerContext ctx, $8.GetTxsEventRequest request);

  $pb.GeneratedMessage createRequest($core.String method) {
    switch (method) {
      case 'Simulate':
        return $8.SimulateRequest();
      case 'GetTx':
        return $8.GetTxRequest();
      case 'BroadcastTx':
        return $8.BroadcastTxRequest();
      case 'GetTxsEvent':
        return $8.GetTxsEventRequest();
      default:
        throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall($pb.ServerContext ctx,
      $core.String method, $pb.GeneratedMessage request) {
    switch (method) {
      case 'Simulate':
        return this.simulate(ctx, request as $8.SimulateRequest);
      case 'GetTx':
        return this.getTx(ctx, request as $8.GetTxRequest);
      case 'BroadcastTx':
        return this.broadcastTx(ctx, request as $8.BroadcastTxRequest);
      case 'GetTxsEvent':
        return this.getTxsEvent(ctx, request as $8.GetTxsEventRequest);
      default:
        throw $core.ArgumentError('Unknown method: $method');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => ServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
      get $messageJson => ServiceBase$messageJson;
}
