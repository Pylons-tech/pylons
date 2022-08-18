///
//  Generated code. Do not modify.
//  source: epochs/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'genesis.pb.dart' as $4;

class QueryEpochsInfoRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryEpochsInfoRequest',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'Pylonstech.pylons.epochs'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  QueryEpochsInfoRequest._() : super();
  factory QueryEpochsInfoRequest() => create();
  factory QueryEpochsInfoRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryEpochsInfoRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryEpochsInfoRequest clone() =>
      QueryEpochsInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryEpochsInfoRequest copyWith(
          void Function(QueryEpochsInfoRequest) updates) =>
      super.copyWith((message) => updates(message as QueryEpochsInfoRequest))
          as QueryEpochsInfoRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryEpochsInfoRequest create() => QueryEpochsInfoRequest._();
  QueryEpochsInfoRequest createEmptyInstance() => create();
  static $pb.PbList<QueryEpochsInfoRequest> createRepeated() =>
      $pb.PbList<QueryEpochsInfoRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryEpochsInfoRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryEpochsInfoRequest>(create);
  static QueryEpochsInfoRequest? _defaultInstance;
}

class QueryEpochsInfoResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryEpochsInfoResponse',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'Pylonstech.pylons.epochs'),
      createEmptyInstance: create)
    ..pc<$4.EpochInfo>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'epochs',
        $pb.PbFieldType.PM,
        subBuilder: $4.EpochInfo.create)
    ..hasRequiredFields = false;

  QueryEpochsInfoResponse._() : super();
  factory QueryEpochsInfoResponse({
    $core.Iterable<$4.EpochInfo>? epochs,
  }) {
    final _result = create();
    if (epochs != null) {
      _result.epochs.addAll(epochs);
    }
    return _result;
  }
  factory QueryEpochsInfoResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryEpochsInfoResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryEpochsInfoResponse clone() =>
      QueryEpochsInfoResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryEpochsInfoResponse copyWith(
          void Function(QueryEpochsInfoResponse) updates) =>
      super.copyWith((message) => updates(message as QueryEpochsInfoResponse))
          as QueryEpochsInfoResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryEpochsInfoResponse create() => QueryEpochsInfoResponse._();
  QueryEpochsInfoResponse createEmptyInstance() => create();
  static $pb.PbList<QueryEpochsInfoResponse> createRepeated() =>
      $pb.PbList<QueryEpochsInfoResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryEpochsInfoResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryEpochsInfoResponse>(create);
  static QueryEpochsInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$4.EpochInfo> get epochs => $_getList(0);
}

class QueryCurrentEpochRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryCurrentEpochRequest',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'Pylonstech.pylons.epochs'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'identifier')
    ..hasRequiredFields = false;

  QueryCurrentEpochRequest._() : super();
  factory QueryCurrentEpochRequest({
    $core.String? identifier,
  }) {
    final _result = create();
    if (identifier != null) {
      _result.identifier = identifier;
    }
    return _result;
  }
  factory QueryCurrentEpochRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryCurrentEpochRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryCurrentEpochRequest clone() =>
      QueryCurrentEpochRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryCurrentEpochRequest copyWith(
          void Function(QueryCurrentEpochRequest) updates) =>
      super.copyWith((message) => updates(message as QueryCurrentEpochRequest))
          as QueryCurrentEpochRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryCurrentEpochRequest create() => QueryCurrentEpochRequest._();
  QueryCurrentEpochRequest createEmptyInstance() => create();
  static $pb.PbList<QueryCurrentEpochRequest> createRepeated() =>
      $pb.PbList<QueryCurrentEpochRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryCurrentEpochRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryCurrentEpochRequest>(create);
  static QueryCurrentEpochRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get identifier => $_getSZ(0);
  @$pb.TagNumber(1)
  set identifier($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasIdentifier() => $_has(0);
  @$pb.TagNumber(1)
  void clearIdentifier() => clearField(1);
}

class QueryCurrentEpochResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryCurrentEpochResponse',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'Pylonstech.pylons.epochs'),
      createEmptyInstance: create)
    ..aInt64(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'currentEpoch')
    ..hasRequiredFields = false;

  QueryCurrentEpochResponse._() : super();
  factory QueryCurrentEpochResponse({
    $fixnum.Int64? currentEpoch,
  }) {
    final _result = create();
    if (currentEpoch != null) {
      _result.currentEpoch = currentEpoch;
    }
    return _result;
  }
  factory QueryCurrentEpochResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryCurrentEpochResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryCurrentEpochResponse clone() =>
      QueryCurrentEpochResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryCurrentEpochResponse copyWith(
          void Function(QueryCurrentEpochResponse) updates) =>
      super.copyWith((message) => updates(message as QueryCurrentEpochResponse))
          as QueryCurrentEpochResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryCurrentEpochResponse create() => QueryCurrentEpochResponse._();
  QueryCurrentEpochResponse createEmptyInstance() => create();
  static $pb.PbList<QueryCurrentEpochResponse> createRepeated() =>
      $pb.PbList<QueryCurrentEpochResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryCurrentEpochResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryCurrentEpochResponse>(create);
  static QueryCurrentEpochResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get currentEpoch => $_getI64(0);
  @$pb.TagNumber(1)
  set currentEpoch($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCurrentEpoch() => $_has(0);
  @$pb.TagNumber(1)
  void clearCurrentEpoch() => clearField(1);
}
