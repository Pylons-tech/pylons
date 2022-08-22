///
//  Generated code. Do not modify.
//  source: ibc/core/port/v1/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import '../../channel/v1/channel.pb.dart' as $5;

import '../../channel/v1/channel.pbenum.dart' as $5;

class QueryAppVersionRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryAppVersionRequest',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.port.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'portId')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'connectionId')
    ..e<$5.Order>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'ordering',
        $pb.PbFieldType.OE,
        defaultOrMaker: $5.Order.ORDER_NONE_UNSPECIFIED,
        valueOf: $5.Order.valueOf,
        enumValues: $5.Order.values)
    ..aOM<$5.Counterparty>(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'counterparty',
        subBuilder: $5.Counterparty.create)
    ..aOS(
        5,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proposedVersion')
    ..hasRequiredFields = false;

  QueryAppVersionRequest._() : super();
  factory QueryAppVersionRequest({
    $core.String? portId,
    $core.String? connectionId,
    $5.Order? ordering,
    $5.Counterparty? counterparty,
    $core.String? proposedVersion,
  }) {
    final _result = create();
    if (portId != null) {
      _result.portId = portId;
    }
    if (connectionId != null) {
      _result.connectionId = connectionId;
    }
    if (ordering != null) {
      _result.ordering = ordering;
    }
    if (counterparty != null) {
      _result.counterparty = counterparty;
    }
    if (proposedVersion != null) {
      _result.proposedVersion = proposedVersion;
    }
    return _result;
  }
  factory QueryAppVersionRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryAppVersionRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryAppVersionRequest clone() =>
      QueryAppVersionRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryAppVersionRequest copyWith(
          void Function(QueryAppVersionRequest) updates) =>
      super.copyWith((message) => updates(message as QueryAppVersionRequest))
          as QueryAppVersionRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryAppVersionRequest create() => QueryAppVersionRequest._();
  QueryAppVersionRequest createEmptyInstance() => create();
  static $pb.PbList<QueryAppVersionRequest> createRepeated() =>
      $pb.PbList<QueryAppVersionRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryAppVersionRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryAppVersionRequest>(create);
  static QueryAppVersionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get portId => $_getSZ(0);
  @$pb.TagNumber(1)
  set portId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPortId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPortId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get connectionId => $_getSZ(1);
  @$pb.TagNumber(2)
  set connectionId($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasConnectionId() => $_has(1);
  @$pb.TagNumber(2)
  void clearConnectionId() => clearField(2);

  @$pb.TagNumber(3)
  $5.Order get ordering => $_getN(2);
  @$pb.TagNumber(3)
  set ordering($5.Order v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasOrdering() => $_has(2);
  @$pb.TagNumber(3)
  void clearOrdering() => clearField(3);

  @$pb.TagNumber(4)
  $5.Counterparty get counterparty => $_getN(3);
  @$pb.TagNumber(4)
  set counterparty($5.Counterparty v) {
    setField(4, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasCounterparty() => $_has(3);
  @$pb.TagNumber(4)
  void clearCounterparty() => clearField(4);
  @$pb.TagNumber(4)
  $5.Counterparty ensureCounterparty() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get proposedVersion => $_getSZ(4);
  @$pb.TagNumber(5)
  set proposedVersion($core.String v) {
    $_setString(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasProposedVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearProposedVersion() => clearField(5);
}

class QueryAppVersionResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryAppVersionResponse',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.port.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'portId')
    ..aOS(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'version')
    ..hasRequiredFields = false;

  QueryAppVersionResponse._() : super();
  factory QueryAppVersionResponse({
    $core.String? portId,
    $core.String? version,
  }) {
    final _result = create();
    if (portId != null) {
      _result.portId = portId;
    }
    if (version != null) {
      _result.version = version;
    }
    return _result;
  }
  factory QueryAppVersionResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryAppVersionResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryAppVersionResponse clone() =>
      QueryAppVersionResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryAppVersionResponse copyWith(
          void Function(QueryAppVersionResponse) updates) =>
      super.copyWith((message) => updates(message as QueryAppVersionResponse))
          as QueryAppVersionResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryAppVersionResponse create() => QueryAppVersionResponse._();
  QueryAppVersionResponse createEmptyInstance() => create();
  static $pb.PbList<QueryAppVersionResponse> createRepeated() =>
      $pb.PbList<QueryAppVersionResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryAppVersionResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryAppVersionResponse>(create);
  static QueryAppVersionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get portId => $_getSZ(0);
  @$pb.TagNumber(1)
  set portId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPortId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPortId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get version => $_getSZ(1);
  @$pb.TagNumber(2)
  set version($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasVersion() => $_has(1);
  @$pb.TagNumber(2)
  void clearVersion() => clearField(2);
}
