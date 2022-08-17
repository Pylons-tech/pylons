///
//  Generated code. Do not modify.
//  source: epochs/event.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../google/protobuf/timestamp.pb.dart' as $1;

class EventEndEpoch extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventEndEpoch', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.epochs'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentEpoch')
    ..hasRequiredFields = false
  ;

  EventEndEpoch._() : super();
  factory EventEndEpoch({
    $fixnum.Int64? currentEpoch,
  }) {
    final _result = create();
    if (currentEpoch != null) {
      _result.currentEpoch = currentEpoch;
    }
    return _result;
  }
  factory EventEndEpoch.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventEndEpoch.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventEndEpoch clone() => EventEndEpoch()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventEndEpoch copyWith(void Function(EventEndEpoch) updates) => super.copyWith((message) => updates(message as EventEndEpoch)) as EventEndEpoch; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventEndEpoch create() => EventEndEpoch._();
  EventEndEpoch createEmptyInstance() => create();
  static $pb.PbList<EventEndEpoch> createRepeated() => $pb.PbList<EventEndEpoch>();
  @$core.pragma('dart2js:noInline')
  static EventEndEpoch getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventEndEpoch>(create);
  static EventEndEpoch? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get currentEpoch => $_getI64(0);
  @$pb.TagNumber(1)
  set currentEpoch($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCurrentEpoch() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentEpoch() => clearField(1);
}

class EventBeginEpoch extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'EventBeginEpoch', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.epochs'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'currentEpoch')
    ..aOM<$1.Timestamp>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'startTime', subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false
  ;

  EventBeginEpoch._() : super();
  factory EventBeginEpoch({
    $fixnum.Int64? currentEpoch,
    $1.Timestamp? startTime,
  }) {
    final _result = create();
    if (currentEpoch != null) {
      _result.currentEpoch = currentEpoch;
    }
    if (startTime != null) {
      _result.startTime = startTime;
    }
    return _result;
  }
  factory EventBeginEpoch.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory EventBeginEpoch.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  EventBeginEpoch clone() => EventBeginEpoch()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  EventBeginEpoch copyWith(void Function(EventBeginEpoch) updates) => super.copyWith((message) => updates(message as EventBeginEpoch)) as EventBeginEpoch; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static EventBeginEpoch create() => EventBeginEpoch._();
  EventBeginEpoch createEmptyInstance() => create();
  static $pb.PbList<EventBeginEpoch> createRepeated() => $pb.PbList<EventBeginEpoch>();
  @$core.pragma('dart2js:noInline')
  static EventBeginEpoch getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventBeginEpoch>(create);
  static EventBeginEpoch? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get currentEpoch => $_getI64(0);
  @$pb.TagNumber(1)
  set currentEpoch($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCurrentEpoch() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentEpoch() => clearField(1);

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
}

