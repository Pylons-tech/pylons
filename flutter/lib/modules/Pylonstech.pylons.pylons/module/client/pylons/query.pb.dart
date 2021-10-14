///
//  Generated code. Do not modify.
//  source: pylons/query.proto
//

// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'accounts.pb.dart' as $10;
import 'trade.pb.dart' as $6;
import '../cosmos/base/query/v1beta1/pagination.pb.dart' as $12;
import 'item.pb.dart' as $3;
import 'google_iap_order.pb.dart' as $8;
import 'execution.pb.dart' as $7;
import 'recipe.pb.dart' as $4;
import 'cookbook.pb.dart' as $5;

class QueryGetUsernameByAddressRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetUsernameByAddressRequest',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..hasRequiredFields = false;

  QueryGetUsernameByAddressRequest._() : super();
  factory QueryGetUsernameByAddressRequest() => create();
  factory QueryGetUsernameByAddressRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetUsernameByAddressRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryGetUsernameByAddressRequest clone() => QueryGetUsernameByAddressRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryGetUsernameByAddressRequest copyWith(void Function(QueryGetUsernameByAddressRequest) updates) =>
      super.copyWith((message) => updates(message as QueryGetUsernameByAddressRequest)) as QueryGetUsernameByAddressRequest; // ignore: deprecated_member_use
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
  set address($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);
}

class QueryGetAddressByUsernameRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetAddressByUsernameRequest',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username')
    ..hasRequiredFields = false;

  QueryGetAddressByUsernameRequest._() : super();
  factory QueryGetAddressByUsernameRequest() => create();
  factory QueryGetAddressByUsernameRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetAddressByUsernameRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryGetAddressByUsernameRequest clone() => QueryGetAddressByUsernameRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryGetAddressByUsernameRequest copyWith(void Function(QueryGetAddressByUsernameRequest) updates) =>
      super.copyWith((message) => updates(message as QueryGetAddressByUsernameRequest)) as QueryGetAddressByUsernameRequest; // ignore: deprecated_member_use
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
  set username($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => clearField(1);
}

class QueryGetUsernameByAddressResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetUsernameByAddressResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOM<$10.Username>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'username', subBuilder: $10.Username.create)
    ..hasRequiredFields = false;

  QueryGetUsernameByAddressResponse._() : super();
  factory QueryGetUsernameByAddressResponse() => create();
  factory QueryGetUsernameByAddressResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetUsernameByAddressResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryGetUsernameByAddressResponse clone() => QueryGetUsernameByAddressResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryGetUsernameByAddressResponse copyWith(void Function(QueryGetUsernameByAddressResponse) updates) =>
      super.copyWith((message) => updates(message as QueryGetUsernameByAddressResponse)) as QueryGetUsernameByAddressResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetUsernameByAddressResponse create() => QueryGetUsernameByAddressResponse._();
  QueryGetUsernameByAddressResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetUsernameByAddressResponse> createRepeated() => $pb.PbList<QueryGetUsernameByAddressResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetUsernameByAddressResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetUsernameByAddressResponse>(create);
  static QueryGetUsernameByAddressResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $10.Username get username => $_getN(0);
  @$pb.TagNumber(1)
  set username($10.Username v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasUsername() => $_has(0);
  @$pb.TagNumber(1)
  void clearUsername() => clearField(1);
  @$pb.TagNumber(1)
  $10.Username ensureUsername() => $_ensure(0);
}

class QueryGetAddressByUsernameResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetAddressByUsernameResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOM<$10.AccountAddr>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address', subBuilder: $10.AccountAddr.create)
    ..hasRequiredFields = false;

  QueryGetAddressByUsernameResponse._() : super();
  factory QueryGetAddressByUsernameResponse() => create();
  factory QueryGetAddressByUsernameResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetAddressByUsernameResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryGetAddressByUsernameResponse clone() => QueryGetAddressByUsernameResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryGetAddressByUsernameResponse copyWith(void Function(QueryGetAddressByUsernameResponse) updates) =>
      super.copyWith((message) => updates(message as QueryGetAddressByUsernameResponse)) as QueryGetAddressByUsernameResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetAddressByUsernameResponse create() => QueryGetAddressByUsernameResponse._();
  QueryGetAddressByUsernameResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetAddressByUsernameResponse> createRepeated() => $pb.PbList<QueryGetAddressByUsernameResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetAddressByUsernameResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetAddressByUsernameResponse>(create);
  static QueryGetAddressByUsernameResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $10.AccountAddr get address => $_getN(0);
  @$pb.TagNumber(1)
  set address($10.AccountAddr v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);
  @$pb.TagNumber(1)
  $10.AccountAddr ensureAddress() => $_ensure(0);
}

class QueryGetTradeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetTradeRequest',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', $pb.PbFieldType.OU6, protoName: 'ID', defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false;

  QueryGetTradeRequest._() : super();
  factory QueryGetTradeRequest() => create();
  factory QueryGetTradeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetTradeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryGetTradeRequest clone() => QueryGetTradeRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryGetTradeRequest copyWith(void Function(QueryGetTradeRequest) updates) =>
      super.copyWith((message) => updates(message as QueryGetTradeRequest)) as QueryGetTradeRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetTradeRequest create() => QueryGetTradeRequest._();
  QueryGetTradeRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetTradeRequest> createRepeated() => $pb.PbList<QueryGetTradeRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetTradeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetTradeRequest>(create);
  static QueryGetTradeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get iD => $_getI64(0);
  @$pb.TagNumber(1)
  set iD($fixnum.Int64 v) {
    $_setInt64(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasID() => $_has(0);
  @$pb.TagNumber(1)
  void clearID() => clearField(1);
}

class QueryGetTradeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetTradeResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOM<$6.Trade>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Trade', protoName: 'Trade', subBuilder: $6.Trade.create)
    ..hasRequiredFields = false;

  QueryGetTradeResponse._() : super();
  factory QueryGetTradeResponse() => create();
  factory QueryGetTradeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetTradeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryGetTradeResponse clone() => QueryGetTradeResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryGetTradeResponse copyWith(void Function(QueryGetTradeResponse) updates) =>
      super.copyWith((message) => updates(message as QueryGetTradeResponse)) as QueryGetTradeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetTradeResponse create() => QueryGetTradeResponse._();
  QueryGetTradeResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetTradeResponse> createRepeated() => $pb.PbList<QueryGetTradeResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetTradeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetTradeResponse>(create);
  static QueryGetTradeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $6.Trade get trade => $_getN(0);
  @$pb.TagNumber(1)
  set trade($6.Trade v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasTrade() => $_has(0);
  @$pb.TagNumber(1)
  void clearTrade() => clearField(1);
  @$pb.TagNumber(1)
  $6.Trade ensureTrade() => $_ensure(0);
}

class QueryListItemByOwnerRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListItemByOwnerRequest',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'owner')
    ..aOM<$12.PageRequest>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $12.PageRequest.create)
    ..hasRequiredFields = false;

  QueryListItemByOwnerRequest._() : super();
  factory QueryListItemByOwnerRequest() => create();
  factory QueryListItemByOwnerRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListItemByOwnerRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryListItemByOwnerRequest clone() => QueryListItemByOwnerRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryListItemByOwnerRequest copyWith(void Function(QueryListItemByOwnerRequest) updates) =>
      super.copyWith((message) => updates(message as QueryListItemByOwnerRequest)) as QueryListItemByOwnerRequest; // ignore: deprecated_member_use
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
  set owner($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOwner() => $_has(0);
  @$pb.TagNumber(1)
  void clearOwner() => clearField(1);

  @$pb.TagNumber(3)
  $12.PageRequest get pagination => $_getN(1);
  @$pb.TagNumber(3)
  set pagination($12.PageRequest v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(3)
  void clearPagination() => clearField(3);
  @$pb.TagNumber(3)
  $12.PageRequest ensurePagination() => $_ensure(1);
}

class QueryListItemByOwnerResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListItemByOwnerResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..pc<$3.Item>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Items', $pb.PbFieldType.PM, protoName: 'Items', subBuilder: $3.Item.create)
    ..aOM<$12.PageResponse>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $12.PageResponse.create)
    ..hasRequiredFields = false;

  QueryListItemByOwnerResponse._() : super();
  factory QueryListItemByOwnerResponse() => create();
  factory QueryListItemByOwnerResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListItemByOwnerResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryListItemByOwnerResponse clone() => QueryListItemByOwnerResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryListItemByOwnerResponse copyWith(void Function(QueryListItemByOwnerResponse) updates) =>
      super.copyWith((message) => updates(message as QueryListItemByOwnerResponse)) as QueryListItemByOwnerResponse; // ignore: deprecated_member_use
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
  $12.PageResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($12.PageResponse v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => clearField(2);
  @$pb.TagNumber(2)
  $12.PageResponse ensurePagination() => $_ensure(1);
}

