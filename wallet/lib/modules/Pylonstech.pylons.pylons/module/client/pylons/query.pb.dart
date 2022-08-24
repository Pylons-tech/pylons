///
//  Generated code. Do not modify.
//  source: pylons/pylons/query.proto
//
// @dart = 2.12
// ignore_for_file: annotate_overrides,camel_case_types,constant_identifier_names,directives_ordering,library_prefixes,non_constant_identifier_names,prefer_final_fields,return_of_invalid_type,unnecessary_const,unnecessary_import,unnecessary_this,unused_import,unused_shown_name

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'accounts.pb.dart' as $12;
import '../cosmos/base/query/v1beta1/pagination.pb.dart' as $13;
import 'trade.pb.dart' as $8;
import 'item.pb.dart' as $3;
import 'stripe_refund.pb.dart' as $14;
import 'redeem_info.pb.dart' as $5;
import 'payment_info.pb.dart' as $7;
import 'google_iap_order.pb.dart' as $10;
import 'execution.pb.dart' as $9;
import 'recipe.pb.dart' as $4;
import 'cookbook.pb.dart' as $6;

class QueryListSignUpByReferee extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListSignUpByReferee', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..hasRequiredFields = false
  ;

  QueryListSignUpByReferee._() : super();
  factory QueryListSignUpByReferee({
    $core.String? creator,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    return _result;
  }
  factory QueryListSignUpByReferee.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListSignUpByReferee.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryListSignUpByReferee clone() => QueryListSignUpByReferee()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryListSignUpByReferee copyWith(void Function(QueryListSignUpByReferee) updates) => super.copyWith((message) => updates(message as QueryListSignUpByReferee)) as QueryListSignUpByReferee; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListSignUpByReferee create() => QueryListSignUpByReferee._();
  QueryListSignUpByReferee createEmptyInstance() => create();
  static $pb.PbList<QueryListSignUpByReferee> createRepeated() => $pb.PbList<QueryListSignUpByReferee>();
  @$core.pragma('dart2js:noInline')
  static QueryListSignUpByReferee getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListSignUpByReferee>(create);
  static QueryListSignUpByReferee? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);
}

class QueryListSignUpByRefereeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListSignUpByRefereeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOM<$12.ReferralKV>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'signup', subBuilder: $12.ReferralKV.create)
    ..hasRequiredFields = false
  ;

  QueryListSignUpByRefereeResponse._() : super();
  factory QueryListSignUpByRefereeResponse({
    $12.ReferralKV? signup,
  }) {
    final _result = create();
    if (signup != null) {
      _result.signup = signup;
    }
    return _result;
  }
  factory QueryListSignUpByRefereeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListSignUpByRefereeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryListSignUpByRefereeResponse clone() => QueryListSignUpByRefereeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryListSignUpByRefereeResponse copyWith(void Function(QueryListSignUpByRefereeResponse) updates) => super.copyWith((message) => updates(message as QueryListSignUpByRefereeResponse)) as QueryListSignUpByRefereeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListSignUpByRefereeResponse create() => QueryListSignUpByRefereeResponse._();
  QueryListSignUpByRefereeResponse createEmptyInstance() => create();
  static $pb.PbList<QueryListSignUpByRefereeResponse> createRepeated() => $pb.PbList<QueryListSignUpByRefereeResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryListSignUpByRefereeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListSignUpByRefereeResponse>(create);
  static QueryListSignUpByRefereeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $12.ReferralKV get signup => $_getN(0);
  @$pb.TagNumber(1)
  set signup($12.ReferralKV v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasSignup() => $_has(0);
  @$pb.TagNumber(1)
  void clearSignup() => clearField(1);
  @$pb.TagNumber(1)
  $12.ReferralKV ensureSignup() => $_ensure(0);
}

class QueryListTradesByCreatorRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListTradesByCreatorRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOM<$13.PageRequest>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $13.PageRequest.create)
    ..hasRequiredFields = false
  ;

  QueryListTradesByCreatorRequest._() : super();
  factory QueryListTradesByCreatorRequest({
    $core.String? creator,
    $13.PageRequest? pagination,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryListTradesByCreatorRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListTradesByCreatorRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryListTradesByCreatorRequest clone() => QueryListTradesByCreatorRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryListTradesByCreatorRequest copyWith(void Function(QueryListTradesByCreatorRequest) updates) => super.copyWith((message) => updates(message as QueryListTradesByCreatorRequest)) as QueryListTradesByCreatorRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListTradesByCreatorRequest create() => QueryListTradesByCreatorRequest._();
  QueryListTradesByCreatorRequest createEmptyInstance() => create();
  static $pb.PbList<QueryListTradesByCreatorRequest> createRepeated() => $pb.PbList<QueryListTradesByCreatorRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryListTradesByCreatorRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListTradesByCreatorRequest>(create);
  static QueryListTradesByCreatorRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(2)
  $13.PageRequest get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($13.PageRequest v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => clearField(2);
  @$pb.TagNumber(2)
  $13.PageRequest ensurePagination() => $_ensure(1);
}

class QueryListTradesByCreatorResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListTradesByCreatorResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..pc<$8.Trade>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'trades', $pb.PbFieldType.PM, subBuilder: $8.Trade.create)
    ..aOM<$13.PageResponse>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $13.PageResponse.create)
    ..hasRequiredFields = false
  ;

  QueryListTradesByCreatorResponse._() : super();
  factory QueryListTradesByCreatorResponse({
    $core.Iterable<$8.Trade>? trades,
    $13.PageResponse? pagination,
  }) {
    final _result = create();
    if (trades != null) {
      _result.trades.addAll(trades);
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryListTradesByCreatorResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListTradesByCreatorResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryListTradesByCreatorResponse clone() => QueryListTradesByCreatorResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryListTradesByCreatorResponse copyWith(void Function(QueryListTradesByCreatorResponse) updates) => super.copyWith((message) => updates(message as QueryListTradesByCreatorResponse)) as QueryListTradesByCreatorResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListTradesByCreatorResponse create() => QueryListTradesByCreatorResponse._();
  QueryListTradesByCreatorResponse createEmptyInstance() => create();
  static $pb.PbList<QueryListTradesByCreatorResponse> createRepeated() => $pb.PbList<QueryListTradesByCreatorResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryListTradesByCreatorResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListTradesByCreatorResponse>(create);
  static QueryListTradesByCreatorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$8.Trade> get trades => $_getList(0);

  @$pb.TagNumber(2)
  $13.PageResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($13.PageResponse v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => clearField(2);
  @$pb.TagNumber(2)
  $13.PageResponse ensurePagination() => $_ensure(1);
}

class QueryGetItemHistoryRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetItemHistoryRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'mintedNumber')
    ..hasRequiredFields = false
  ;

  QueryGetItemHistoryRequest._() : super();
  factory QueryGetItemHistoryRequest({
    $core.String? cookbookId,
    $core.String? itemId,
    $core.String? mintedNumber,
  }) {
    final _result = create();
    if (cookbookId != null) {
      _result.cookbookId = cookbookId;
    }
    if (itemId != null) {
      _result.itemId = itemId;
    }
    if (mintedNumber != null) {
      _result.mintedNumber = mintedNumber;
    }
    return _result;
  }
  factory QueryGetItemHistoryRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetItemHistoryRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetItemHistoryRequest clone() => QueryGetItemHistoryRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetItemHistoryRequest copyWith(void Function(QueryGetItemHistoryRequest) updates) => super.copyWith((message) => updates(message as QueryGetItemHistoryRequest)) as QueryGetItemHistoryRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetItemHistoryRequest create() => QueryGetItemHistoryRequest._();
  QueryGetItemHistoryRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetItemHistoryRequest> createRepeated() => $pb.PbList<QueryGetItemHistoryRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetItemHistoryRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetItemHistoryRequest>(create);
  static QueryGetItemHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCookbookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get mintedNumber => $_getSZ(2);
  @$pb.TagNumber(3)
  set mintedNumber($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMintedNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearMintedNumber() => clearField(3);
}

class QueryGetItemHistoryResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetItemHistoryResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..pc<$3.ItemHistory>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'history', $pb.PbFieldType.PM, subBuilder: $3.ItemHistory.create)
    ..hasRequiredFields = false
  ;

  QueryGetItemHistoryResponse._() : super();
  factory QueryGetItemHistoryResponse({
    $core.Iterable<$3.ItemHistory>? history,
  }) {
    final _result = create();
    if (history != null) {
      _result.history.addAll(history);
    }
    return _result;
  }
  factory QueryGetItemHistoryResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetItemHistoryResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetItemHistoryResponse clone() => QueryGetItemHistoryResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetItemHistoryResponse copyWith(void Function(QueryGetItemHistoryResponse) updates) => super.copyWith((message) => updates(message as QueryGetItemHistoryResponse)) as QueryGetItemHistoryResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetItemHistoryResponse create() => QueryGetItemHistoryResponse._();
  QueryGetItemHistoryResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetItemHistoryResponse> createRepeated() => $pb.PbList<QueryGetItemHistoryResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetItemHistoryResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetItemHistoryResponse>(create);
  static QueryGetItemHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$3.ItemHistory> get history => $_getList(0);
}

class QueryGetRecipeHistoryRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetRecipeHistoryRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recipeId')
    ..hasRequiredFields = false
  ;

  QueryGetRecipeHistoryRequest._() : super();
  factory QueryGetRecipeHistoryRequest({
    $core.String? cookbookId,
    $core.String? recipeId,
  }) {
    final _result = create();
    if (cookbookId != null) {
      _result.cookbookId = cookbookId;
    }
    if (recipeId != null) {
      _result.recipeId = recipeId;
    }
    return _result;
  }
  factory QueryGetRecipeHistoryRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetRecipeHistoryRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetRecipeHistoryRequest clone() => QueryGetRecipeHistoryRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetRecipeHistoryRequest copyWith(void Function(QueryGetRecipeHistoryRequest) updates) => super.copyWith((message) => updates(message as QueryGetRecipeHistoryRequest)) as QueryGetRecipeHistoryRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetRecipeHistoryRequest create() => QueryGetRecipeHistoryRequest._();
  QueryGetRecipeHistoryRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetRecipeHistoryRequest> createRepeated() => $pb.PbList<QueryGetRecipeHistoryRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetRecipeHistoryRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetRecipeHistoryRequest>(create);
  static QueryGetRecipeHistoryRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCookbookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get recipeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recipeId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRecipeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecipeId() => clearField(2);
}

class QueryGetRecipeHistoryResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetRecipeHistoryResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..pc<RecipeHistory>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'history', $pb.PbFieldType.PM, subBuilder: RecipeHistory.create)
    ..hasRequiredFields = false
  ;

  QueryGetRecipeHistoryResponse._() : super();
  factory QueryGetRecipeHistoryResponse({
    $core.Iterable<RecipeHistory>? history,
  }) {
    final _result = create();
    if (history != null) {
      _result.history.addAll(history);
    }
    return _result;
  }
  factory QueryGetRecipeHistoryResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetRecipeHistoryResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetRecipeHistoryResponse clone() => QueryGetRecipeHistoryResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetRecipeHistoryResponse copyWith(void Function(QueryGetRecipeHistoryResponse) updates) => super.copyWith((message) => updates(message as QueryGetRecipeHistoryResponse)) as QueryGetRecipeHistoryResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetRecipeHistoryResponse create() => QueryGetRecipeHistoryResponse._();
  QueryGetRecipeHistoryResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetRecipeHistoryResponse> createRepeated() => $pb.PbList<QueryGetRecipeHistoryResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetRecipeHistoryResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetRecipeHistoryResponse>(create);
  static QueryGetRecipeHistoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<RecipeHistory> get history => $_getList(0);
}

