///
//  Generated code. Do not modify.
//  source: epochs/genesis.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../google/protobuf/timestamp.pb.dart' as $1;
import '../google/protobuf/duration.pb.dart' as $2;

class EpochInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EpochInfo', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.epochs'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'identifier')
    ..aOM<$1.Timestamp>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'startTime', subBuilder: $1.Timestamp.create)
    ..aOM<$2.Duration>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'duration', subBuilder: $2.Duration.create)
    ..aInt64(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentEpoch')
    ..aOM<$1.Timestamp>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentEpochStartTime', subBuilder: $1.Timestamp.create)
    ..aOB(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'epochCountingStarted')
    ..hasRequiredFields = false
  ;

  EpochInfo._() : super();
  factory EpochInfo({
    $core.String? identifier,
    $1.Timestamp? startTime,
    $2.Duration? duration,
    $fixnum.Int64? currentEpoch,
    $1.Timestamp? currentEpochStartTime,
    $core.bool? epochCountingStarted,
  }) {
    final _result = create();
    if (identifier != null) {
      _result.identifier = identifier;
    }
    if (startTime != null) {
      _result.startTime = startTime;
    }
    if (duration != null) {
      _result.duration = duration;
    }
    if (currentEpoch != null) {
      _result.currentEpoch = currentEpoch;
    }
    if (currentEpochStartTime != null) {
      _result.currentEpochStartTime = currentEpochStartTime;
    }
    if (epochCountingStarted != null) {
      _result.epochCountingStarted = epochCountingStarted;
    }
    return _result;
  }
  factory EpochInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EpochInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EpochInfo clone() => EpochInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EpochInfo copyWith(void Function(EpochInfo) updates) => super.copyWith((message) => updates(message as EpochInfo)) as EpochInfo; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EpochInfo create() => EpochInfo._();
  EpochInfo createEmptyInstance() => create();
  static $pb.PbList<EpochInfo> createRepeated() => $pb.PbList<EpochInfo>();
  @$core.pragma('dart2js:noInline')
  static EpochInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EpochInfo>(create);
  static EpochInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get identifier => $_getSZ(0);
  @$pb.TagNumber(1)
  set identifier($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIdentifier() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdentifier() => clearField(1);

  @$pb.TagNumber(2)
  $1.Timestamp get startTime => $_getN(1);
  @$pb.TagNumber(2)
  set startTime($1.Timestamp v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasStartTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearStartTime() => clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureStartTime() => $_ensure(1);

  @$pb.TagNumber(3)
  $2.Duration get duration => $_getN(2);
  @$pb.TagNumber(3)
  set duration($2.Duration v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasDuration() => $_has(2);
  @$pb.TagNumber(3)
  void clearDuration() => clearField(3);
  @$pb.TagNumber(3)
  $2.Duration ensureDuration() => $_ensure(2);

  @$pb.TagNumber(4)
  $fixnum.Int64 get currentEpoch => $_getI64(3);
  @$pb.TagNumber(4)
  set currentEpoch($fixnum.Int64 v) { $_setInt64(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCurrentEpoch() => $_has(3);
  @$pb.TagNumber(4)
  void clearCurrentEpoch() => clearField(4);

  @$pb.TagNumber(5)
  $1.Timestamp get currentEpochStartTime => $_getN(4);
  @$pb.TagNumber(5)
  set currentEpochStartTime($1.Timestamp v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCurrentEpochStartTime() => $_has(4);
  @$pb.TagNumber(5)
  void clearCurrentEpochStartTime() => clearField(5);
  @$pb.TagNumber(5)
  $1.Timestamp ensureCurrentEpochStartTime() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.bool get epochCountingStarted => $_getBF(5);
  @$pb.TagNumber(6)
  set epochCountingStarted($core.bool v) { $_setBool(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasEpochCountingStarted() => $_has(5);
  @$pb.TagNumber(6)
  void clearEpochCountingStarted() => clearField(6);
}

class GenesisState extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GenesisState', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.epochs'), createEmptyInstance: create)
    ..pc<EpochInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'epochs', $pb.PbFieldType.PM, subBuilder: EpochInfo.create)
    ..hasRequiredFields = false
  ;

  GenesisState._() : super();
  factory GenesisState({
    $core.Iterable<EpochInfo>? epochs,
  }) {
    final _result = create();
    if (epochs != null) {
      _result.epochs.addAll(epochs);
    }
    return _result;
  }
  factory GenesisState.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GenesisState.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GenesisState clone() => GenesisState()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GenesisState copyWith(void Function(GenesisState) updates) => super.copyWith((message) => updates(message as GenesisState)) as GenesisState; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GenesisState create() => GenesisState._();
  GenesisState createEmptyInstance() => create();
  static $pb.PbList<GenesisState> createRepeated() => $pb.PbList<GenesisState>();
  @$core.pragma('dart2js:noInline')
  static GenesisState getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GenesisState>(create);
  static GenesisState? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<EpochInfo> get epochs => $_getList(0);
}