class QueryGetGoogleInAppPurchaseOrderRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetGoogleInAppPurchaseOrderRequest',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'PurchaseToken', protoName: 'PurchaseToken')
    ..hasRequiredFields = false;

  QueryGetGoogleInAppPurchaseOrderRequest._() : super();
  factory QueryGetGoogleInAppPurchaseOrderRequest() => create();
  factory QueryGetGoogleInAppPurchaseOrderRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetGoogleInAppPurchaseOrderRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryGetGoogleInAppPurchaseOrderRequest clone() => QueryGetGoogleInAppPurchaseOrderRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryGetGoogleInAppPurchaseOrderRequest copyWith(void Function(QueryGetGoogleInAppPurchaseOrderRequest) updates) =>
      super.copyWith((message) => updates(message as QueryGetGoogleInAppPurchaseOrderRequest)) as QueryGetGoogleInAppPurchaseOrderRequest; // ignore: deprecated_member_use
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
  set purchaseToken($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasPurchaseToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearPurchaseToken() => clearField(1);
}

class QueryGetGoogleInAppPurchaseOrderResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetGoogleInAppPurchaseOrderResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOM<$8.GoogleInAppPurchaseOrder>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Order', protoName: 'Order', subBuilder: $8.GoogleInAppPurchaseOrder.create)
    ..hasRequiredFields = false;

  QueryGetGoogleInAppPurchaseOrderResponse._() : super();
  factory QueryGetGoogleInAppPurchaseOrderResponse() => create();
  factory QueryGetGoogleInAppPurchaseOrderResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetGoogleInAppPurchaseOrderResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryGetGoogleInAppPurchaseOrderResponse clone() => QueryGetGoogleInAppPurchaseOrderResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryGetGoogleInAppPurchaseOrderResponse copyWith(void Function(QueryGetGoogleInAppPurchaseOrderResponse) updates) =>
      super.copyWith((message) => updates(message as QueryGetGoogleInAppPurchaseOrderResponse)) as QueryGetGoogleInAppPurchaseOrderResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetGoogleInAppPurchaseOrderResponse create() => QueryGetGoogleInAppPurchaseOrderResponse._();
  QueryGetGoogleInAppPurchaseOrderResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetGoogleInAppPurchaseOrderResponse> createRepeated() => $pb.PbList<QueryGetGoogleInAppPurchaseOrderResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetGoogleInAppPurchaseOrderResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetGoogleInAppPurchaseOrderResponse>(create);
  static QueryGetGoogleInAppPurchaseOrderResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $8.GoogleInAppPurchaseOrder get order => $_getN(0);
  @$pb.TagNumber(1)
  set order($8.GoogleInAppPurchaseOrder v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearOrder() => clearField(1);
  @$pb.TagNumber(1)
  $8.GoogleInAppPurchaseOrder ensureOrder() => $_ensure(0);
}

class QueryListExecutionsByItemRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListExecutionsByItemRequest',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemID', protoName: 'ItemID')
    ..aOM<$12.PageRequest>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $12.PageRequest.create)
    ..hasRequiredFields = false;

  QueryListExecutionsByItemRequest._() : super();
  factory QueryListExecutionsByItemRequest() => create();
  factory QueryListExecutionsByItemRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListExecutionsByItemRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryListExecutionsByItemRequest clone() => QueryListExecutionsByItemRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryListExecutionsByItemRequest copyWith(void Function(QueryListExecutionsByItemRequest) updates) =>
      super.copyWith((message) => updates(message as QueryListExecutionsByItemRequest)) as QueryListExecutionsByItemRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListExecutionsByItemRequest create() => QueryListExecutionsByItemRequest._();
  QueryListExecutionsByItemRequest createEmptyInstance() => create();
  static $pb.PbList<QueryListExecutionsByItemRequest> createRepeated() => $pb.PbList<QueryListExecutionsByItemRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryListExecutionsByItemRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListExecutionsByItemRequest>(create);
  static QueryListExecutionsByItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookID => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookID($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCookbookID() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get itemID => $_getSZ(1);
  @$pb.TagNumber(2)
  set itemID($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasItemID() => $_has(1);
  @$pb.TagNumber(2)
  void clearItemID() => clearField(2);

  @$pb.TagNumber(3)
  $12.PageRequest get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($12.PageRequest v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => clearField(3);
  @$pb.TagNumber(3)
  $12.PageRequest ensurePagination() => $_ensure(2);
}

class QueryListExecutionsByItemResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListExecutionsByItemResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..pc<$7.Execution>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CompletedExecutions', $pb.PbFieldType.PM,
        protoName: 'CompletedExecutions', subBuilder: $7.Execution.create)
    ..pc<$7.Execution>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'PendingExecutions', $pb.PbFieldType.PM, protoName: 'PendingExecutions', subBuilder: $7.Execution.create)
    ..aOM<$12.PageResponse>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $12.PageResponse.create)
    ..hasRequiredFields = false;

  QueryListExecutionsByItemResponse._() : super();
  factory QueryListExecutionsByItemResponse() => create();
  factory QueryListExecutionsByItemResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListExecutionsByItemResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryListExecutionsByItemResponse clone() => QueryListExecutionsByItemResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryListExecutionsByItemResponse copyWith(void Function(QueryListExecutionsByItemResponse) updates) =>
      super.copyWith((message) => updates(message as QueryListExecutionsByItemResponse)) as QueryListExecutionsByItemResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListExecutionsByItemResponse create() => QueryListExecutionsByItemResponse._();
  QueryListExecutionsByItemResponse createEmptyInstance() => create();
  static $pb.PbList<QueryListExecutionsByItemResponse> createRepeated() => $pb.PbList<QueryListExecutionsByItemResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryListExecutionsByItemResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListExecutionsByItemResponse>(create);
  static QueryListExecutionsByItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$7.Execution> get completedExecutions => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$7.Execution> get pendingExecutions => $_getList(1);

  @$pb.TagNumber(3)
  $12.PageResponse get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($12.PageResponse v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => clearField(3);
  @$pb.TagNumber(3)
  $12.PageResponse ensurePagination() => $_ensure(2);
}

class QueryListExecutionsByRecipeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListExecutionsByRecipeRequest',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'RecipeID', protoName: 'RecipeID')
    ..aOM<$12.PageRequest>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $12.PageRequest.create)
    ..hasRequiredFields = false;

  QueryListExecutionsByRecipeRequest._() : super();
  factory QueryListExecutionsByRecipeRequest() => create();
  factory QueryListExecutionsByRecipeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListExecutionsByRecipeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryListExecutionsByRecipeRequest clone() => QueryListExecutionsByRecipeRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryListExecutionsByRecipeRequest copyWith(void Function(QueryListExecutionsByRecipeRequest) updates) =>
      super.copyWith((message) => updates(message as QueryListExecutionsByRecipeRequest)) as QueryListExecutionsByRecipeRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListExecutionsByRecipeRequest create() => QueryListExecutionsByRecipeRequest._();
  QueryListExecutionsByRecipeRequest createEmptyInstance() => create();
  static $pb.PbList<QueryListExecutionsByRecipeRequest> createRepeated() => $pb.PbList<QueryListExecutionsByRecipeRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryListExecutionsByRecipeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListExecutionsByRecipeRequest>(create);
  static QueryListExecutionsByRecipeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookID => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookID($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCookbookID() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get recipeID => $_getSZ(1);
  @$pb.TagNumber(2)
  set recipeID($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasRecipeID() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecipeID() => clearField(2);

  @$pb.TagNumber(3)
  $12.PageRequest get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($12.PageRequest v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => clearField(3);
  @$pb.TagNumber(3)
  $12.PageRequest ensurePagination() => $_ensure(2);
}

class QueryListExecutionsByRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListExecutionsByRecipeResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..pc<$7.Execution>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CompletedExecutions', $pb.PbFieldType.PM,
        protoName: 'CompletedExecutions', subBuilder: $7.Execution.create)
    ..pc<$7.Execution>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'PendingExecutions', $pb.PbFieldType.PM, protoName: 'PendingExecutions', subBuilder: $7.Execution.create)
    ..aOM<$12.PageResponse>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $12.PageResponse.create)
    ..hasRequiredFields = false;

  QueryListExecutionsByRecipeResponse._() : super();
  factory QueryListExecutionsByRecipeResponse() => create();
  factory QueryListExecutionsByRecipeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListExecutionsByRecipeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryListExecutionsByRecipeResponse clone() => QueryListExecutionsByRecipeResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryListExecutionsByRecipeResponse copyWith(void Function(QueryListExecutionsByRecipeResponse) updates) =>
      super.copyWith((message) => updates(message as QueryListExecutionsByRecipeResponse)) as QueryListExecutionsByRecipeResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListExecutionsByRecipeResponse create() => QueryListExecutionsByRecipeResponse._();
  QueryListExecutionsByRecipeResponse createEmptyInstance() => create();
  static $pb.PbList<QueryListExecutionsByRecipeResponse> createRepeated() => $pb.PbList<QueryListExecutionsByRecipeResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryListExecutionsByRecipeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListExecutionsByRecipeResponse>(create);
  static QueryListExecutionsByRecipeResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$7.Execution> get completedExecutions => $_getList(0);

  @$pb.TagNumber(2)
  $core.List<$7.Execution> get pendingExecutions => $_getList(1);

  @$pb.TagNumber(3)
  $12.PageResponse get pagination => $_getN(2);
  @$pb.TagNumber(3)
  set pagination($12.PageResponse v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(2);
  @$pb.TagNumber(3)
  void clearPagination() => clearField(3);
  @$pb.TagNumber(3)
  $12.PageResponse ensurePagination() => $_ensure(2);
}

class QueryGetExecutionRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetExecutionRequest',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..hasRequiredFields = false;

  QueryGetExecutionRequest._() : super();
  factory QueryGetExecutionRequest() => create();
  factory QueryGetExecutionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetExecutionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryGetExecutionRequest clone() => QueryGetExecutionRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryGetExecutionRequest copyWith(void Function(QueryGetExecutionRequest) updates) =>
      super.copyWith((message) => updates(message as QueryGetExecutionRequest)) as QueryGetExecutionRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetExecutionRequest create() => QueryGetExecutionRequest._();
  QueryGetExecutionRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetExecutionRequest> createRepeated() => $pb.PbList<QueryGetExecutionRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetExecutionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetExecutionRequest>(create);
  static QueryGetExecutionRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iD => $_getSZ(0);
  @$pb.TagNumber(1)
  set iD($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasID() => $_has(0);
  @$pb.TagNumber(1)
  void clearID() => clearField(1);
}

class QueryGetExecutionResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetExecutionResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOM<$7.Execution>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Execution', protoName: 'Execution', subBuilder: $7.Execution.create)
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Completed', protoName: 'Completed')
    ..hasRequiredFields = false;

  QueryGetExecutionResponse._() : super();
  factory QueryGetExecutionResponse() => create();
  factory QueryGetExecutionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetExecutionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryGetExecutionResponse clone() => QueryGetExecutionResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryGetExecutionResponse copyWith(void Function(QueryGetExecutionResponse) updates) =>
      super.copyWith((message) => updates(message as QueryGetExecutionResponse)) as QueryGetExecutionResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetExecutionResponse create() => QueryGetExecutionResponse._();
  QueryGetExecutionResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetExecutionResponse> createRepeated() => $pb.PbList<QueryGetExecutionResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetExecutionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetExecutionResponse>(create);
  static QueryGetExecutionResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $7.Execution get execution => $_getN(0);
  @$pb.TagNumber(1)
  set execution($7.Execution v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasExecution() => $_has(0);
  @$pb.TagNumber(1)
  void clearExecution() => clearField(1);
  @$pb.TagNumber(1)
  $7.Execution ensureExecution() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get completed => $_getBF(1);
  @$pb.TagNumber(2)
  set completed($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasCompleted() => $_has(1);
  @$pb.TagNumber(2)
  void clearCompleted() => clearField(2);
}

class QueryListRecipesByCookbookRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListRecipesByCookbookRequest',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..aOM<$12.PageRequest>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $12.PageRequest.create)
    ..hasRequiredFields = false;

  QueryListRecipesByCookbookRequest._() : super();
  factory QueryListRecipesByCookbookRequest() => create();
  factory QueryListRecipesByCookbookRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListRecipesByCookbookRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryListRecipesByCookbookRequest clone() => QueryListRecipesByCookbookRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryListRecipesByCookbookRequest copyWith(void Function(QueryListRecipesByCookbookRequest) updates) =>
      super.copyWith((message) => updates(message as QueryListRecipesByCookbookRequest)) as QueryListRecipesByCookbookRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListRecipesByCookbookRequest create() => QueryListRecipesByCookbookRequest._();
  QueryListRecipesByCookbookRequest createEmptyInstance() => create();
  static $pb.PbList<QueryListRecipesByCookbookRequest> createRepeated() => $pb.PbList<QueryListRecipesByCookbookRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryListRecipesByCookbookRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListRecipesByCookbookRequest>(create);
  static QueryListRecipesByCookbookRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookID => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookID($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCookbookID() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookID() => clearField(1);

  @$pb.TagNumber(2)
  $12.PageRequest get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($12.PageRequest v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => clearField(2);
  @$pb.TagNumber(2)
  $12.PageRequest ensurePagination() => $_ensure(1);
}

class QueryListRecipesByCookbookResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListRecipesByCookbookResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..pc<$4.Recipe>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Recipes', $pb.PbFieldType.PM, protoName: 'Recipes', subBuilder: $4.Recipe.create)
    ..aOM<$12.PageResponse>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $12.PageResponse.create)
    ..hasRequiredFields = false;

  QueryListRecipesByCookbookResponse._() : super();
  factory QueryListRecipesByCookbookResponse() => create();
  factory QueryListRecipesByCookbookResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListRecipesByCookbookResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryListRecipesByCookbookResponse clone() => QueryListRecipesByCookbookResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryListRecipesByCookbookResponse copyWith(void Function(QueryListRecipesByCookbookResponse) updates) =>
      super.copyWith((message) => updates(message as QueryListRecipesByCookbookResponse)) as QueryListRecipesByCookbookResponse; // ignore: deprecated_member_use
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
  $12.PageResponse get pagination => $_getN(1);
  @$pb.TagNumber(2)
  set pagination($12.PageResponse v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(2)
  void clearPagination() => clearField(2);
  @$pb.TagNumber(2)
  $12.PageResponse ensurePagination() => $_ensure(1);
}

class QueryGetItemRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetItemRequest',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..hasRequiredFields = false;

  QueryGetItemRequest._() : super();
  factory QueryGetItemRequest() => create();
  factory QueryGetItemRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetItemRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryGetItemRequest clone() => QueryGetItemRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryGetItemRequest copyWith(void Function(QueryGetItemRequest) updates) =>
      super.copyWith((message) => updates(message as QueryGetItemRequest)) as QueryGetItemRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetItemRequest create() => QueryGetItemRequest._();
  QueryGetItemRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetItemRequest> createRepeated() => $pb.PbList<QueryGetItemRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetItemRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetItemRequest>(create);
  static QueryGetItemRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookID => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookID($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCookbookID() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookID() => clearField(1);

  @$pb.TagNumber(3)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(3)
  set iD($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(3)
  void clearID() => clearField(3);
}

class QueryGetItemResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetItemResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOM<$3.Item>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Item', protoName: 'Item', subBuilder: $3.Item.create)
    ..hasRequiredFields = false;

  QueryGetItemResponse._() : super();
  factory QueryGetItemResponse() => create();
  factory QueryGetItemResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetItemResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryGetItemResponse clone() => QueryGetItemResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryGetItemResponse copyWith(void Function(QueryGetItemResponse) updates) =>
      super.copyWith((message) => updates(message as QueryGetItemResponse)) as QueryGetItemResponse; // ignore: deprecated_member_use
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
  set item($3.Item v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasItem() => $_has(0);
  @$pb.TagNumber(1)
  void clearItem() => clearField(1);
  @$pb.TagNumber(1)
  $3.Item ensureItem() => $_ensure(0);
}

class QueryGetRecipeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetRecipeRequest',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..hasRequiredFields = false;

  QueryGetRecipeRequest._() : super();
  factory QueryGetRecipeRequest() => create();
  factory QueryGetRecipeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetRecipeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryGetRecipeRequest clone() => QueryGetRecipeRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryGetRecipeRequest copyWith(void Function(QueryGetRecipeRequest) updates) =>
      super.copyWith((message) => updates(message as QueryGetRecipeRequest)) as QueryGetRecipeRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetRecipeRequest create() => QueryGetRecipeRequest._();
  QueryGetRecipeRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetRecipeRequest> createRepeated() => $pb.PbList<QueryGetRecipeRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetRecipeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetRecipeRequest>(create);
  static QueryGetRecipeRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookID => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookID($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCookbookID() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookID() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);
}

class QueryGetRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetRecipeResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOM<$4.Recipe>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Recipe', protoName: 'Recipe', subBuilder: $4.Recipe.create)
    ..hasRequiredFields = false;

  QueryGetRecipeResponse._() : super();
  factory QueryGetRecipeResponse() => create();
  factory QueryGetRecipeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetRecipeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryGetRecipeResponse clone() => QueryGetRecipeResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryGetRecipeResponse copyWith(void Function(QueryGetRecipeResponse) updates) =>
      super.copyWith((message) => updates(message as QueryGetRecipeResponse)) as QueryGetRecipeResponse; // ignore: deprecated_member_use
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
  set recipe($4.Recipe v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasRecipe() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecipe() => clearField(1);
  @$pb.TagNumber(1)
  $4.Recipe ensureRecipe() => $_ensure(0);
}

class QueryListCookbooksByCreatorRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListCookbooksByCreatorRequest',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'creator')
    ..aOM<$12.PageRequest>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $12.PageRequest.create)
    ..hasRequiredFields = false;

  QueryListCookbooksByCreatorRequest._() : super();
  factory QueryListCookbooksByCreatorRequest() => create();
  factory QueryListCookbooksByCreatorRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListCookbooksByCreatorRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryListCookbooksByCreatorRequest clone() => QueryListCookbooksByCreatorRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryListCookbooksByCreatorRequest copyWith(void Function(QueryListCookbooksByCreatorRequest) updates) =>
      super.copyWith((message) => updates(message as QueryListCookbooksByCreatorRequest)) as QueryListCookbooksByCreatorRequest; // ignore: deprecated_member_use
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
  set creator($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCreator() => $_has(0);
  @$pb.TagNumber(1)
  void clearCreator() => clearField(1);

  @$pb.TagNumber(3)
  $12.PageRequest get pagination => $_getN(1);
  @$pb.TagNumber(3)
  set pagination($12.PageRequest v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(3)
  void clearPagination() => clearField(3);
  @$pb.TagNumber(3)
  $12.PageRequest ensurePagination() => $_ensure(1);
}

class QueryListCookbooksByCreatorResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryListCookbooksByCreatorResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..pc<$5.Cookbook>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Cookbooks', $pb.PbFieldType.PM, protoName: 'Cookbooks', subBuilder: $5.Cookbook.create)
    ..aOM<$12.PageResponse>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'pagination', subBuilder: $12.PageResponse.create)
    ..hasRequiredFields = false;

  QueryListCookbooksByCreatorResponse._() : super();
  factory QueryListCookbooksByCreatorResponse() => create();
  factory QueryListCookbooksByCreatorResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryListCookbooksByCreatorResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryListCookbooksByCreatorResponse clone() => QueryListCookbooksByCreatorResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryListCookbooksByCreatorResponse copyWith(void Function(QueryListCookbooksByCreatorResponse) updates) =>
      super.copyWith((message) => updates(message as QueryListCookbooksByCreatorResponse)) as QueryListCookbooksByCreatorResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryListCookbooksByCreatorResponse create() => QueryListCookbooksByCreatorResponse._();
  QueryListCookbooksByCreatorResponse createEmptyInstance() => create();
  static $pb.PbList<QueryListCookbooksByCreatorResponse> createRepeated() => $pb.PbList<QueryListCookbooksByCreatorResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryListCookbooksByCreatorResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryListCookbooksByCreatorResponse>(create);
  static QueryListCookbooksByCreatorResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$5.Cookbook> get cookbooks => $_getList(0);

  @$pb.TagNumber(3)
  $12.PageResponse get pagination => $_getN(1);
  @$pb.TagNumber(3)
  set pagination($12.PageResponse v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPagination() => $_has(1);
  @$pb.TagNumber(3)
  void clearPagination() => clearField(3);
  @$pb.TagNumber(3)
  $12.PageResponse ensurePagination() => $_ensure(1);
}

class QueryGetCookbookRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetCookbookRequest',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..hasRequiredFields = false;

  QueryGetCookbookRequest._() : super();
  factory QueryGetCookbookRequest() => create();
  factory QueryGetCookbookRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetCookbookRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryGetCookbookRequest clone() => QueryGetCookbookRequest()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryGetCookbookRequest copyWith(void Function(QueryGetCookbookRequest) updates) =>
      super.copyWith((message) => updates(message as QueryGetCookbookRequest)) as QueryGetCookbookRequest; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetCookbookRequest create() => QueryGetCookbookRequest._();
  QueryGetCookbookRequest createEmptyInstance() => create();
  static $pb.PbList<QueryGetCookbookRequest> createRepeated() => $pb.PbList<QueryGetCookbookRequest>();
  @$core.pragma('dart2js:noInline')
  static QueryGetCookbookRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetCookbookRequest>(create);
  static QueryGetCookbookRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iD => $_getSZ(0);
  @$pb.TagNumber(1)
  set iD($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasID() => $_has(0);
  @$pb.TagNumber(1)
  void clearID() => clearField(1);
}

class QueryGetCookbookResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'QueryGetCookbookResponse',
      package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'Pylonstech.pylons.pylons'), createEmptyInstance: create)
    ..aOM<$5.Cookbook>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Cookbook', protoName: 'Cookbook', subBuilder: $5.Cookbook.create)
    ..hasRequiredFields = false;

  QueryGetCookbookResponse._() : super();
  factory QueryGetCookbookResponse() => create();
  factory QueryGetCookbookResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QueryGetCookbookResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  QueryGetCookbookResponse clone() => QueryGetCookbookResponse()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  QueryGetCookbookResponse copyWith(void Function(QueryGetCookbookResponse) updates) =>
      super.copyWith((message) => updates(message as QueryGetCookbookResponse)) as QueryGetCookbookResponse; // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static QueryGetCookbookResponse create() => QueryGetCookbookResponse._();
  QueryGetCookbookResponse createEmptyInstance() => create();
  static $pb.PbList<QueryGetCookbookResponse> createRepeated() => $pb.PbList<QueryGetCookbookResponse>();
  @$core.pragma('dart2js:noInline')
  static QueryGetCookbookResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QueryGetCookbookResponse>(create);
  static QueryGetCookbookResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $5.Cookbook get cookbook => $_getN(0);
  @$pb.TagNumber(1)
  set cookbook($5.Cookbook v) {
    setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCookbook() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbook() => clearField(1);
  @$pb.TagNumber(1)
  $5.Cookbook ensureCookbook() => $_ensure(0);
}
