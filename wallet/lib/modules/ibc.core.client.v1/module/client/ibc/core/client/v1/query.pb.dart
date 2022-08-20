///
//  Generated code. Do not modify.
//  source: ibc/core/client/v1/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../../../../google/protobuf/any.pb.dart' as $3;
import 'client.pb.dart' as $5;
import '../../../../cosmos/base/query/v1beta1/pagination.pb.dart' as $7;

class QueryClientStateRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryClientStateRequest',
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
    ..hasRequiredFields = false;

  QueryClientStateRequest._() : super();
  factory QueryClientStateRequest({
    $core.String? clientId,
  }) {
    final _result = create();
    if (clientId != null) {
      _result.clientId = clientId;
    }
    return _result;
  }
  factory QueryClientStateRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryClientStateRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryClientStateRequest clone() =>
      QueryClientStateRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryClientStateRequest copyWith(
          void Function(QueryClientStateRequest) updates) =>
      super.copyWith((message) => updates(message as QueryClientStateRequest))
          as QueryClientStateRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryClientStateRequest create() => QueryClientStateRequest._();
  QueryClientStateRequest createEmptyInstance() => create();
  static $pb.PbList<QueryClientStateRequest> createRepeated() =>
      $pb.PbList<QueryClientStateRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryClientStateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryClientStateRequest>(create);
  static QueryClientStateRequest? _defaultInstance;

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
}

class QueryClientStateResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryClientStateResponse',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.client.v1'),
      createEmptyInstance: create)
    ..aOM<$3.Any>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'clientState',
        subBuilder: $3.Any.create)
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proof',
        $pb.PbFieldType.OY)
    ..aOM<$5.Height>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proofHeight',
        subBuilder: $5.Height.create)
    ..hasRequiredFields = false;

  QueryClientStateResponse._() : super();
  factory QueryClientStateResponse({
    $3.Any? clientState,
    $core.List<$core.int>? proof,
    $5.Height? proofHeight,
  }) {
    final _result = create();
    if (clientState != null) {
      _result.clientState = clientState;
    }
    if (proof != null) {
      _result.proof = proof;
    }
    if (proofHeight != null) {
      _result.proofHeight = proofHeight;
    }
    return _result;
  }
  factory QueryClientStateResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryClientStateResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryClientStateResponse clone() =>
      QueryClientStateResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryClientStateResponse copyWith(
          void Function(QueryClientStateResponse) updates) =>
      super.copyWith((message) => updates(message as QueryClientStateResponse))
          as QueryClientStateResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryClientStateResponse create() => QueryClientStateResponse._();
  QueryClientStateResponse createEmptyInstance() => create();
  static $pb.PbList<QueryClientStateResponse> createRepeated() =>
      $pb.PbList<QueryClientStateResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryClientStateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryClientStateResponse>(create);
  static QueryClientStateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Any get clientState => $_getN(0);
  @$pb.TagNumber(1)
  set clientState($3.Any v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasClientState() => $_has(0);
  @$pb.TagNumber(1)
  void clearClientState() => clearField(1);
  @$pb.TagNumber(1)
  $3.Any ensureClientState() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get proof => $_getN(1);
  @$pb.TagNumber(2)
  set proof($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasProof() => $_has(1);
  @$pb.TagNumber(2)
  void clearProof() => clearField(2);

  @$pb.TagNumber(3)
  $5.Height get proofHeight => $_getN(2);
  @$pb.TagNumber(3)
  set proofHeight($5.Height v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasProofHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearProofHeight() => clearField(3);
  @$pb.TagNumber(3)
  $5.Height ensureProofHeight() => $_ensure(2);
}

class QueryClientStatesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryClientStatesRequest',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.client.v1'),
      createEmptyInstance: create)
    ..aOM<$7.PageRequest>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pagination',
        subBuilder: $7.PageRequest.create)
    ..hasRequiredFields = false;

  QueryClientStatesRequest._() : super();
  factory QueryClientStatesRequest({
    $7.PageRequest? pagination,
  }) {
    final _result = create();
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryClientStatesRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryClientStatesRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryClientStatesRequest clone() =>
      QueryClientStatesRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryClientStatesRequest copyWith(
          void Function(QueryClientStatesRequest) updates) =>
      super.copyWith((message) => updates(message as QueryClientStatesRequest))
          as QueryClientStatesRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryClientStatesRequest create() => QueryClientStatesRequest._();
  QueryClientStatesRequest createEmptyInstance() => create();
  static $pb.PbList<QueryClientStatesRequest> createRepeated() =>
      $pb.PbList<QueryClientStatesRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryClientStatesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryClientStatesRequest>(create);
  static QueryClientStatesRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $7.PageRequest get pagination => $_getN(0);
  @$pb.TagNumber(1)
  set pagination($7.PageRequest v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPagination() => $_has(0);
  @$pb.TagNumber(1)
  void clearPagination() => clearField(1);
  @$pb.TagNumber(1)
  $7.PageRequest ensurePagination() => $_ensure(0);
}

class QueryClientStatesResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryClientStatesResponse',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.client.v1'),
      createEmptyInstance: create)
    ..pc<$5.IdentifiedClientState>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'clientStates',
        $pb.PbFieldType.PM,
        subBuilder: $5.IdentifiedClientState.create)
    ..aOM<$7.PageResponse>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pagination',
        subBuilder: $7.PageResponse.create)
    ..hasRequiredFields = false;

  QueryClientStatesResponse._() : super();
  factory QueryClientStatesResponse({
    $core.Iterable<$5.IdentifiedClientState>? clientStates,
    $7.PageResponse? pagination,
  }) {
    final _result = create();
    if (clientStates != null) {
      _result.clientStates.addAll(clientStates);
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryClientStatesResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryClientStatesResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryClientStatesResponse clone() =>
      QueryClientStatesResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryClientStatesResponse copyWith(
          void Function(QueryClientStatesResponse) updates) =>
      super.copyWith((message) => updates(message as QueryClientStatesResponse))
          as QueryClientStatesResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryClientStatesResponse create() => QueryClientStatesResponse._();
  QueryClientStatesResponse createEmptyInstance() => create();
  static $pb.PbList<QueryClientStatesResponse> createRepeated() =>
      $pb.PbList<QueryClientStatesResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryClientStatesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryClientStatesResponse>(create);
  static QueryClientStatesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$5.IdentifiedClientState> get clientStates => $_getList(0);

  @$pb.TagNumber(2)
  $7.PageResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($7.PageResponse v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => clearField(2);
  @$pb.TagNumber(2)
  $7.PageResponse ensurePagination() => $_ensure(1);
}

class QueryConsensusStateRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryConsensusStateRequest',
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
    ..a<$fixnum.Int64>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'revisionNumber',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'revisionHeight',
        $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOB(
        4,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'latestHeight')
    ..hasRequiredFields = false;

  QueryConsensusStateRequest._() : super();
  factory QueryConsensusStateRequest({
    $core.String? clientId,
    $fixnum.Int64? revisionNumber,
    $fixnum.Int64? revisionHeight,
    $core.bool? latestHeight,
  }) {
    final _result = create();
    if (clientId != null) {
      _result.clientId = clientId;
    }
    if (revisionNumber != null) {
      _result.revisionNumber = revisionNumber;
    }
    if (revisionHeight != null) {
      _result.revisionHeight = revisionHeight;
    }
    if (latestHeight != null) {
      _result.latestHeight = latestHeight;
    }
    return _result;
  }
  factory QueryConsensusStateRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryConsensusStateRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryConsensusStateRequest clone() =>
      QueryConsensusStateRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryConsensusStateRequest copyWith(
          void Function(QueryConsensusStateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as QueryConsensusStateRequest))
          as QueryConsensusStateRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryConsensusStateRequest create() => QueryConsensusStateRequest._();
  QueryConsensusStateRequest createEmptyInstance() => create();
  static $pb.PbList<QueryConsensusStateRequest> createRepeated() =>
      $pb.PbList<QueryConsensusStateRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryConsensusStateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryConsensusStateRequest>(create);
  static QueryConsensusStateRequest? _defaultInstance;

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
  $fixnum.Int64 get revisionNumber => $_getI64(1);
  @$pb.TagNumber(2)
  set revisionNumber($fixnum.Int64 v) {
    $_setInt64(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRevisionNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearRevisionNumber() => clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get revisionHeight => $_getI64(2);
  @$pb.TagNumber(3)
  set revisionHeight($fixnum.Int64 v) {
    $_setInt64(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasRevisionHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearRevisionHeight() => clearField(3);

  @$pb.TagNumber(4)
  $core.bool get latestHeight => $_getBF(3);
  @$pb.TagNumber(4)
  set latestHeight($core.bool v) {
    $_setBool(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasLatestHeight() => $_has(3);
  @$pb.TagNumber(4)
  void clearLatestHeight() => clearField(4);
}

class QueryConsensusStateResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryConsensusStateResponse',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.client.v1'),
      createEmptyInstance: create)
    ..aOM<$3.Any>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'consensusState',
        subBuilder: $3.Any.create)
    ..a<$core.List<$core.int>>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proof',
        $pb.PbFieldType.OY)
    ..aOM<$5.Height>(
        3,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'proofHeight',
        subBuilder: $5.Height.create)
    ..hasRequiredFields = false;

  QueryConsensusStateResponse._() : super();
  factory QueryConsensusStateResponse({
    $3.Any? consensusState,
    $core.List<$core.int>? proof,
    $5.Height? proofHeight,
  }) {
    final _result = create();
    if (consensusState != null) {
      _result.consensusState = consensusState;
    }
    if (proof != null) {
      _result.proof = proof;
    }
    if (proofHeight != null) {
      _result.proofHeight = proofHeight;
    }
    return _result;
  }
  factory QueryConsensusStateResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryConsensusStateResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryConsensusStateResponse clone() =>
      QueryConsensusStateResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryConsensusStateResponse copyWith(
          void Function(QueryConsensusStateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as QueryConsensusStateResponse))
          as QueryConsensusStateResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryConsensusStateResponse create() =>
      QueryConsensusStateResponse._();
  QueryConsensusStateResponse createEmptyInstance() => create();
  static $pb.PbList<QueryConsensusStateResponse> createRepeated() =>
      $pb.PbList<QueryConsensusStateResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryConsensusStateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryConsensusStateResponse>(create);
  static QueryConsensusStateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Any get consensusState => $_getN(0);
  @$pb.TagNumber(1)
  set consensusState($3.Any v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasConsensusState() => $_has(0);
  @$pb.TagNumber(1)
  void clearConsensusState() => clearField(1);
  @$pb.TagNumber(1)
  $3.Any ensureConsensusState() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<$core.int> get proof => $_getN(1);
  @$pb.TagNumber(2)
  set proof($core.List<$core.int> v) {
    $_setBytes(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasProof() => $_has(1);
  @$pb.TagNumber(2)
  void clearProof() => clearField(2);

  @$pb.TagNumber(3)
  $5.Height get proofHeight => $_getN(2);
  @$pb.TagNumber(3)
  set proofHeight($5.Height v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasProofHeight() => $_has(2);
  @$pb.TagNumber(3)
  void clearProofHeight() => clearField(3);
  @$pb.TagNumber(3)
  $5.Height ensureProofHeight() => $_ensure(2);
}

class QueryConsensusStatesRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryConsensusStatesRequest',
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
    ..aOM<$7.PageRequest>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pagination',
        subBuilder: $7.PageRequest.create)
    ..hasRequiredFields = false;

  QueryConsensusStatesRequest._() : super();
  factory QueryConsensusStatesRequest({
    $core.String? clientId,
    $7.PageRequest? pagination,
  }) {
    final _result = create();
    if (clientId != null) {
      _result.clientId = clientId;
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryConsensusStatesRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryConsensusStatesRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryConsensusStatesRequest clone() =>
      QueryConsensusStatesRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryConsensusStatesRequest copyWith(
          void Function(QueryConsensusStatesRequest) updates) =>
      super.copyWith(
              (message) => updates(message as QueryConsensusStatesRequest))
          as QueryConsensusStatesRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryConsensusStatesRequest create() =>
      QueryConsensusStatesRequest._();
  QueryConsensusStatesRequest createEmptyInstance() => create();
  static $pb.PbList<QueryConsensusStatesRequest> createRepeated() =>
      $pb.PbList<QueryConsensusStatesRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryConsensusStatesRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryConsensusStatesRequest>(create);
  static QueryConsensusStatesRequest? _defaultInstance;

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
  $7.PageRequest get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($7.PageRequest v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => clearField(2);
  @$pb.TagNumber(2)
  $7.PageRequest ensurePagination() => $_ensure(1);
}

class QueryConsensusStatesResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryConsensusStatesResponse',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.client.v1'),
      createEmptyInstance: create)
    ..pc<$5.ConsensusStateWithHeight>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'consensusStates',
        $pb.PbFieldType.PM,
        subBuilder: $5.ConsensusStateWithHeight.create)
    ..aOM<$7.PageResponse>(
        2,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'pagination',
        subBuilder: $7.PageResponse.create)
    ..hasRequiredFields = false;

  QueryConsensusStatesResponse._() : super();
  factory QueryConsensusStatesResponse({
    $core.Iterable<$5.ConsensusStateWithHeight>? consensusStates,
    $7.PageResponse? pagination,
  }) {
    final _result = create();
    if (consensusStates != null) {
      _result.consensusStates.addAll(consensusStates);
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryConsensusStatesResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryConsensusStatesResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryConsensusStatesResponse clone() =>
      QueryConsensusStatesResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryConsensusStatesResponse copyWith(
          void Function(QueryConsensusStatesResponse) updates) =>
      super.copyWith(
              (message) => updates(message as QueryConsensusStatesResponse))
          as QueryConsensusStatesResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryConsensusStatesResponse create() =>
      QueryConsensusStatesResponse._();
  QueryConsensusStatesResponse createEmptyInstance() => create();
  static $pb.PbList<QueryConsensusStatesResponse> createRepeated() =>
      $pb.PbList<QueryConsensusStatesResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryConsensusStatesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryConsensusStatesResponse>(create);
  static QueryConsensusStatesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$5.ConsensusStateWithHeight> get consensusStates => $_getList(0);

  @$pb.TagNumber(2)
  $7.PageResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($7.PageResponse v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => clearField(2);
  @$pb.TagNumber(2)
  $7.PageResponse ensurePagination() => $_ensure(1);
}

class QueryClientStatusRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryClientStatusRequest',
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
    ..hasRequiredFields = false;

  QueryClientStatusRequest._() : super();
  factory QueryClientStatusRequest({
    $core.String? clientId,
  }) {
    final _result = create();
    if (clientId != null) {
      _result.clientId = clientId;
    }
    return _result;
  }
  factory QueryClientStatusRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryClientStatusRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryClientStatusRequest clone() =>
      QueryClientStatusRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryClientStatusRequest copyWith(
          void Function(QueryClientStatusRequest) updates) =>
      super.copyWith((message) => updates(message as QueryClientStatusRequest))
          as QueryClientStatusRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryClientStatusRequest create() => QueryClientStatusRequest._();
  QueryClientStatusRequest createEmptyInstance() => create();
  static $pb.PbList<QueryClientStatusRequest> createRepeated() =>
      $pb.PbList<QueryClientStatusRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryClientStatusRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryClientStatusRequest>(create);
  static QueryClientStatusRequest? _defaultInstance;

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
}

class QueryClientStatusResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryClientStatusResponse',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.client.v1'),
      createEmptyInstance: create)
    ..aOS(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'status')
    ..hasRequiredFields = false;

  QueryClientStatusResponse._() : super();
  factory QueryClientStatusResponse({
    $core.String? status,
  }) {
    final _result = create();
    if (status != null) {
      _result.status = status;
    }
    return _result;
  }
  factory QueryClientStatusResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryClientStatusResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryClientStatusResponse clone() =>
      QueryClientStatusResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryClientStatusResponse copyWith(
          void Function(QueryClientStatusResponse) updates) =>
      super.copyWith((message) => updates(message as QueryClientStatusResponse))
          as QueryClientStatusResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryClientStatusResponse create() => QueryClientStatusResponse._();
  QueryClientStatusResponse createEmptyInstance() => create();
  static $pb.PbList<QueryClientStatusResponse> createRepeated() =>
      $pb.PbList<QueryClientStatusResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryClientStatusResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryClientStatusResponse>(create);
  static QueryClientStatusResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get status => $_getSZ(0);
  @$pb.TagNumber(1)
  set status($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearStatus() => clearField(1);
}

class QueryClientParamsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryClientParamsRequest',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.client.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  QueryClientParamsRequest._() : super();
  factory QueryClientParamsRequest() => create();
  factory QueryClientParamsRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryClientParamsRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryClientParamsRequest clone() =>
      QueryClientParamsRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryClientParamsRequest copyWith(
          void Function(QueryClientParamsRequest) updates) =>
      super.copyWith((message) => updates(message as QueryClientParamsRequest))
          as QueryClientParamsRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryClientParamsRequest create() => QueryClientParamsRequest._();
  QueryClientParamsRequest createEmptyInstance() => create();
  static $pb.PbList<QueryClientParamsRequest> createRepeated() =>
      $pb.PbList<QueryClientParamsRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryClientParamsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryClientParamsRequest>(create);
  static QueryClientParamsRequest? _defaultInstance;
}

class QueryClientParamsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryClientParamsResponse',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.client.v1'),
      createEmptyInstance: create)
    ..aOM<$5.Params>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'params',
        subBuilder: $5.Params.create)
    ..hasRequiredFields = false;

  QueryClientParamsResponse._() : super();
  factory QueryClientParamsResponse({
    $5.Params? params,
  }) {
    final _result = create();
    if (params != null) {
      _result.params = params;
    }
    return _result;
  }
  factory QueryClientParamsResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryClientParamsResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryClientParamsResponse clone() =>
      QueryClientParamsResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryClientParamsResponse copyWith(
          void Function(QueryClientParamsResponse) updates) =>
      super.copyWith((message) => updates(message as QueryClientParamsResponse))
          as QueryClientParamsResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryClientParamsResponse create() => QueryClientParamsResponse._();
  QueryClientParamsResponse createEmptyInstance() => create();
  static $pb.PbList<QueryClientParamsResponse> createRepeated() =>
      $pb.PbList<QueryClientParamsResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryClientParamsResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryClientParamsResponse>(create);
  static QueryClientParamsResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $5.Params get params => $_getN(0);
  @$pb.TagNumber(1)
  set params($5.Params v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasParams() => $_has(0);
  @$pb.TagNumber(1)
  void clearParams() => clearField(1);
  @$pb.TagNumber(1)
  $5.Params ensureParams() => $_ensure(0);
}

class QueryUpgradedClientStateRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryUpgradedClientStateRequest',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.client.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  QueryUpgradedClientStateRequest._() : super();
  factory QueryUpgradedClientStateRequest() => create();
  factory QueryUpgradedClientStateRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryUpgradedClientStateRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryUpgradedClientStateRequest clone() =>
      QueryUpgradedClientStateRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryUpgradedClientStateRequest copyWith(
          void Function(QueryUpgradedClientStateRequest) updates) =>
      super.copyWith(
              (message) => updates(message as QueryUpgradedClientStateRequest))
          as QueryUpgradedClientStateRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryUpgradedClientStateRequest create() =>
      QueryUpgradedClientStateRequest._();
  QueryUpgradedClientStateRequest createEmptyInstance() => create();
  static $pb.PbList<QueryUpgradedClientStateRequest> createRepeated() =>
      $pb.PbList<QueryUpgradedClientStateRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryUpgradedClientStateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryUpgradedClientStateRequest>(
          create);
  static QueryUpgradedClientStateRequest? _defaultInstance;
}

class QueryUpgradedClientStateResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryUpgradedClientStateResponse',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.client.v1'),
      createEmptyInstance: create)
    ..aOM<$3.Any>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'upgradedClientState',
        subBuilder: $3.Any.create)
    ..hasRequiredFields = false;

  QueryUpgradedClientStateResponse._() : super();
  factory QueryUpgradedClientStateResponse({
    $3.Any? upgradedClientState,
  }) {
    final _result = create();
    if (upgradedClientState != null) {
      _result.upgradedClientState = upgradedClientState;
    }
    return _result;
  }
  factory QueryUpgradedClientStateResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryUpgradedClientStateResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryUpgradedClientStateResponse clone() =>
      QueryUpgradedClientStateResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryUpgradedClientStateResponse copyWith(
          void Function(QueryUpgradedClientStateResponse) updates) =>
      super.copyWith(
              (message) => updates(message as QueryUpgradedClientStateResponse))
          as QueryUpgradedClientStateResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryUpgradedClientStateResponse create() =>
      QueryUpgradedClientStateResponse._();
  QueryUpgradedClientStateResponse createEmptyInstance() => create();
  static $pb.PbList<QueryUpgradedClientStateResponse> createRepeated() =>
      $pb.PbList<QueryUpgradedClientStateResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryUpgradedClientStateResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryUpgradedClientStateResponse>(
          create);
  static QueryUpgradedClientStateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Any get upgradedClientState => $_getN(0);
  @$pb.TagNumber(1)
  set upgradedClientState($3.Any v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUpgradedClientState() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpgradedClientState() => clearField(1);
  @$pb.TagNumber(1)
  $3.Any ensureUpgradedClientState() => $_ensure(0);
}

class QueryUpgradedConsensusStateRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryUpgradedConsensusStateRequest',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.client.v1'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;

  QueryUpgradedConsensusStateRequest._() : super();
  factory QueryUpgradedConsensusStateRequest() => create();
  factory QueryUpgradedConsensusStateRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryUpgradedConsensusStateRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryUpgradedConsensusStateRequest clone() =>
      QueryUpgradedConsensusStateRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryUpgradedConsensusStateRequest copyWith(
          void Function(QueryUpgradedConsensusStateRequest) updates) =>
      super.copyWith((message) =>
              updates(message as QueryUpgradedConsensusStateRequest))
          as QueryUpgradedConsensusStateRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryUpgradedConsensusStateRequest create() =>
      QueryUpgradedConsensusStateRequest._();
  QueryUpgradedConsensusStateRequest createEmptyInstance() => create();
  static $pb.PbList<QueryUpgradedConsensusStateRequest> createRepeated() =>
      $pb.PbList<QueryUpgradedConsensusStateRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryUpgradedConsensusStateRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<QueryUpgradedConsensusStateRequest>(
          create);
  static QueryUpgradedConsensusStateRequest? _defaultInstance;
}

class QueryUpgradedConsensusStateResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      const $core.bool.fromEnvironment('protobuf.omit_message_names')
          ? ''
          : 'QueryUpgradedConsensusStateResponse',
      package: const $pb.PackageName(
          $core.bool.fromEnvironment('protobuf.omit_message_names')
              ? ''
              : 'ibc.core.client.v1'),
      createEmptyInstance: create)
    ..aOM<$3.Any>(
        1,
        const $core.bool.fromEnvironment('protobuf.omit_field_names')
            ? ''
            : 'upgradedConsensusState',
        subBuilder: $3.Any.create)
    ..hasRequiredFields = false;

  QueryUpgradedConsensusStateResponse._() : super();
  factory QueryUpgradedConsensusStateResponse({
    $3.Any? upgradedConsensusState,
  }) {
    final _result = create();
    if (upgradedConsensusState != null) {
      _result.upgradedConsensusState = upgradedConsensusState;
    }
    return _result;
  }
  factory QueryUpgradedConsensusStateResponse.fromBuffer(
          $core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory QueryUpgradedConsensusStateResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryUpgradedConsensusStateResponse clone() =>
      QueryUpgradedConsensusStateResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryUpgradedConsensusStateResponse copyWith(
          void Function(QueryUpgradedConsensusStateResponse) updates) =>
      super.copyWith((message) =>
              updates(message as QueryUpgradedConsensusStateResponse))
          as QueryUpgradedConsensusStateResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryUpgradedConsensusStateResponse create() =>
      QueryUpgradedConsensusStateResponse._();
  QueryUpgradedConsensusStateResponse createEmptyInstance() => create();
  static $pb.PbList<QueryUpgradedConsensusStateResponse> createRepeated() =>
      $pb.PbList<QueryUpgradedConsensusStateResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryUpgradedConsensusStateResponse getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          QueryUpgradedConsensusStateResponse>(create);
  static QueryUpgradedConsensusStateResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Any get upgradedConsensusState => $_getN(0);
  @$pb.TagNumber(1)
  set upgradedConsensusState($3.Any v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUpgradedConsensusState() => $_has(0);
  @$pb.TagNumber(1)
  void clearUpgradedConsensusState() => clearField(1);
  @$pb.TagNumber(1)
  $3.Any ensureUpgradedConsensusState() => $_ensure(0);
}
