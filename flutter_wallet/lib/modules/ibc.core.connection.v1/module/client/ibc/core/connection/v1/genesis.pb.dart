///
//  Generated code. Do not modify.
//  source: ibc/core/connection/v1/genesis.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'connection.pb.dart' as $4;

class GenesisState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GenesisState',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.connection.v1'),
      createEmptyInstance: create)
    ..pc<$4.IdentifiedConnection>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'connections',
        $pb.PbFieldType.PM,
        subBuilder: $4.IdentifiedConnection.create)
    ..pc<$4.ConnectionPaths>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'clientConnectionPaths',
        $pb.PbFieldType.PM,
        subBuilder: $4.ConnectionPaths.create)
    ..a<$fixnum.Int64>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nextConnectionSequence',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$4.Params>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'params',
        subBuilder: $4.Params.create)
    ..hasRequiredFields = false;

  GenesisState._() : super();
  factory GenesisState({
    $core.Iterable<$4.IdentifiedConnection>? connections,
    $core.Iterable<$4.ConnectionPaths>? clientConnectionPaths,
    $fixnum.Int64? nextConnectionSequence,
    $4.Params? params,
  }) {
    final _result = create();
    if (connections != null) {
      _result.connections.addAll(connections);
    }
    if (clientConnectionPaths != null) {
      _result.clientConnectionPaths.addAll(clientConnectionPaths);
    }
    if (nextConnectionSequence != null) {
      _result.nextConnectionSequence = nextConnectionSequence;
    }
    if (params != null) {
      _result.params = params;
    }
    return _result;
  }
  factory GenesisState.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GenesisState.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GenesisState clone() => GenesisState()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GenesisState copyWith(void Function(GenesisState) updates) =>
      super.copyWith((message) => updates(message as GenesisState))
          as GenesisState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GenesisState create() => GenesisState._();
  GenesisState createEmptyInstance() => create();
  static $pb.PbList<GenesisState> createRepeated() =>
      $pb.PbList<GenesisState>();
  @$core.pragma('dart2js:noInline')
  static GenesisState getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GenesisState>(create);
  static GenesisState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$4.IdentifiedConnection> get connections => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$4.ConnectionPaths> get clientConnectionPaths => $_getList(1);

  @$pb.TagNumber(3)
  $fixnum.Int64 get nextConnectionSequence => $_getI64(2);
  @$pb.TagNumber(3)
  set nextConnectionSequence($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasNextConnectionSequence() => $_has(2);
  @$pb.TagNumber(3)
  void clearNextConnectionSequence() => clearField(3);

  @$pb.TagNumber(4)
  $4.Params get params => $_getN(3);
  @$pb.TagNumber(4)
  set params($4.Params v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasParams() => $_has(3);
  @$pb.TagNumber(4)
  void clearParams() => clearField(4);
  @$pb.TagNumber(4)
  $4.Params ensureParams() => $_ensure(3);
}
