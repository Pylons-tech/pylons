///
//  Generated code. Do not modify.
//  source: ibc/core/client/v1/genesis.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'client.pb.dart' as $5;

class GenesisState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GenesisState',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.client.v1'),
      createEmptyInstance: create)
    ..pc<$5.IdentifiedClientState>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'clients',
        $pb.PbFieldType.PM,
        subBuilder: $5.IdentifiedClientState.create)
    ..pc<$5.ClientConsensusStates>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'clientsConsensus',
        $pb.PbFieldType.PM,
        subBuilder: $5.ClientConsensusStates.create)
    ..pc<IdentifiedGenesisMetadata>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'clientsMetadata',
        $pb.PbFieldType.PM,
        subBuilder: IdentifiedGenesisMetadata.create)
    ..aOM<$5.Params>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'params',
        subBuilder: $5.Params.create)
    ..aOB(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'createLocalhost')
    ..a<$fixnum.Int64>(
        6,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'nextClientSequence',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  GenesisState._() : super();
  factory GenesisState({
    $core.Iterable<$5.IdentifiedClientState>? clients,
    $core.Iterable<$5.ClientConsensusStates>? clientsConsensus,
    $core.Iterable<IdentifiedGenesisMetadata>? clientsMetadata,
    $5.Params? params,
    $core.bool? createLocalhost,
    $fixnum.Int64? nextClientSequence,
  }) {
    final _result = create();
    if (clients != null) {
      _result.clients.addAll(clients);
    }
    if (clientsConsensus != null) {
      _result.clientsConsensus.addAll(clientsConsensus);
    }
    if (clientsMetadata != null) {
      _result.clientsMetadata.addAll(clientsMetadata);
    }
    if (params != null) {
      _result.params = params;
    }
    if (createLocalhost != null) {
      _result.createLocalhost = createLocalhost;
    }
    if (nextClientSequence != null) {
      _result.nextClientSequence = nextClientSequence;
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
  $core.List<$5.IdentifiedClientState> get clients => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$5.ClientConsensusStates> get clientsConsensus => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<IdentifiedGenesisMetadata> get clientsMetadata => $_getList(2);

  @$pb.TagNumber(4)
  $5.Params get params => $_getN(3);
  @$pb.TagNumber(4)
  set params($5.Params v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasParams() => $_has(3);
  @$pb.TagNumber(4)
  void clearParams() => clearField(4);
  @$pb.TagNumber(4)
  $5.Params ensureParams() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get createLocalhost => $_getBF(4);
  @$pb.TagNumber(5)
  set createLocalhost($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasCreateLocalhost() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreateLocalhost() => clearField(5);

  @$pb.TagNumber(6)
  $fixnum.Int64 get nextClientSequence => $_getI64(5);
  @$pb.TagNumber(6)
  set nextClientSequence($fixnum.Int64 v) {
    $_setInt64(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasNextClientSequence() => $_has(5);
  @$pb.TagNumber(6)
  void clearNextClientSequence() => clearField(6);
}

class GenesisMetadata extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'GenesisMetadata',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.client.v1'),
      createEmptyInstance: create)
    ..a<$core.List<$core.int>>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'key',
        $pb.PbFieldType.OY)
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'value',
        $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  GenesisMetadata._() : super();
  factory GenesisMetadata({
    $core.List<$core.int>? key,
    $core.List<$core.int>? value,
  }) {
    final _result = create();
    if (key != null) {
      _result.key = key;
    }
    if (value != null) {
      _result.value = value;
    }
    return _result;
  }
  factory GenesisMetadata.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GenesisMetadata.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  GenesisMetadata clone() => GenesisMetadata()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  GenesisMetadata copyWith(void Function(GenesisMetadata) updates) =>
      super.copyWith((message) => updates(message as GenesisMetadata))
          as GenesisMetadata; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GenesisMetadata create() => GenesisMetadata._();
  GenesisMetadata createEmptyInstance() => create();
  static $pb.PbList<GenesisMetadata> createRepeated() =>
      $pb.PbList<GenesisMetadata>();
  @$core.pragma('dart2js:noInline')
  static GenesisMetadata getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GenesisMetadata>(create);
  static GenesisMetadata? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.int> get key => $_getN(0);
  @$pb.TagNumber(1)
  set key($core.List<$core.int> v) {
    $_setBytes(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearKey() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => clearField(2);
}

class IdentifiedGenesisMetadata extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'IdentifiedGenesisMetadata',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.client.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'clientId')
    ..pc<GenesisMetadata>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'clientMetadata',
        $pb.PbFieldType.PM,
        subBuilder: GenesisMetadata.create)
    ..hasRequiredFields = false;

  IdentifiedGenesisMetadata._() : super();
  factory IdentifiedGenesisMetadata({
    $core.String? clientId,
    $core.Iterable<GenesisMetadata>? clientMetadata,
  }) {
    final _result = create();
    if (clientId != null) {
      _result.clientId = clientId;
    }
    if (clientMetadata != null) {
      _result.clientMetadata.addAll(clientMetadata);
    }
    return _result;
  }
  factory IdentifiedGenesisMetadata.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory IdentifiedGenesisMetadata.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  IdentifiedGenesisMetadata clone() =>
      IdentifiedGenesisMetadata()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  IdentifiedGenesisMetadata copyWith(
          void Function(IdentifiedGenesisMetadata) updates) =>
      super.copyWith((message) => updates(message as IdentifiedGenesisMetadata))
          as IdentifiedGenesisMetadata; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static IdentifiedGenesisMetadata create() => IdentifiedGenesisMetadata._();
  IdentifiedGenesisMetadata createEmptyInstance() => create();
  static $pb.PbList<IdentifiedGenesisMetadata> createRepeated() =>
      $pb.PbList<IdentifiedGenesisMetadata>();
  @$core.pragma('dart2js:noInline')
  static IdentifiedGenesisMetadata getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IdentifiedGenesisMetadata>(create);
  static IdentifiedGenesisMetadata? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get clientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set clientId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasClientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<GenesisMetadata> get clientMetadata => $_getList(1);
}