class RecipeHistory extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'RecipeHistory', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recipeId')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sender')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'senderName')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'receiver')
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'amount')
    ..aInt64(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'createdAt')
    ..hasRequiredFields = false
  ;

  RecipeHistory._() : super();
  factory RecipeHistory({
    $core.String? itemId,
    $core.String? cookbookId,
    $core.String? recipeId,
    $core.String? sender,
    $core.String? senderName,
    $core.String? receiver,
    $core.String? amount,
    $fixnum.Int64? createdAt,
  }) {
    final _result = create();
    if (itemId != null) {
      _result.itemId = itemId;
    }
    if (cookbookId != null) {
      _result.cookbookId = cookbookId;
    }
    if (recipeId != null) {
      _result.recipeId = recipeId;
    }
    if (sender != null) {
      _result.sender = sender;
    }
    if (senderName != null) {
      _result.senderName = senderName;
    }
    if (receiver != null) {
      _result.receiver = receiver;
    }
    if (amount != null) {
      _result.amount = amount;
    }
    if (createdAt != null) {
      _result.createdAt = createdAt;
    }
    return _result;
  }
  factory RecipeHistory.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RecipeHistory.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RecipeHistory clone() => RecipeHistory()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RecipeHistory copyWith(void Function(RecipeHistory) updates) => super.copyWith((message) => updates(message as RecipeHistory)) as RecipeHistory; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static RecipeHistory create() => RecipeHistory._();
  RecipeHistory createEmptyInstance() => create();
  static $pb.PbList<RecipeHistory> createRepeated() => $pb.PbList<RecipeHistory>();
  @$core.pragma('dart2js:noInline')
  static RecipeHistory getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecipeHistory>(create);
  static RecipeHistory? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemId => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasItemId() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get cookbookId => $_getSZ(1);
  @$pb.TagNumber(2)
  set cookbookId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCookbookId() => $_has(1);
  @$pb.TagNumber(2)
  void clearCookbookId() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get recipeId => $_getSZ(2);
  @$pb.TagNumber(3)
  set recipeId($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRecipeId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipeId() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get sender => $_getSZ(3);
  @$pb.TagNumber(4)
  set sender($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSender() => $_has(3);
  @$pb.TagNumber(4)
  void clearSender() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get senderName => $_getSZ(4);
  @$pb.TagNumber(5)
  set senderName($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSenderName() => $_has(4);
  @$pb.TagNumber(5)
  void clearSenderName() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get receiver => $_getSZ(5);
  @$pb.TagNumber(6)
  set receiver($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasReceiver() => $_has(5);
  @$pb.TagNumber(6)
  void clearReceiver() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get amount => $_getSZ(6);
  @$pb.TagNumber(7)
  set amount($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasAmount() => $_has(6);
  @$pb.TagNumber(7)
  void clearAmount() => clearField(7);

  @$pb.TagNumber(8)
  $fixnum.Int64 get createdAt => $_getI64(7);
  @$pb.TagNumber(8)
  set createdAt($fixnum.Int64 v) { $_setInt64(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasCreatedAt() => $_has(7);
  @$pb.TagNumber(8)
  void clearCreatedAt() => clearField(8);
}

class QueryGetStripeRefundRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetStripeRefundRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  QueryGetStripeRefundRequest._() : super();
  factory QueryGetStripeRefundRequest() => create();
  factory QueryGetStripeRefundRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetStripeRefundRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetStripeRefundRequest clone() => QueryGetStripeRefundRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetStripeRefundRequest copyWith(void Function(QueryGetStripeRefundRequest) updates) => super.copyWith((message) => updates(message as QueryGetStripeRefundRequest)) as QueryGetStripeRefundRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetStripeRefundRequest create() => QueryGetStripeRefundRequest._();
  QueryGetStripeRefundRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetStripeRefundRequest> createRepeated() => $pb.PbList<QueryGetStripeRefundRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetStripeRefundRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetStripeRefundRequest>(create);
  static QueryGetStripeRefundRequest? _defaultInstance;
}

class QueryGetStripeRefundResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetStripeRefundResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..pc<$14.StripeRefund>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'refunds', $pb.PbFieldType.PM, subBuilder: $14.StripeRefund.create)
    ..hasRequiredFields = false
  ;

  QueryGetStripeRefundResponse._() : super();
  factory QueryGetStripeRefundResponse({
    $core.Iterable<$14.StripeRefund>? refunds,
  }) {
    final _result = create();
    if (refunds != null) {
      _result.refunds.addAll(refunds);
    }
    return _result;
  }
  factory QueryGetStripeRefundResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetStripeRefundResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetStripeRefundResponse clone() => QueryGetStripeRefundResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetStripeRefundResponse copyWith(void Function(QueryGetStripeRefundResponse) updates) => super.copyWith((message) => updates(message as QueryGetStripeRefundResponse)) as QueryGetStripeRefundResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetStripeRefundResponse create() => QueryGetStripeRefundResponse._();
  QueryGetStripeRefundResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetStripeRefundResponse> createRepeated() => $pb.PbList<QueryGetStripeRefundResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetStripeRefundResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetStripeRefundResponse>(create);
  static QueryGetStripeRefundResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$14.StripeRefund> get refunds => $_getList(0);
}

class QueryGetRedeemInfoRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetRedeemInfoRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  QueryGetRedeemInfoRequest._() : super();
  factory QueryGetRedeemInfoRequest({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory QueryGetRedeemInfoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetRedeemInfoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetRedeemInfoRequest clone() => QueryGetRedeemInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetRedeemInfoRequest copyWith(void Function(QueryGetRedeemInfoRequest) updates) => super.copyWith((message) => updates(message as QueryGetRedeemInfoRequest)) as QueryGetRedeemInfoRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetRedeemInfoRequest create() => QueryGetRedeemInfoRequest._();
  QueryGetRedeemInfoRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetRedeemInfoRequest> createRepeated() => $pb.PbList<QueryGetRedeemInfoRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetRedeemInfoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetRedeemInfoRequest>(create);
  static QueryGetRedeemInfoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class QueryGetRedeemInfoResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetRedeemInfoResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOM<$5.RedeemInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'redeemInfo', subBuilder: $5.RedeemInfo.create)
    ..hasRequiredFields = false
  ;

  QueryGetRedeemInfoResponse._() : super();
  factory QueryGetRedeemInfoResponse({
    $5.RedeemInfo? redeemInfo,
  }) {
    final _result = create();
    if (redeemInfo != null) {
      _result.redeemInfo = redeemInfo;
    }
    return _result;
  }
  factory QueryGetRedeemInfoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetRedeemInfoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetRedeemInfoResponse clone() => QueryGetRedeemInfoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetRedeemInfoResponse copyWith(void Function(QueryGetRedeemInfoResponse) updates) => super.copyWith((message) => updates(message as QueryGetRedeemInfoResponse)) as QueryGetRedeemInfoResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetRedeemInfoResponse create() => QueryGetRedeemInfoResponse._();
  QueryGetRedeemInfoResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetRedeemInfoResponse> createRepeated() => $pb.PbList<QueryGetRedeemInfoResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetRedeemInfoResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetRedeemInfoResponse>(create);
  static QueryGetRedeemInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $5.RedeemInfo get redeemInfo => $_getN(0);
  @$pb.TagNumber(1)
  set redeemInfo($5.RedeemInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRedeemInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearRedeemInfo() => clearField(1);
  @$pb.TagNumber(1)
  $5.RedeemInfo ensureRedeemInfo() => $_ensure(0);
}

class QueryAllRedeemInfoRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryAllRedeemInfoRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOM<$13.PageRequest>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $13.PageRequest.create)
    ..hasRequiredFields = false
  ;

  QueryAllRedeemInfoRequest._() : super();
  factory QueryAllRedeemInfoRequest({
    $13.PageRequest? pagination,
  }) {
    final _result = create();
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryAllRedeemInfoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryAllRedeemInfoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryAllRedeemInfoRequest clone() => QueryAllRedeemInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryAllRedeemInfoRequest copyWith(void Function(QueryAllRedeemInfoRequest) updates) => super.copyWith((message) => updates(message as QueryAllRedeemInfoRequest)) as QueryAllRedeemInfoRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryAllRedeemInfoRequest create() => QueryAllRedeemInfoRequest._();
  QueryAllRedeemInfoRequest createEmptyInstance() => create();
  static $pb.PbList<QueryAllRedeemInfoRequest> createRepeated() => $pb.PbList<QueryAllRedeemInfoRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryAllRedeemInfoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryAllRedeemInfoRequest>(create);
  static QueryAllRedeemInfoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $13.PageRequest get pagination => $_getN(0);
  @$pb.TagNumber(1)
  set pagination($13.PageRequest v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPagination() => $_has(0);
  @$pb.TagNumber(1)
  void clearPagination() => clearField(1);
  @$pb.TagNumber(1)
  $13.PageRequest ensurePagination() => $_ensure(0);
}

class QueryAllRedeemInfoResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryAllRedeemInfoResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..pc<$5.RedeemInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'redeemInfo', $pb.PbFieldType.PM, subBuilder: $5.RedeemInfo.create)
    ..aOM<$13.PageResponse>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $13.PageResponse.create)
    ..hasRequiredFields = false
  ;

  QueryAllRedeemInfoResponse._() : super();
  factory QueryAllRedeemInfoResponse({
    $core.Iterable<$5.RedeemInfo>? redeemInfo,
    $13.PageResponse? pagination,
  }) {
    final _result = create();
    if (redeemInfo != null) {
      _result.redeemInfo.addAll(redeemInfo);
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryAllRedeemInfoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryAllRedeemInfoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryAllRedeemInfoResponse clone() => QueryAllRedeemInfoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryAllRedeemInfoResponse copyWith(void Function(QueryAllRedeemInfoResponse) updates) => super.copyWith((message) => updates(message as QueryAllRedeemInfoResponse)) as QueryAllRedeemInfoResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryAllRedeemInfoResponse create() => QueryAllRedeemInfoResponse._();
  QueryAllRedeemInfoResponse createEmptyInstance() => create();
  static $pb.PbList<QueryAllRedeemInfoResponse> createRepeated() => $pb.PbList<QueryAllRedeemInfoResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryAllRedeemInfoResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryAllRedeemInfoResponse>(create);
  static QueryAllRedeemInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$5.RedeemInfo> get redeemInfo => $_getList(0);

  @$pb.TagNumber(2)
  $13.PageResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($13.PageResponse v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => clearField(2);
  @$pb.TagNumber(2)
  $13.PageResponse ensurePagination() => $_ensure(1);
}

class QueryGetPaymentInfoRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetPaymentInfoRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'purchaseId')
    ..hasRequiredFields = false
  ;

  QueryGetPaymentInfoRequest._() : super();
  factory QueryGetPaymentInfoRequest({
    $core.String? purchaseId,
  }) {
    final _result = create();
    if (purchaseId != null) {
      _result.purchaseId = purchaseId;
    }
    return _result;
  }
  factory QueryGetPaymentInfoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetPaymentInfoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetPaymentInfoRequest clone() => QueryGetPaymentInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetPaymentInfoRequest copyWith(void Function(QueryGetPaymentInfoRequest) updates) => super.copyWith((message) => updates(message as QueryGetPaymentInfoRequest)) as QueryGetPaymentInfoRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetPaymentInfoRequest create() => QueryGetPaymentInfoRequest._();
  QueryGetPaymentInfoRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetPaymentInfoRequest> createRepeated() => $pb.PbList<QueryGetPaymentInfoRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetPaymentInfoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetPaymentInfoRequest>(create);
  static QueryGetPaymentInfoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get purchaseId => $_getSZ(0);
  @$pb.TagNumber(1)
  set purchaseId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPurchaseId() => $_has(0);
  @$pb.TagNumber(1)
  void clearPurchaseId() => clearField(1);
}

class QueryGetPaymentInfoResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetPaymentInfoResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOM<$7.PaymentInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'paymentInfo', subBuilder: $7.PaymentInfo.create)
    ..hasRequiredFields = false
  ;

  QueryGetPaymentInfoResponse._() : super();
  factory QueryGetPaymentInfoResponse({
    $7.PaymentInfo? paymentInfo,
  }) {
    final _result = create();
    if (paymentInfo != null) {
      _result.paymentInfo = paymentInfo;
    }
    return _result;
  }
  factory QueryGetPaymentInfoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetPaymentInfoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetPaymentInfoResponse clone() => QueryGetPaymentInfoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetPaymentInfoResponse copyWith(void Function(QueryGetPaymentInfoResponse) updates) => super.copyWith((message) => updates(message as QueryGetPaymentInfoResponse)) as QueryGetPaymentInfoResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetPaymentInfoResponse create() => QueryGetPaymentInfoResponse._();
  QueryGetPaymentInfoResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetPaymentInfoResponse> createRepeated() => $pb.PbList<QueryGetPaymentInfoResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetPaymentInfoResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetPaymentInfoResponse>(create);
  static QueryGetPaymentInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $7.PaymentInfo get paymentInfo => $_getN(0);
  @$pb.TagNumber(1)
  set paymentInfo($7.PaymentInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPaymentInfo() => $_has(0);
  @$pb.TagNumber(1)
  void clearPaymentInfo() => clearField(1);
  @$pb.TagNumber(1)
  $7.PaymentInfo ensurePaymentInfo() => $_ensure(0);
}

class QueryAllPaymentInfoRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryAllPaymentInfoRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOM<$13.PageRequest>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $13.PageRequest.create)
    ..hasRequiredFields = false
  ;

  QueryAllPaymentInfoRequest._() : super();
  factory QueryAllPaymentInfoRequest({
    $13.PageRequest? pagination,
  }) {
    final _result = create();
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryAllPaymentInfoRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryAllPaymentInfoRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryAllPaymentInfoRequest clone() => QueryAllPaymentInfoRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryAllPaymentInfoRequest copyWith(void Function(QueryAllPaymentInfoRequest) updates) => super.copyWith((message) => updates(message as QueryAllPaymentInfoRequest)) as QueryAllPaymentInfoRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryAllPaymentInfoRequest create() => QueryAllPaymentInfoRequest._();
  QueryAllPaymentInfoRequest createEmptyInstance() => create();
  static $pb.PbList<QueryAllPaymentInfoRequest> createRepeated() => $pb.PbList<QueryAllPaymentInfoRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryAllPaymentInfoRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryAllPaymentInfoRequest>(create);
  static QueryAllPaymentInfoRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $13.PageRequest get pagination => $_getN(0);
  @$pb.TagNumber(1)
  set pagination($13.PageRequest v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPagination() => $_has(0);
  @$pb.TagNumber(1)
  void clearPagination() => clearField(1);
  @$pb.TagNumber(1)
  $13.PageRequest ensurePagination() => $_ensure(0);
}

class QueryAllPaymentInfoResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryAllPaymentInfoResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..pc<$7.PaymentInfo>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'paymentInfo', $pb.PbFieldType.PM, subBuilder: $7.PaymentInfo.create)
    ..aOM<$13.PageResponse>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $13.PageResponse.create)
    ..hasRequiredFields = false
  ;

  QueryAllPaymentInfoResponse._() : super();
  factory QueryAllPaymentInfoResponse({
    $core.Iterable<$7.PaymentInfo>? paymentInfo,
    $13.PageResponse? pagination,
  }) {
    final _result = create();
    if (paymentInfo != null) {
      _result.paymentInfo.addAll(paymentInfo);
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryAllPaymentInfoResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryAllPaymentInfoResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryAllPaymentInfoResponse clone() => QueryAllPaymentInfoResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryAllPaymentInfoResponse copyWith(void Function(QueryAllPaymentInfoResponse) updates) => super.copyWith((message) => updates(message as QueryAllPaymentInfoResponse)) as QueryAllPaymentInfoResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryAllPaymentInfoResponse create() => QueryAllPaymentInfoResponse._();
  QueryAllPaymentInfoResponse createEmptyInstance() => create();
  static $pb.PbList<QueryAllPaymentInfoResponse> createRepeated() => $pb.PbList<QueryAllPaymentInfoResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryAllPaymentInfoResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryAllPaymentInfoResponse>(create);
  static QueryAllPaymentInfoResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$7.PaymentInfo> get paymentInfo => $_getList(0);

  @$pb.TagNumber(2)
  $13.PageResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($13.PageResponse v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => clearField(2);
  @$pb.TagNumber(2)
  $13.PageResponse ensurePagination() => $_ensure(1);
}

class QueryGetUsernameByAddressRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetUsernameByAddressRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..hasRequiredFields = false
  ;

  QueryGetUsernameByAddressRequest._() : super();
  factory QueryGetUsernameByAddressRequest({
    $core.String? address,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    return _result;
  }
  factory QueryGetUsernameByAddressRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetUsernameByAddressRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetUsernameByAddressRequest clone() => QueryGetUsernameByAddressRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetUsernameByAddressRequest copyWith(void Function(QueryGetUsernameByAddressRequest) updates) => super.copyWith((message) => updates(message as QueryGetUsernameByAddressRequest)) as QueryGetUsernameByAddressRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetUsernameByAddressRequest create() => QueryGetUsernameByAddressRequest._();
  QueryGetUsernameByAddressRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetUsernameByAddressRequest> createRepeated() => $pb.PbList<QueryGetUsernameByAddressRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetUsernameByAddressRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetUsernameByAddressRequest>(create);
  static QueryGetUsernameByAddressRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);
}

class QueryGetAddressByUsernameRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetAddressByUsernameRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..hasRequiredFields = false
  ;

  QueryGetAddressByUsernameRequest._() : super();
  factory QueryGetAddressByUsernameRequest({
    $core.String? username,
  }) {
    final _result = create();
    if (username != null) {
      _result.username = username;
    }
    return _result;
  }
  factory QueryGetAddressByUsernameRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetAddressByUsernameRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetAddressByUsernameRequest clone() => QueryGetAddressByUsernameRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetAddressByUsernameRequest copyWith(void Function(QueryGetAddressByUsernameRequest) updates) => super.copyWith((message) => updates(message as QueryGetAddressByUsernameRequest)) as QueryGetAddressByUsernameRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetAddressByUsernameRequest create() => QueryGetAddressByUsernameRequest._();
  QueryGetAddressByUsernameRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetAddressByUsernameRequest> createRepeated() => $pb.PbList<QueryGetAddressByUsernameRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetAddressByUsernameRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetAddressByUsernameRequest>(create);
  static QueryGetAddressByUsernameRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get username => $_getSZ(0);
  @$pb.TagNumber(1)
  set username($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => clearField(1);
}

class QueryGetUsernameByAddressResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetUsernameByAddressResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOM<$12.Username>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username', subBuilder: $12.Username.create)
    ..hasRequiredFields = false
  ;

  QueryGetUsernameByAddressResponse._() : super();
  factory QueryGetUsernameByAddressResponse({
    $12.Username? username,
  }) {
    final _result = create();
    if (username != null) {
      _result.username = username;
    }
    return _result;
  }
  factory QueryGetUsernameByAddressResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetUsernameByAddressResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetUsernameByAddressResponse clone() => QueryGetUsernameByAddressResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetUsernameByAddressResponse copyWith(void Function(QueryGetUsernameByAddressResponse) updates) => super.copyWith((message) => updates(message as QueryGetUsernameByAddressResponse)) as QueryGetUsernameByAddressResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetUsernameByAddressResponse create() => QueryGetUsernameByAddressResponse._();
  QueryGetUsernameByAddressResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetUsernameByAddressResponse> createRepeated() => $pb.PbList<QueryGetUsernameByAddressResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetUsernameByAddressResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetUsernameByAddressResponse>(create);
  static QueryGetUsernameByAddressResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $12.Username get username => $_getN(0);
  @$pb.TagNumber(1)
  set username($12.Username v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => clearField(1);
  @$pb.TagNumber(1)
  $12.Username ensureUsername() => $_ensure(0);
}

class QueryGetAddressByUsernameResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetAddressByUsernameResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOM<$12.AccountAddr>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address', subBuilder: $12.AccountAddr.create)
    ..hasRequiredFields = false
  ;

  QueryGetAddressByUsernameResponse._() : super();
  factory QueryGetAddressByUsernameResponse({
    $12.AccountAddr? address,
  }) {
    final _result = create();
    if (address != null) {
      _result.address = address;
    }
    return _result;
  }
  factory QueryGetAddressByUsernameResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetAddressByUsernameResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetAddressByUsernameResponse clone() => QueryGetAddressByUsernameResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetAddressByUsernameResponse copyWith(void Function(QueryGetAddressByUsernameResponse) updates) => super.copyWith((message) => updates(message as QueryGetAddressByUsernameResponse)) as QueryGetAddressByUsernameResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetAddressByUsernameResponse create() => QueryGetAddressByUsernameResponse._();
  QueryGetAddressByUsernameResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetAddressByUsernameResponse> createRepeated() => $pb.PbList<QueryGetAddressByUsernameResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetAddressByUsernameResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetAddressByUsernameResponse>(create);
  static QueryGetAddressByUsernameResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $12.AccountAddr get address => $_getN(0);
  @$pb.TagNumber(1)
  set address($12.AccountAddr v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);
  @$pb.TagNumber(1)
  $12.AccountAddr ensureAddress() => $_ensure(0);
}

class QueryGetTradeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetTradeRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  QueryGetTradeRequest._() : super();
  factory QueryGetTradeRequest({
    $fixnum.Int64? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory QueryGetTradeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetTradeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetTradeRequest clone() => QueryGetTradeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetTradeRequest copyWith(void Function(QueryGetTradeRequest) updates) => super.copyWith((message) => updates(message as QueryGetTradeRequest)) as QueryGetTradeRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetTradeRequest create() => QueryGetTradeRequest._();
  QueryGetTradeRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetTradeRequest> createRepeated() => $pb.PbList<QueryGetTradeRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetTradeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetTradeRequest>(create);
  static QueryGetTradeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class QueryGetTradeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetTradeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOM<$8.Trade>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'trade', subBuilder: $8.Trade.create)
    ..hasRequiredFields = false
  ;

  QueryGetTradeResponse._() : super();
  factory QueryGetTradeResponse({
    $8.Trade? trade,
  }) {
    final _result = create();
    if (trade != null) {
      _result.trade = trade;
    }
    return _result;
  }
  factory QueryGetTradeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetTradeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetTradeResponse clone() => QueryGetTradeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetTradeResponse copyWith(void Function(QueryGetTradeResponse) updates) => super.copyWith((message) => updates(message as QueryGetTradeResponse)) as QueryGetTradeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetTradeResponse create() => QueryGetTradeResponse._();
  QueryGetTradeResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetTradeResponse> createRepeated() => $pb.PbList<QueryGetTradeResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetTradeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetTradeResponse>(create);
  static QueryGetTradeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $8.Trade get trade => $_getN(0);
  @$pb.TagNumber(1)
  set trade($8.Trade v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasTrade() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrade() => clearField(1);
  @$pb.TagNumber(1)
  $8.Trade ensureTrade() => $_ensure(0);
}

class QueryListItemByOwnerRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListItemByOwnerRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'owner')
    ..aOM<$13.PageRequest>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $13.PageRequest.create)
    ..hasRequiredFields = false
  ;

  QueryListItemByOwnerRequest._() : super();
  factory QueryListItemByOwnerRequest({
    $core.String? owner,
    $13.PageRequest? pagination,
  }) {
    final _result = create();
    if (owner != null) {
      _result.owner = owner;
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryListItemByOwnerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListItemByOwnerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryListItemByOwnerRequest clone() => QueryListItemByOwnerRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryListItemByOwnerRequest copyWith(void Function(QueryListItemByOwnerRequest) updates) => super.copyWith((message) => updates(message as QueryListItemByOwnerRequest)) as QueryListItemByOwnerRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListItemByOwnerRequest create() => QueryListItemByOwnerRequest._();
  QueryListItemByOwnerRequest createEmptyInstance() => create();
  static $pb.PbList<QueryListItemByOwnerRequest> createRepeated() => $pb.PbList<QueryListItemByOwnerRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryListItemByOwnerRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListItemByOwnerRequest>(create);
  static QueryListItemByOwnerRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get owner => $_getSZ(0);
  @$pb.TagNumber(1)
  set owner($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasOwner() => $_has(0);
  @$pb.TagNumber(1)
  void clearOwner() => clearField(1);

  @$pb.TagNumber(3)
  $13.PageRequest get pagination => $_getN(1);
  @$pb.TagNumber(3)
  set pagination($13.PageRequest v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(3)
  void clearPagination() => clearField(3);
  @$pb.TagNumber(3)
  $13.PageRequest ensurePagination() => $_ensure(1);
}

class QueryListItemByOwnerResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListItemByOwnerResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..pc<$3.Item>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'items', $pb.PbFieldType.PM, subBuilder: $3.Item.create)
    ..aOM<$13.PageResponse>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $13.PageResponse.create)
    ..hasRequiredFields = false
  ;

  QueryListItemByOwnerResponse._() : super();
  factory QueryListItemByOwnerResponse({
    $core.Iterable<$3.Item>? items,
    $13.PageResponse? pagination,
  }) {
    final _result = create();
    if (items != null) {
      _result.items.addAll(items);
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryListItemByOwnerResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListItemByOwnerResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryListItemByOwnerResponse clone() => QueryListItemByOwnerResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryListItemByOwnerResponse copyWith(void Function(QueryListItemByOwnerResponse) updates) => super.copyWith((message) => updates(message as QueryListItemByOwnerResponse)) as QueryListItemByOwnerResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListItemByOwnerResponse create() => QueryListItemByOwnerResponse._();
  QueryListItemByOwnerResponse createEmptyInstance() => create();
  static $pb.PbList<QueryListItemByOwnerResponse> createRepeated() => $pb.PbList<QueryListItemByOwnerResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryListItemByOwnerResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListItemByOwnerResponse>(create);
  static QueryListItemByOwnerResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$3.Item> get items => $_getList(0);

  @$pb.TagNumber(2)
  $13.PageResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($13.PageResponse v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => clearField(2);
  @$pb.TagNumber(2)
  $13.PageResponse ensurePagination() => $_ensure(1);
}

class QueryGetGoogleInAppPurchaseOrderRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetGoogleInAppPurchaseOrderRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'purchaseToken')
    ..hasRequiredFields = false
  ;

  QueryGetGoogleInAppPurchaseOrderRequest._() : super();
  factory QueryGetGoogleInAppPurchaseOrderRequest({
    $core.String? purchaseToken,
  }) {
    final _result = create();
    if (purchaseToken != null) {
      _result.purchaseToken = purchaseToken;
    }
    return _result;
  }
  factory QueryGetGoogleInAppPurchaseOrderRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetGoogleInAppPurchaseOrderRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetGoogleInAppPurchaseOrderRequest clone() => QueryGetGoogleInAppPurchaseOrderRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetGoogleInAppPurchaseOrderRequest copyWith(void Function(QueryGetGoogleInAppPurchaseOrderRequest) updates) => super.copyWith((message) => updates(message as QueryGetGoogleInAppPurchaseOrderRequest)) as QueryGetGoogleInAppPurchaseOrderRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetGoogleInAppPurchaseOrderRequest create() => QueryGetGoogleInAppPurchaseOrderRequest._();
  QueryGetGoogleInAppPurchaseOrderRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetGoogleInAppPurchaseOrderRequest> createRepeated() => $pb.PbList<QueryGetGoogleInAppPurchaseOrderRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetGoogleInAppPurchaseOrderRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetGoogleInAppPurchaseOrderRequest>(create);
  static QueryGetGoogleInAppPurchaseOrderRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get purchaseToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set purchaseToken($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPurchaseToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearPurchaseToken() => clearField(1);
}

class QueryGetGoogleInAppPurchaseOrderResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetGoogleInAppPurchaseOrderResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOM<$10.GoogleInAppPurchaseOrder>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'order', subBuilder: $10.GoogleInAppPurchaseOrder.create)
    ..hasRequiredFields = false
  ;

  QueryGetGoogleInAppPurchaseOrderResponse._() : super();
  factory QueryGetGoogleInAppPurchaseOrderResponse({
    $10.GoogleInAppPurchaseOrder? order,
  }) {
    final _result = create();
    if (order != null) {
      _result.order = order;
    }
    return _result;
  }
  factory QueryGetGoogleInAppPurchaseOrderResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetGoogleInAppPurchaseOrderResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetGoogleInAppPurchaseOrderResponse clone() => QueryGetGoogleInAppPurchaseOrderResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetGoogleInAppPurchaseOrderResponse copyWith(void Function(QueryGetGoogleInAppPurchaseOrderResponse) updates) => super.copyWith((message) => updates(message as QueryGetGoogleInAppPurchaseOrderResponse)) as QueryGetGoogleInAppPurchaseOrderResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetGoogleInAppPurchaseOrderResponse create() => QueryGetGoogleInAppPurchaseOrderResponse._();
  QueryGetGoogleInAppPurchaseOrderResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetGoogleInAppPurchaseOrderResponse> createRepeated() => $pb.PbList<QueryGetGoogleInAppPurchaseOrderResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetGoogleInAppPurchaseOrderResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetGoogleInAppPurchaseOrderResponse>(create);
  static QueryGetGoogleInAppPurchaseOrderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $10.GoogleInAppPurchaseOrder get order => $_getN(0);
  @$pb.TagNumber(1)
  set order($10.GoogleInAppPurchaseOrder v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => clearField(1);
  @$pb.TagNumber(1)
  $10.GoogleInAppPurchaseOrder ensureOrder() => $_ensure(0);
}

class QueryListExecutionsByItemRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListExecutionsByItemRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemId')
    ..aOM<$13.PageRequest>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $13.PageRequest.create)
    ..hasRequiredFields = false
  ;

  QueryListExecutionsByItemRequest._() : super();
  factory QueryListExecutionsByItemRequest({
    $core.String? cookbookId,
    $core.String? itemId,
    $13.PageRequest? pagination,
  }) {
    final _result = create();
    if (cookbookId != null) {
      _result.cookbookId = cookbookId;
    }
    if (itemId != null) {
      _result.itemId = itemId;
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryListExecutionsByItemRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListExecutionsByItemRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryListExecutionsByItemRequest clone() => QueryListExecutionsByItemRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryListExecutionsByItemRequest copyWith(void Function(QueryListExecutionsByItemRequest) updates) => super.copyWith((message) => updates(message as QueryListExecutionsByItemRequest)) as QueryListExecutionsByItemRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListExecutionsByItemRequest create() => QueryListExecutionsByItemRequest._();
  QueryListExecutionsByItemRequest createEmptyInstance() => create();
  static $pb.PbList<QueryListExecutionsByItemRequest> createRepeated() => $pb.PbList<QueryListExecutionsByItemRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryListExecutionsByItemRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListExecutionsByItemRequest>(create);
  static QueryListExecutionsByItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCookbookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemId => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasItemId() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemId() => clearField(2);

  @$pb.TagNumber(3)
  $13.PageRequest get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($13.PageRequest v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => clearField(3);
  @$pb.TagNumber(3)
  $13.PageRequest ensurePagination() => $_ensure(2);
}

class QueryListExecutionsByItemResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListExecutionsByItemResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..pc<$9.Execution>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'completedExecutions', $pb.PbFieldType.PM, subBuilder: $9.Execution.create)
    ..pc<$9.Execution>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pendingExecutions', $pb.PbFieldType.PM, subBuilder: $9.Execution.create)
    ..aOM<$13.PageResponse>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $13.PageResponse.create)
    ..hasRequiredFields = false
  ;

  QueryListExecutionsByItemResponse._() : super();
  factory QueryListExecutionsByItemResponse({
    $core.Iterable<$9.Execution>? completedExecutions,
    $core.Iterable<$9.Execution>? pendingExecutions,
    $13.PageResponse? pagination,
  }) {
    final _result = create();
    if (completedExecutions != null) {
      _result.completedExecutions.addAll(completedExecutions);
    }
    if (pendingExecutions != null) {
      _result.pendingExecutions.addAll(pendingExecutions);
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryListExecutionsByItemResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListExecutionsByItemResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryListExecutionsByItemResponse clone() => QueryListExecutionsByItemResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryListExecutionsByItemResponse copyWith(void Function(QueryListExecutionsByItemResponse) updates) => super.copyWith((message) => updates(message as QueryListExecutionsByItemResponse)) as QueryListExecutionsByItemResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListExecutionsByItemResponse create() => QueryListExecutionsByItemResponse._();
  QueryListExecutionsByItemResponse createEmptyInstance() => create();
  static $pb.PbList<QueryListExecutionsByItemResponse> createRepeated() => $pb.PbList<QueryListExecutionsByItemResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryListExecutionsByItemResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListExecutionsByItemResponse>(create);
  static QueryListExecutionsByItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$9.Execution> get completedExecutions => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$9.Execution> get pendingExecutions => $_getList(1);

  @$pb.TagNumber(3)
  $13.PageResponse get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($13.PageResponse v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => clearField(3);
  @$pb.TagNumber(3)
  $13.PageResponse ensurePagination() => $_ensure(2);
}

class QueryListExecutionsByRecipeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListExecutionsByRecipeRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recipeId')
    ..aOM<$13.PageRequest>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $13.PageRequest.create)
    ..hasRequiredFields = false
  ;

  QueryListExecutionsByRecipeRequest._() : super();
  factory QueryListExecutionsByRecipeRequest({
    $core.String? cookbookId,
    $core.String? recipeId,
    $13.PageRequest? pagination,
  }) {
    final _result = create();
    if (cookbookId != null) {
      _result.cookbookId = cookbookId;
    }
    if (recipeId != null) {
      _result.recipeId = recipeId;
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryListExecutionsByRecipeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListExecutionsByRecipeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryListExecutionsByRecipeRequest clone() => QueryListExecutionsByRecipeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryListExecutionsByRecipeRequest copyWith(void Function(QueryListExecutionsByRecipeRequest) updates) => super.copyWith((message) => updates(message as QueryListExecutionsByRecipeRequest)) as QueryListExecutionsByRecipeRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListExecutionsByRecipeRequest create() => QueryListExecutionsByRecipeRequest._();
  QueryListExecutionsByRecipeRequest createEmptyInstance() => create();
  static $pb.PbList<QueryListExecutionsByRecipeRequest> createRepeated() => $pb.PbList<QueryListExecutionsByRecipeRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryListExecutionsByRecipeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListExecutionsByRecipeRequest>(create);
  static QueryListExecutionsByRecipeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCookbookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get recipeId => $_getSZ(1);
  @$pb.TagNumber(2)
  set recipeId($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasRecipeId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecipeId() => clearField(2);

  @$pb.TagNumber(3)
  $13.PageRequest get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($13.PageRequest v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => clearField(3);
  @$pb.TagNumber(3)
  $13.PageRequest ensurePagination() => $_ensure(2);
}

class QueryListExecutionsByRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListExecutionsByRecipeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..pc<$9.Execution>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'completedExecutions', $pb.PbFieldType.PM, subBuilder: $9.Execution.create)
    ..pc<$9.Execution>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pendingExecutions', $pb.PbFieldType.PM, subBuilder: $9.Execution.create)
    ..aOM<$13.PageResponse>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $13.PageResponse.create)
    ..hasRequiredFields = false
  ;

  QueryListExecutionsByRecipeResponse._() : super();
  factory QueryListExecutionsByRecipeResponse({
    $core.Iterable<$9.Execution>? completedExecutions,
    $core.Iterable<$9.Execution>? pendingExecutions,
    $13.PageResponse? pagination,
  }) {
    final _result = create();
    if (completedExecutions != null) {
      _result.completedExecutions.addAll(completedExecutions);
    }
    if (pendingExecutions != null) {
      _result.pendingExecutions.addAll(pendingExecutions);
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryListExecutionsByRecipeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListExecutionsByRecipeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryListExecutionsByRecipeResponse clone() => QueryListExecutionsByRecipeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryListExecutionsByRecipeResponse copyWith(void Function(QueryListExecutionsByRecipeResponse) updates) => super.copyWith((message) => updates(message as QueryListExecutionsByRecipeResponse)) as QueryListExecutionsByRecipeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListExecutionsByRecipeResponse create() => QueryListExecutionsByRecipeResponse._();
  QueryListExecutionsByRecipeResponse createEmptyInstance() => create();
  static $pb.PbList<QueryListExecutionsByRecipeResponse> createRepeated() => $pb.PbList<QueryListExecutionsByRecipeResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryListExecutionsByRecipeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListExecutionsByRecipeResponse>(create);
  static QueryListExecutionsByRecipeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$9.Execution> get completedExecutions => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$9.Execution> get pendingExecutions => $_getList(1);

  @$pb.TagNumber(3)
  $13.PageResponse get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($13.PageResponse v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => clearField(3);
  @$pb.TagNumber(3)
  $13.PageResponse ensurePagination() => $_ensure(2);
}

class QueryGetExecutionRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetExecutionRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  QueryGetExecutionRequest._() : super();
  factory QueryGetExecutionRequest({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory QueryGetExecutionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetExecutionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetExecutionRequest clone() => QueryGetExecutionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetExecutionRequest copyWith(void Function(QueryGetExecutionRequest) updates) => super.copyWith((message) => updates(message as QueryGetExecutionRequest)) as QueryGetExecutionRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetExecutionRequest create() => QueryGetExecutionRequest._();
  QueryGetExecutionRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetExecutionRequest> createRepeated() => $pb.PbList<QueryGetExecutionRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetExecutionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetExecutionRequest>(create);
  static QueryGetExecutionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class QueryGetExecutionResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetExecutionResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOM<$9.Execution>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'execution', subBuilder: $9.Execution.create)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'completed')
    ..hasRequiredFields = false
  ;

  QueryGetExecutionResponse._() : super();
  factory QueryGetExecutionResponse({
    $9.Execution? execution,
    $core.bool? completed,
  }) {
    final _result = create();
    if (execution != null) {
      _result.execution = execution;
    }
    if (completed != null) {
      _result.completed = completed;
    }
    return _result;
  }
  factory QueryGetExecutionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetExecutionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetExecutionResponse clone() => QueryGetExecutionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetExecutionResponse copyWith(void Function(QueryGetExecutionResponse) updates) => super.copyWith((message) => updates(message as QueryGetExecutionResponse)) as QueryGetExecutionResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetExecutionResponse create() => QueryGetExecutionResponse._();
  QueryGetExecutionResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetExecutionResponse> createRepeated() => $pb.PbList<QueryGetExecutionResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetExecutionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetExecutionResponse>(create);
  static QueryGetExecutionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $9.Execution get execution => $_getN(0);
  @$pb.TagNumber(1)
  set execution($9.Execution v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasExecution() => $_has(0);
  @$pb.TagNumber(1)
  void clearExecution() => clearField(1);
  @$pb.TagNumber(1)
  $9.Execution ensureExecution() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get completed => $_getBF(1);
  @$pb.TagNumber(2)
  set completed($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasCompleted() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompleted() => clearField(2);
}

class QueryListRecipesByCookbookRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListRecipesByCookbookRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookId')
    ..aOM<$13.PageRequest>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $13.PageRequest.create)
    ..hasRequiredFields = false
  ;

  QueryListRecipesByCookbookRequest._() : super();
  factory QueryListRecipesByCookbookRequest({
    $core.String? cookbookId,
    $13.PageRequest? pagination,
  }) {
    final _result = create();
    if (cookbookId != null) {
      _result.cookbookId = cookbookId;
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryListRecipesByCookbookRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListRecipesByCookbookRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryListRecipesByCookbookRequest clone() => QueryListRecipesByCookbookRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryListRecipesByCookbookRequest copyWith(void Function(QueryListRecipesByCookbookRequest) updates) => super.copyWith((message) => updates(message as QueryListRecipesByCookbookRequest)) as QueryListRecipesByCookbookRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListRecipesByCookbookRequest create() => QueryListRecipesByCookbookRequest._();
  QueryListRecipesByCookbookRequest createEmptyInstance() => create();
  static $pb.PbList<QueryListRecipesByCookbookRequest> createRepeated() => $pb.PbList<QueryListRecipesByCookbookRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryListRecipesByCookbookRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListRecipesByCookbookRequest>(create);
  static QueryListRecipesByCookbookRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCookbookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookId() => clearField(1);

  @$pb.TagNumber(2)
  $13.PageRequest get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($13.PageRequest v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => clearField(2);
  @$pb.TagNumber(2)
  $13.PageRequest ensurePagination() => $_ensure(1);
}

class QueryListRecipesByCookbookResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListRecipesByCookbookResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..pc<$4.Recipe>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recipes', $pb.PbFieldType.PM, subBuilder: $4.Recipe.create)
    ..aOM<$13.PageResponse>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $13.PageResponse.create)
    ..hasRequiredFields = false
  ;

  QueryListRecipesByCookbookResponse._() : super();
  factory QueryListRecipesByCookbookResponse({
    $core.Iterable<$4.Recipe>? recipes,
    $13.PageResponse? pagination,
  }) {
    final _result = create();
    if (recipes != null) {
      _result.recipes.addAll(recipes);
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryListRecipesByCookbookResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListRecipesByCookbookResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryListRecipesByCookbookResponse clone() => QueryListRecipesByCookbookResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryListRecipesByCookbookResponse copyWith(void Function(QueryListRecipesByCookbookResponse) updates) => super.copyWith((message) => updates(message as QueryListRecipesByCookbookResponse)) as QueryListRecipesByCookbookResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListRecipesByCookbookResponse create() => QueryListRecipesByCookbookResponse._();
  QueryListRecipesByCookbookResponse createEmptyInstance() => create();
  static $pb.PbList<QueryListRecipesByCookbookResponse> createRepeated() => $pb.PbList<QueryListRecipesByCookbookResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryListRecipesByCookbookResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListRecipesByCookbookResponse>(create);
  static QueryListRecipesByCookbookResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$4.Recipe> get recipes => $_getList(0);

  @$pb.TagNumber(2)
  $13.PageResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($13.PageResponse v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => clearField(2);
  @$pb.TagNumber(2)
  $13.PageResponse ensurePagination() => $_ensure(1);
}

class QueryGetItemRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetItemRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookId')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  QueryGetItemRequest._() : super();
  factory QueryGetItemRequest({
    $core.String? cookbookId,
    $core.String? id,
  }) {
    final _result = create();
    if (cookbookId != null) {
      _result.cookbookId = cookbookId;
    }
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory QueryGetItemRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetItemRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetItemRequest clone() => QueryGetItemRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetItemRequest copyWith(void Function(QueryGetItemRequest) updates) => super.copyWith((message) => updates(message as QueryGetItemRequest)) as QueryGetItemRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetItemRequest create() => QueryGetItemRequest._();
  QueryGetItemRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetItemRequest> createRepeated() => $pb.PbList<QueryGetItemRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetItemRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetItemRequest>(create);
  static QueryGetItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCookbookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookId() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(3)
  set id($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(3)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(3)
  void clearId() => clearField(3);
}

class QueryGetItemResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetItemResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOM<$3.Item>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'item', subBuilder: $3.Item.create)
    ..hasRequiredFields = false
  ;

  QueryGetItemResponse._() : super();
  factory QueryGetItemResponse({
    $3.Item? item,
  }) {
    final _result = create();
    if (item != null) {
      _result.item = item;
    }
    return _result;
  }
  factory QueryGetItemResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetItemResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetItemResponse clone() => QueryGetItemResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetItemResponse copyWith(void Function(QueryGetItemResponse) updates) => super.copyWith((message) => updates(message as QueryGetItemResponse)) as QueryGetItemResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetItemResponse create() => QueryGetItemResponse._();
  QueryGetItemResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetItemResponse> createRepeated() => $pb.PbList<QueryGetItemResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetItemResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetItemResponse>(create);
  static QueryGetItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $3.Item get item => $_getN(0);
  @$pb.TagNumber(1)
  set item($3.Item v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => clearField(1);
  @$pb.TagNumber(1)
  $3.Item ensureItem() => $_ensure(0);
}

class QueryGetRecipeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetRecipeRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookId')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  QueryGetRecipeRequest._() : super();
  factory QueryGetRecipeRequest({
    $core.String? cookbookId,
    $core.String? id,
  }) {
    final _result = create();
    if (cookbookId != null) {
      _result.cookbookId = cookbookId;
    }
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory QueryGetRecipeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetRecipeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetRecipeRequest clone() => QueryGetRecipeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetRecipeRequest copyWith(void Function(QueryGetRecipeRequest) updates) => super.copyWith((message) => updates(message as QueryGetRecipeRequest)) as QueryGetRecipeRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetRecipeRequest create() => QueryGetRecipeRequest._();
  QueryGetRecipeRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetRecipeRequest> createRepeated() => $pb.PbList<QueryGetRecipeRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetRecipeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetRecipeRequest>(create);
  static QueryGetRecipeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookId => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCookbookId() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => clearField(2);
}

class QueryGetRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetRecipeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOM<$4.Recipe>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recipe', subBuilder: $4.Recipe.create)
    ..hasRequiredFields = false
  ;

  QueryGetRecipeResponse._() : super();
  factory QueryGetRecipeResponse({
    $4.Recipe? recipe,
  }) {
    final _result = create();
    if (recipe != null) {
      _result.recipe = recipe;
    }
    return _result;
  }
  factory QueryGetRecipeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetRecipeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetRecipeResponse clone() => QueryGetRecipeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetRecipeResponse copyWith(void Function(QueryGetRecipeResponse) updates) => super.copyWith((message) => updates(message as QueryGetRecipeResponse)) as QueryGetRecipeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetRecipeResponse create() => QueryGetRecipeResponse._();
  QueryGetRecipeResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetRecipeResponse> createRepeated() => $pb.PbList<QueryGetRecipeResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetRecipeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetRecipeResponse>(create);
  static QueryGetRecipeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $4.Recipe get recipe => $_getN(0);
  @$pb.TagNumber(1)
  set recipe($4.Recipe v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasRecipe() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecipe() => clearField(1);
  @$pb.TagNumber(1)
  $4.Recipe ensureRecipe() => $_ensure(0);
}

class QueryListCookbooksByCreatorRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListCookbooksByCreatorRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOM<$13.PageRequest>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $13.PageRequest.create)
    ..hasRequiredFields = false
  ;

  QueryListCookbooksByCreatorRequest._() : super();
  factory QueryListCookbooksByCreatorRequest({
    $core.String? creator,
    $13.PageRequest? pagination,
  }) {
    final _result = create();
    if (creator != null) {
      _result.creator = creator;
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryListCookbooksByCreatorRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListCookbooksByCreatorRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryListCookbooksByCreatorRequest clone() => QueryListCookbooksByCreatorRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryListCookbooksByCreatorRequest copyWith(void Function(QueryListCookbooksByCreatorRequest) updates) => super.copyWith((message) => updates(message as QueryListCookbooksByCreatorRequest)) as QueryListCookbooksByCreatorRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListCookbooksByCreatorRequest create() => QueryListCookbooksByCreatorRequest._();
  QueryListCookbooksByCreatorRequest createEmptyInstance() => create();
  static $pb.PbList<QueryListCookbooksByCreatorRequest> createRepeated() => $pb.PbList<QueryListCookbooksByCreatorRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryListCookbooksByCreatorRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListCookbooksByCreatorRequest>(create);
  static QueryListCookbooksByCreatorRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get creator => $_getSZ(0);
  @$pb.TagNumber(1)
  set creator($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(3)
  $13.PageRequest get pagination => $_getN(1);
  @$pb.TagNumber(3)
  set pagination($13.PageRequest v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(3)
  void clearPagination() => clearField(3);
  @$pb.TagNumber(3)
  $13.PageRequest ensurePagination() => $_ensure(1);
}

class QueryListCookbooksByCreatorResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListCookbooksByCreatorResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..pc<$6.Cookbook>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbooks', $pb.PbFieldType.PM, subBuilder: $6.Cookbook.create)
    ..aOM<$13.PageResponse>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $13.PageResponse.create)
    ..hasRequiredFields = false
  ;

  QueryListCookbooksByCreatorResponse._() : super();
  factory QueryListCookbooksByCreatorResponse({
    $core.Iterable<$6.Cookbook>? cookbooks,
    $13.PageResponse? pagination,
  }) {
    final _result = create();
    if (cookbooks != null) {
      _result.cookbooks.addAll(cookbooks);
    }
    if (pagination != null) {
      _result.pagination = pagination;
    }
    return _result;
  }
  factory QueryListCookbooksByCreatorResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListCookbooksByCreatorResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryListCookbooksByCreatorResponse clone() => QueryListCookbooksByCreatorResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryListCookbooksByCreatorResponse copyWith(void Function(QueryListCookbooksByCreatorResponse) updates) => super.copyWith((message) => updates(message as QueryListCookbooksByCreatorResponse)) as QueryListCookbooksByCreatorResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListCookbooksByCreatorResponse create() => QueryListCookbooksByCreatorResponse._();
  QueryListCookbooksByCreatorResponse createEmptyInstance() => create();
  static $pb.PbList<QueryListCookbooksByCreatorResponse> createRepeated() => $pb.PbList<QueryListCookbooksByCreatorResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryListCookbooksByCreatorResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListCookbooksByCreatorResponse>(create);
  static QueryListCookbooksByCreatorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$6.Cookbook> get cookbooks => $_getList(0);

  @$pb.TagNumber(3)
  $13.PageResponse get pagination => $_getN(1);
  @$pb.TagNumber(3)
  set pagination($13.PageResponse v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(3)
  void clearPagination() => clearField(3);
  @$pb.TagNumber(3)
  $13.PageResponse ensurePagination() => $_ensure(1);
}

class QueryGetCookbookRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetCookbookRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'id')
    ..hasRequiredFields = false
  ;

  QueryGetCookbookRequest._() : super();
  factory QueryGetCookbookRequest({
    $core.String? id,
  }) {
    final _result = create();
    if (id != null) {
      _result.id = id;
    }
    return _result;
  }
  factory QueryGetCookbookRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetCookbookRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetCookbookRequest clone() => QueryGetCookbookRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetCookbookRequest copyWith(void Function(QueryGetCookbookRequest) updates) => super.copyWith((message) => updates(message as QueryGetCookbookRequest)) as QueryGetCookbookRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetCookbookRequest create() => QueryGetCookbookRequest._();
  QueryGetCookbookRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetCookbookRequest> createRepeated() => $pb.PbList<QueryGetCookbookRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetCookbookRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetCookbookRequest>(create);
  static QueryGetCookbookRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class QueryGetCookbookResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetCookbookResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons.pylons'), createEmptyInstance: create)
    ..aOM<$6.Cookbook>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbook', subBuilder: $6.Cookbook.create)
    ..hasRequiredFields = false
  ;

  QueryGetCookbookResponse._() : super();
  factory QueryGetCookbookResponse({
    $6.Cookbook? cookbook,
  }) {
    final _result = create();
    if (cookbook != null) {
      _result.cookbook = cookbook;
    }
    return _result;
  }
  factory QueryGetCookbookResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetCookbookResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QueryGetCookbookResponse clone() => QueryGetCookbookResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QueryGetCookbookResponse copyWith(void Function(QueryGetCookbookResponse) updates) => super.copyWith((message) => updates(message as QueryGetCookbookResponse)) as QueryGetCookbookResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetCookbookResponse create() => QueryGetCookbookResponse._();
  QueryGetCookbookResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetCookbookResponse> createRepeated() => $pb.PbList<QueryGetCookbookResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetCookbookResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetCookbookResponse>(create);
  static QueryGetCookbookResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $6.Cookbook get cookbook => $_getN(0);
  @$pb.TagNumber(1)
  set cookbook($6.Cookbook v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasCookbook() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbook() => clearField(1);
  @$pb.TagNumber(1)
  $6.Cookbook ensureCookbook() => $_ensure(0);
}
