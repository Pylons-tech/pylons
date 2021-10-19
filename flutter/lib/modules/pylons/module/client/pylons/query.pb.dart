///
//  Generated code. Do not modify.
//  source: pylons/query.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'package:pylons_wallet/modules/pylons/module/client/cosmos/base/v1beta1/coin.pb.dart' as $2;
import 'package:pylons_wallet/modules/pylons/module/client/pylons/pylons.pb.dart' as $3;

class AddrFromPubKeyRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddrFromPubKeyRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'hexPubKey')
    ..hasRequiredFields = false
  ;

  AddrFromPubKeyRequest._() : super();
  factory AddrFromPubKeyRequest() => create();
  factory AddrFromPubKeyRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddrFromPubKeyRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddrFromPubKeyRequest clone() => AddrFromPubKeyRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddrFromPubKeyRequest copyWith(void Function(AddrFromPubKeyRequest) updates) => super.copyWith((message) => updates(message as AddrFromPubKeyRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddrFromPubKeyRequest create() => AddrFromPubKeyRequest._();
  AddrFromPubKeyRequest createEmptyInstance() => create();
  static $pb.PbList<AddrFromPubKeyRequest> createRepeated() => $pb.PbList<AddrFromPubKeyRequest>();
  @$core.pragma('dart2js:noInline')
  static AddrFromPubKeyRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddrFromPubKeyRequest>(create);
  static AddrFromPubKeyRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get hexPubKey => $_getSZ(0);
  @$pb.TagNumber(1)
  set hexPubKey($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasHexPubKey() => $_has(0);
  @$pb.TagNumber(1)
  void clearHexPubKey() => clearField(1);
}

class AddrFromPubKeyResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'AddrFromPubKeyResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Bech32Addr', protoName: 'Bech32Addr')
    ..hasRequiredFields = false
  ;

  AddrFromPubKeyResponse._() : super();
  factory AddrFromPubKeyResponse() => create();
  factory AddrFromPubKeyResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddrFromPubKeyResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddrFromPubKeyResponse clone() => AddrFromPubKeyResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddrFromPubKeyResponse copyWith(void Function(AddrFromPubKeyResponse) updates) => super.copyWith((message) => updates(message as AddrFromPubKeyResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static AddrFromPubKeyResponse create() => AddrFromPubKeyResponse._();
  AddrFromPubKeyResponse createEmptyInstance() => create();
  static $pb.PbList<AddrFromPubKeyResponse> createRepeated() => $pb.PbList<AddrFromPubKeyResponse>();
  @$core.pragma('dart2js:noInline')
  static AddrFromPubKeyResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddrFromPubKeyResponse>(create);
  static AddrFromPubKeyResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get bech32Addr => $_getSZ(0);
  @$pb.TagNumber(1)
  set bech32Addr($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBech32Addr() => $_has(0);
  @$pb.TagNumber(1)
  void clearBech32Addr() => clearField(1);
}

class CheckGoogleIAPOrderRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CheckGoogleIAPOrderRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'purchaseToken', protoName: 'purchaseToken')
    ..hasRequiredFields = false
  ;

  CheckGoogleIAPOrderRequest._() : super();
  factory CheckGoogleIAPOrderRequest() => create();
  factory CheckGoogleIAPOrderRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CheckGoogleIAPOrderRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CheckGoogleIAPOrderRequest clone() => CheckGoogleIAPOrderRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CheckGoogleIAPOrderRequest copyWith(void Function(CheckGoogleIAPOrderRequest) updates) => super.copyWith((message) => updates(message as CheckGoogleIAPOrderRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CheckGoogleIAPOrderRequest create() => CheckGoogleIAPOrderRequest._();
  CheckGoogleIAPOrderRequest createEmptyInstance() => create();
  static $pb.PbList<CheckGoogleIAPOrderRequest> createRepeated() => $pb.PbList<CheckGoogleIAPOrderRequest>();
  @$core.pragma('dart2js:noInline')
  static CheckGoogleIAPOrderRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CheckGoogleIAPOrderRequest>(create);
  static CheckGoogleIAPOrderRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get purchaseToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set purchaseToken($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPurchaseToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearPurchaseToken() => clearField(1);
}

class CheckGoogleIAPOrderResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'CheckGoogleIAPOrderResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'purchaseToken', protoName: 'purchaseToken')
    ..aOB(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'exist')
    ..hasRequiredFields = false
  ;

  CheckGoogleIAPOrderResponse._() : super();
  factory CheckGoogleIAPOrderResponse() => create();
  factory CheckGoogleIAPOrderResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory CheckGoogleIAPOrderResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  CheckGoogleIAPOrderResponse clone() => CheckGoogleIAPOrderResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  CheckGoogleIAPOrderResponse copyWith(void Function(CheckGoogleIAPOrderResponse) updates) => super.copyWith((message) => updates(message as CheckGoogleIAPOrderResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CheckGoogleIAPOrderResponse create() => CheckGoogleIAPOrderResponse._();
  CheckGoogleIAPOrderResponse createEmptyInstance() => create();
  static $pb.PbList<CheckGoogleIAPOrderResponse> createRepeated() => $pb.PbList<CheckGoogleIAPOrderResponse>();
  @$core.pragma('dart2js:noInline')
  static CheckGoogleIAPOrderResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CheckGoogleIAPOrderResponse>(create);
  static CheckGoogleIAPOrderResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get purchaseToken => $_getSZ(0);
  @$pb.TagNumber(1)
  set purchaseToken($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPurchaseToken() => $_has(0);
  @$pb.TagNumber(1)
  void clearPurchaseToken() => clearField(1);

  @$pb.TagNumber(2)
  $core.bool get exist => $_getBF(1);
  @$pb.TagNumber(2)
  set exist($core.bool v) { $_setBool(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasExist() => $_has(1);
  @$pb.TagNumber(2)
  void clearExist() => clearField(2);
}

class GetCookbookRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetCookbookRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookID', protoName: 'cookbookID')
    ..hasRequiredFields = false
  ;

  GetCookbookRequest._() : super();
  factory GetCookbookRequest() => create();
  factory GetCookbookRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCookbookRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCookbookRequest clone() => GetCookbookRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCookbookRequest copyWith(void Function(GetCookbookRequest) updates) => super.copyWith((message) => updates(message as GetCookbookRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetCookbookRequest create() => GetCookbookRequest._();
  GetCookbookRequest createEmptyInstance() => create();
  static $pb.PbList<GetCookbookRequest> createRepeated() => $pb.PbList<GetCookbookRequest>();
  @$core.pragma('dart2js:noInline')
  static GetCookbookRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCookbookRequest>(create);
  static GetCookbookRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookID => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCookbookID() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookID() => clearField(1);
}

class GetCookbookResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetCookbookResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'NodeVersion', protoName: 'NodeVersion')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Name', protoName: 'Name')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Description', protoName: 'Description')
    ..aOS(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Version', protoName: 'Version')
    ..aOS(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Developer', protoName: 'Developer')
    ..aInt64(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Level', protoName: 'Level')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'SupportEmail', protoName: 'SupportEmail')
    ..aInt64(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CostPerBlock', protoName: 'CostPerBlock')
    ..aOS(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..hasRequiredFields = false
  ;

  GetCookbookResponse._() : super();
  factory GetCookbookResponse() => create();
  factory GetCookbookResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetCookbookResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetCookbookResponse clone() => GetCookbookResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetCookbookResponse copyWith(void Function(GetCookbookResponse) updates) => super.copyWith((message) => updates(message as GetCookbookResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetCookbookResponse create() => GetCookbookResponse._();
  GetCookbookResponse createEmptyInstance() => create();
  static $pb.PbList<GetCookbookResponse> createRepeated() => $pb.PbList<GetCookbookResponse>();
  @$core.pragma('dart2js:noInline')
  static GetCookbookResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetCookbookResponse>(create);
  static GetCookbookResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeVersion($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(4)
  set description($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(4)
  void clearDescription() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get version => $_getSZ(4);
  @$pb.TagNumber(5)
  set version($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasVersion() => $_has(4);
  @$pb.TagNumber(5)
  void clearVersion() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get developer => $_getSZ(5);
  @$pb.TagNumber(6)
  set developer($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasDeveloper() => $_has(5);
  @$pb.TagNumber(6)
  void clearDeveloper() => clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get level => $_getI64(6);
  @$pb.TagNumber(7)
  set level($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasLevel() => $_has(6);
  @$pb.TagNumber(7)
  void clearLevel() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get supportEmail => $_getSZ(7);
  @$pb.TagNumber(8)
  set supportEmail($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSupportEmail() => $_has(7);
  @$pb.TagNumber(8)
  void clearSupportEmail() => clearField(8);

  @$pb.TagNumber(9)
  $fixnum.Int64 get costPerBlock => $_getI64(8);
  @$pb.TagNumber(9)
  set costPerBlock($fixnum.Int64 v) { $_setInt64(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCostPerBlock() => $_has(8);
  @$pb.TagNumber(9)
  void clearCostPerBlock() => clearField(9);

  @$pb.TagNumber(10)
  $core.String get sender => $_getSZ(9);
  @$pb.TagNumber(10)
  set sender($core.String v) { $_setString(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasSender() => $_has(9);
  @$pb.TagNumber(10)
  void clearSender() => clearField(10);
}

class GetExecutionRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetExecutionRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'executionID', protoName: 'executionID')
    ..hasRequiredFields = false
  ;

  GetExecutionRequest._() : super();
  factory GetExecutionRequest() => create();
  factory GetExecutionRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetExecutionRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetExecutionRequest clone() => GetExecutionRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetExecutionRequest copyWith(void Function(GetExecutionRequest) updates) => super.copyWith((message) => updates(message as GetExecutionRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetExecutionRequest create() => GetExecutionRequest._();
  GetExecutionRequest createEmptyInstance() => create();
  static $pb.PbList<GetExecutionRequest> createRepeated() => $pb.PbList<GetExecutionRequest>();
  @$core.pragma('dart2js:noInline')
  static GetExecutionRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetExecutionRequest>(create);
  static GetExecutionRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get executionID => $_getSZ(0);
  @$pb.TagNumber(1)
  set executionID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasExecutionID() => $_has(0);
  @$pb.TagNumber(1)
  void clearExecutionID() => clearField(1);
}

class GetExecutionResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetExecutionResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'NodeVersion', protoName: 'NodeVersion')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'RecipeID', protoName: 'RecipeID')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..pc<$2.Coin>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CoinsInput', $pb.PbFieldType.PM, protoName: 'CoinsInput', subBuilder: $2.Coin.create)
    ..pc<$3.Item>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemInputs', $pb.PbFieldType.PM, protoName: 'ItemInputs', subBuilder: $3.Item.create)
    ..aInt64(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'BlockHeight', protoName: 'BlockHeight')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..aOB(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Completed', protoName: 'Completed')
    ..hasRequiredFields = false
  ;

  GetExecutionResponse._() : super();
  factory GetExecutionResponse() => create();
  factory GetExecutionResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetExecutionResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetExecutionResponse clone() => GetExecutionResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetExecutionResponse copyWith(void Function(GetExecutionResponse) updates) => super.copyWith((message) => updates(message as GetExecutionResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetExecutionResponse create() => GetExecutionResponse._();
  GetExecutionResponse createEmptyInstance() => create();
  static $pb.PbList<GetExecutionResponse> createRepeated() => $pb.PbList<GetExecutionResponse>();
  @$core.pragma('dart2js:noInline')
  static GetExecutionResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetExecutionResponse>(create);
  static GetExecutionResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeVersion($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get recipeID => $_getSZ(2);
  @$pb.TagNumber(3)
  set recipeID($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasRecipeID() => $_has(2);
  @$pb.TagNumber(3)
  void clearRecipeID() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get cookbookID => $_getSZ(3);
  @$pb.TagNumber(4)
  set cookbookID($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCookbookID() => $_has(3);
  @$pb.TagNumber(4)
  void clearCookbookID() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$2.Coin> get coinsInput => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<$3.Item> get itemInputs => $_getList(5);

  @$pb.TagNumber(7)
  $fixnum.Int64 get blockHeight => $_getI64(6);
  @$pb.TagNumber(7)
  set blockHeight($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasBlockHeight() => $_has(6);
  @$pb.TagNumber(7)
  void clearBlockHeight() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get sender => $_getSZ(7);
  @$pb.TagNumber(8)
  set sender($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSender() => $_has(7);
  @$pb.TagNumber(8)
  void clearSender() => clearField(8);

  @$pb.TagNumber(9)
  $core.bool get completed => $_getBF(8);
  @$pb.TagNumber(9)
  set completed($core.bool v) { $_setBool(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasCompleted() => $_has(8);
  @$pb.TagNumber(9)
  void clearCompleted() => clearField(9);
}

class GetItemRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetItemRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'itemID', protoName: 'itemID')
    ..hasRequiredFields = false
  ;

  GetItemRequest._() : super();
  factory GetItemRequest() => create();
  factory GetItemRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetItemRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetItemRequest clone() => GetItemRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetItemRequest copyWith(void Function(GetItemRequest) updates) => super.copyWith((message) => updates(message as GetItemRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetItemRequest create() => GetItemRequest._();
  GetItemRequest createEmptyInstance() => create();
  static $pb.PbList<GetItemRequest> createRepeated() => $pb.PbList<GetItemRequest>();
  @$core.pragma('dart2js:noInline')
  static GetItemRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetItemRequest>(create);
  static GetItemRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get itemID => $_getSZ(0);
  @$pb.TagNumber(1)
  set itemID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasItemID() => $_has(0);
  @$pb.TagNumber(1)
  void clearItemID() => clearField(1);
}

class GetItemResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetItemResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOM<$3.Item>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'item', subBuilder: $3.Item.create)
    ..hasRequiredFields = false
  ;

  GetItemResponse._() : super();
  factory GetItemResponse() => create();
  factory GetItemResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetItemResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetItemResponse clone() => GetItemResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetItemResponse copyWith(void Function(GetItemResponse) updates) => super.copyWith((message) => updates(message as GetItemResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetItemResponse create() => GetItemResponse._();
  GetItemResponse createEmptyInstance() => create();
  static $pb.PbList<GetItemResponse> createRepeated() => $pb.PbList<GetItemResponse>();
  @$core.pragma('dart2js:noInline')
  static GetItemResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetItemResponse>(create);
  static GetItemResponse _defaultInstance;

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

class GetRecipeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetRecipeRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recipeID', protoName: 'recipeID')
    ..hasRequiredFields = false
  ;

  GetRecipeRequest._() : super();
  factory GetRecipeRequest() => create();
  factory GetRecipeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetRecipeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetRecipeRequest clone() => GetRecipeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetRecipeRequest copyWith(void Function(GetRecipeRequest) updates) => super.copyWith((message) => updates(message as GetRecipeRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetRecipeRequest create() => GetRecipeRequest._();
  GetRecipeRequest createEmptyInstance() => create();
  static $pb.PbList<GetRecipeRequest> createRepeated() => $pb.PbList<GetRecipeRequest>();
  @$core.pragma('dart2js:noInline')
  static GetRecipeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetRecipeRequest>(create);
  static GetRecipeRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get recipeID => $_getSZ(0);
  @$pb.TagNumber(1)
  set recipeID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRecipeID() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecipeID() => clearField(1);
}

class GetRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetRecipeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'NodeVersion', protoName: 'NodeVersion')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..aOS(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CookbookID', protoName: 'CookbookID')
    ..aOS(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Name', protoName: 'Name')
    ..pc<$3.CoinInput>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CoinInputs', $pb.PbFieldType.PM, protoName: 'CoinInputs', subBuilder: $3.CoinInput.create)
    ..pc<$3.ItemInput>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemInputs', $pb.PbFieldType.PM, protoName: 'ItemInputs', subBuilder: $3.ItemInput.create)
    ..aOM<$3.EntriesList>(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Entries', protoName: 'Entries', subBuilder: $3.EntriesList.create)
    ..pc<$3.WeightedOutputs>(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Outputs', $pb.PbFieldType.PM, protoName: 'Outputs', subBuilder: $3.WeightedOutputs.create)
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Description', protoName: 'Description')
    ..aInt64(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'BlockInterval', protoName: 'BlockInterval')
    ..aOS(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..aOB(12, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Disabled', protoName: 'Disabled')
    ..hasRequiredFields = false
  ;

  GetRecipeResponse._() : super();
  factory GetRecipeResponse() => create();
  factory GetRecipeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetRecipeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetRecipeResponse clone() => GetRecipeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetRecipeResponse copyWith(void Function(GetRecipeResponse) updates) => super.copyWith((message) => updates(message as GetRecipeResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetRecipeResponse create() => GetRecipeResponse._();
  GetRecipeResponse createEmptyInstance() => create();
  static $pb.PbList<GetRecipeResponse> createRepeated() => $pb.PbList<GetRecipeResponse>();
  @$core.pragma('dart2js:noInline')
  static GetRecipeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetRecipeResponse>(create);
  static GetRecipeResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeVersion($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get cookbookID => $_getSZ(2);
  @$pb.TagNumber(3)
  set cookbookID($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasCookbookID() => $_has(2);
  @$pb.TagNumber(3)
  void clearCookbookID() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => clearField(4);

  @$pb.TagNumber(5)
  $core.List<$3.CoinInput> get coinInputs => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<$3.ItemInput> get itemInputs => $_getList(5);

  @$pb.TagNumber(7)
  $3.EntriesList get entries => $_getN(6);
  @$pb.TagNumber(7)
  set entries($3.EntriesList v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasEntries() => $_has(6);
  @$pb.TagNumber(7)
  void clearEntries() => clearField(7);
  @$pb.TagNumber(7)
  $3.EntriesList ensureEntries() => $_ensure(6);

  @$pb.TagNumber(8)
  $core.List<$3.WeightedOutputs> get outputs => $_getList(7);

  @$pb.TagNumber(9)
  $core.String get description => $_getSZ(8);
  @$pb.TagNumber(9)
  set description($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasDescription() => $_has(8);
  @$pb.TagNumber(9)
  void clearDescription() => clearField(9);

  @$pb.TagNumber(10)
  $fixnum.Int64 get blockInterval => $_getI64(9);
  @$pb.TagNumber(10)
  set blockInterval($fixnum.Int64 v) { $_setInt64(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasBlockInterval() => $_has(9);
  @$pb.TagNumber(10)
  void clearBlockInterval() => clearField(10);

  @$pb.TagNumber(11)
  $core.String get sender => $_getSZ(10);
  @$pb.TagNumber(11)
  set sender($core.String v) { $_setString(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasSender() => $_has(10);
  @$pb.TagNumber(11)
  void clearSender() => clearField(11);

  @$pb.TagNumber(12)
  $core.bool get disabled => $_getBF(11);
  @$pb.TagNumber(12)
  set disabled($core.bool v) { $_setBool(11, v); }
  @$pb.TagNumber(12)
  $core.bool hasDisabled() => $_has(11);
  @$pb.TagNumber(12)
  void clearDisabled() => clearField(12);
}

class GetTradeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetTradeRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'tradeID', protoName: 'tradeID')
    ..hasRequiredFields = false
  ;

  GetTradeRequest._() : super();
  factory GetTradeRequest() => create();
  factory GetTradeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetTradeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetTradeRequest clone() => GetTradeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetTradeRequest copyWith(void Function(GetTradeRequest) updates) => super.copyWith((message) => updates(message as GetTradeRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetTradeRequest create() => GetTradeRequest._();
  GetTradeRequest createEmptyInstance() => create();
  static $pb.PbList<GetTradeRequest> createRepeated() => $pb.PbList<GetTradeRequest>();
  @$core.pragma('dart2js:noInline')
  static GetTradeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTradeRequest>(create);
  static GetTradeRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get tradeID => $_getSZ(0);
  @$pb.TagNumber(1)
  set tradeID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTradeID() => $_has(0);
  @$pb.TagNumber(1)
  void clearTradeID() => clearField(1);
}

class GetTradeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetTradeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'NodeVersion', protoName: 'NodeVersion')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ID', protoName: 'ID')
    ..pc<$3.CoinInput>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CoinInputs', $pb.PbFieldType.PM, protoName: 'CoinInputs', subBuilder: $3.CoinInput.create)
    ..pc<$3.TradeItemInput>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemInputs', $pb.PbFieldType.PM, protoName: 'ItemInputs', subBuilder: $3.TradeItemInput.create)
    ..pc<$2.Coin>(5, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'CoinOutputs', $pb.PbFieldType.PM, protoName: 'CoinOutputs', subBuilder: $2.Coin.create)
    ..pc<$3.Item>(6, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ItemOutputs', $pb.PbFieldType.PM, protoName: 'ItemOutputs', subBuilder: $3.Item.create)
    ..aOS(7, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'ExtraInfo', protoName: 'ExtraInfo')
    ..aOS(8, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..aOS(9, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'FulFiller', protoName: 'FulFiller')
    ..aOB(10, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Disabled', protoName: 'Disabled')
    ..aOB(11, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Completed', protoName: 'Completed')
    ..hasRequiredFields = false
  ;

  GetTradeResponse._() : super();
  factory GetTradeResponse() => create();
  factory GetTradeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetTradeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetTradeResponse clone() => GetTradeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetTradeResponse copyWith(void Function(GetTradeResponse) updates) => super.copyWith((message) => updates(message as GetTradeResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetTradeResponse create() => GetTradeResponse._();
  GetTradeResponse createEmptyInstance() => create();
  static $pb.PbList<GetTradeResponse> createRepeated() => $pb.PbList<GetTradeResponse>();
  @$core.pragma('dart2js:noInline')
  static GetTradeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetTradeResponse>(create);
  static GetTradeResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeVersion($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get iD => $_getSZ(1);
  @$pb.TagNumber(2)
  set iD($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasID() => $_has(1);
  @$pb.TagNumber(2)
  void clearID() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$3.CoinInput> get coinInputs => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$3.TradeItemInput> get itemInputs => $_getList(3);

  @$pb.TagNumber(5)
  $core.List<$2.Coin> get coinOutputs => $_getList(4);

  @$pb.TagNumber(6)
  $core.List<$3.Item> get itemOutputs => $_getList(5);

  @$pb.TagNumber(7)
  $core.String get extraInfo => $_getSZ(6);
  @$pb.TagNumber(7)
  set extraInfo($core.String v) { $_setString(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasExtraInfo() => $_has(6);
  @$pb.TagNumber(7)
  void clearExtraInfo() => clearField(7);

  @$pb.TagNumber(8)
  $core.String get sender => $_getSZ(7);
  @$pb.TagNumber(8)
  set sender($core.String v) { $_setString(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasSender() => $_has(7);
  @$pb.TagNumber(8)
  void clearSender() => clearField(8);

  @$pb.TagNumber(9)
  $core.String get fulFiller => $_getSZ(8);
  @$pb.TagNumber(9)
  set fulFiller($core.String v) { $_setString(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasFulFiller() => $_has(8);
  @$pb.TagNumber(9)
  void clearFulFiller() => clearField(9);

  @$pb.TagNumber(10)
  $core.bool get disabled => $_getBF(9);
  @$pb.TagNumber(10)
  set disabled($core.bool v) { $_setBool(9, v); }
  @$pb.TagNumber(10)
  $core.bool hasDisabled() => $_has(9);
  @$pb.TagNumber(10)
  void clearDisabled() => clearField(10);

  @$pb.TagNumber(11)
  $core.bool get completed => $_getBF(10);
  @$pb.TagNumber(11)
  set completed($core.bool v) { $_setBool(10, v); }
  @$pb.TagNumber(11)
  $core.bool hasCompleted() => $_has(10);
  @$pb.TagNumber(11)
  void clearCompleted() => clearField(11);
}

class ItemsByCookbookRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ItemsByCookbookRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookID', protoName: 'cookbookID')
    ..hasRequiredFields = false
  ;

  ItemsByCookbookRequest._() : super();
  factory ItemsByCookbookRequest() => create();
  factory ItemsByCookbookRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ItemsByCookbookRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ItemsByCookbookRequest clone() => ItemsByCookbookRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ItemsByCookbookRequest copyWith(void Function(ItemsByCookbookRequest) updates) => super.copyWith((message) => updates(message as ItemsByCookbookRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ItemsByCookbookRequest create() => ItemsByCookbookRequest._();
  ItemsByCookbookRequest createEmptyInstance() => create();
  static $pb.PbList<ItemsByCookbookRequest> createRepeated() => $pb.PbList<ItemsByCookbookRequest>();
  @$core.pragma('dart2js:noInline')
  static ItemsByCookbookRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ItemsByCookbookRequest>(create);
  static ItemsByCookbookRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookID => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCookbookID() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookID() => clearField(1);
}

class ItemsByCookbookResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ItemsByCookbookResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..pc<$3.Item>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Items', $pb.PbFieldType.PM, protoName: 'Items', subBuilder: $3.Item.create)
    ..hasRequiredFields = false
  ;

  ItemsByCookbookResponse._() : super();
  factory ItemsByCookbookResponse() => create();
  factory ItemsByCookbookResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ItemsByCookbookResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ItemsByCookbookResponse clone() => ItemsByCookbookResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ItemsByCookbookResponse copyWith(void Function(ItemsByCookbookResponse) updates) => super.copyWith((message) => updates(message as ItemsByCookbookResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ItemsByCookbookResponse create() => ItemsByCookbookResponse._();
  ItemsByCookbookResponse createEmptyInstance() => create();
  static $pb.PbList<ItemsByCookbookResponse> createRepeated() => $pb.PbList<ItemsByCookbookResponse>();
  @$core.pragma('dart2js:noInline')
  static ItemsByCookbookResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ItemsByCookbookResponse>(create);
  static ItemsByCookbookResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$3.Item> get items => $_getList(0);
}

class ItemsBySenderRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ItemsBySenderRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sender')
    ..hasRequiredFields = false
  ;

  ItemsBySenderRequest._() : super();
  factory ItemsBySenderRequest() => create();
  factory ItemsBySenderRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ItemsBySenderRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ItemsBySenderRequest clone() => ItemsBySenderRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ItemsBySenderRequest copyWith(void Function(ItemsBySenderRequest) updates) => super.copyWith((message) => updates(message as ItemsBySenderRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ItemsBySenderRequest create() => ItemsBySenderRequest._();
  ItemsBySenderRequest createEmptyInstance() => create();
  static $pb.PbList<ItemsBySenderRequest> createRepeated() => $pb.PbList<ItemsBySenderRequest>();
  @$core.pragma('dart2js:noInline')
  static ItemsBySenderRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ItemsBySenderRequest>(create);
  static ItemsBySenderRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sender => $_getSZ(0);
  @$pb.TagNumber(1)
  set sender($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSender() => $_has(0);
  @$pb.TagNumber(1)
  void clearSender() => clearField(1);
}

class ItemsBySenderResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ItemsBySenderResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..pc<$3.Item>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Items', $pb.PbFieldType.PM, protoName: 'Items', subBuilder: $3.Item.create)
    ..hasRequiredFields = false
  ;

  ItemsBySenderResponse._() : super();
  factory ItemsBySenderResponse() => create();
  factory ItemsBySenderResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ItemsBySenderResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ItemsBySenderResponse clone() => ItemsBySenderResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ItemsBySenderResponse copyWith(void Function(ItemsBySenderResponse) updates) => super.copyWith((message) => updates(message as ItemsBySenderResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ItemsBySenderResponse create() => ItemsBySenderResponse._();
  ItemsBySenderResponse createEmptyInstance() => create();
  static $pb.PbList<ItemsBySenderResponse> createRepeated() => $pb.PbList<ItemsBySenderResponse>();
  @$core.pragma('dart2js:noInline')
  static ItemsBySenderResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ItemsBySenderResponse>(create);
  static ItemsBySenderResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$3.Item> get items => $_getList(0);
}

class ListCookbookRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListCookbookRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..hasRequiredFields = false
  ;

  ListCookbookRequest._() : super();
  factory ListCookbookRequest() => create();
  factory ListCookbookRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListCookbookRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListCookbookRequest clone() => ListCookbookRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListCookbookRequest copyWith(void Function(ListCookbookRequest) updates) => super.copyWith((message) => updates(message as ListCookbookRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListCookbookRequest create() => ListCookbookRequest._();
  ListCookbookRequest createEmptyInstance() => create();
  static $pb.PbList<ListCookbookRequest> createRepeated() => $pb.PbList<ListCookbookRequest>();
  @$core.pragma('dart2js:noInline')
  static ListCookbookRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListCookbookRequest>(create);
  static ListCookbookRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);
}

class ListCookbookResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListCookbookResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..pc<$3.Cookbook>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Cookbooks', $pb.PbFieldType.PM, protoName: 'Cookbooks', subBuilder: $3.Cookbook.create)
    ..hasRequiredFields = false
  ;

  ListCookbookResponse._() : super();
  factory ListCookbookResponse() => create();
  factory ListCookbookResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListCookbookResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListCookbookResponse clone() => ListCookbookResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListCookbookResponse copyWith(void Function(ListCookbookResponse) updates) => super.copyWith((message) => updates(message as ListCookbookResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListCookbookResponse create() => ListCookbookResponse._();
  ListCookbookResponse createEmptyInstance() => create();
  static $pb.PbList<ListCookbookResponse> createRepeated() => $pb.PbList<ListCookbookResponse>();
  @$core.pragma('dart2js:noInline')
  static ListCookbookResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListCookbookResponse>(create);
  static ListCookbookResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$3.Cookbook> get cookbooks => $_getList(0);
}

class ListExecutionsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListExecutionsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sender')
    ..hasRequiredFields = false
  ;

  ListExecutionsRequest._() : super();
  factory ListExecutionsRequest() => create();
  factory ListExecutionsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListExecutionsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListExecutionsRequest clone() => ListExecutionsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListExecutionsRequest copyWith(void Function(ListExecutionsRequest) updates) => super.copyWith((message) => updates(message as ListExecutionsRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListExecutionsRequest create() => ListExecutionsRequest._();
  ListExecutionsRequest createEmptyInstance() => create();
  static $pb.PbList<ListExecutionsRequest> createRepeated() => $pb.PbList<ListExecutionsRequest>();
  @$core.pragma('dart2js:noInline')
  static ListExecutionsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListExecutionsRequest>(create);
  static ListExecutionsRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sender => $_getSZ(0);
  @$pb.TagNumber(1)
  set sender($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSender() => $_has(0);
  @$pb.TagNumber(1)
  void clearSender() => clearField(1);
}

class ListExecutionsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListExecutionsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..pc<$3.Execution>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Executions', $pb.PbFieldType.PM, protoName: 'Executions', subBuilder: $3.Execution.create)
    ..hasRequiredFields = false
  ;

  ListExecutionsResponse._() : super();
  factory ListExecutionsResponse() => create();
  factory ListExecutionsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListExecutionsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListExecutionsResponse clone() => ListExecutionsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListExecutionsResponse copyWith(void Function(ListExecutionsResponse) updates) => super.copyWith((message) => updates(message as ListExecutionsResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListExecutionsResponse create() => ListExecutionsResponse._();
  ListExecutionsResponse createEmptyInstance() => create();
  static $pb.PbList<ListExecutionsResponse> createRepeated() => $pb.PbList<ListExecutionsResponse>();
  @$core.pragma('dart2js:noInline')
  static ListExecutionsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListExecutionsResponse>(create);
  static ListExecutionsResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$3.Execution> get executions => $_getList(0);
}

class GetLockedCoinsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetLockedCoinsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..hasRequiredFields = false
  ;

  GetLockedCoinsRequest._() : super();
  factory GetLockedCoinsRequest() => create();
  factory GetLockedCoinsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetLockedCoinsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetLockedCoinsRequest clone() => GetLockedCoinsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetLockedCoinsRequest copyWith(void Function(GetLockedCoinsRequest) updates) => super.copyWith((message) => updates(message as GetLockedCoinsRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetLockedCoinsRequest create() => GetLockedCoinsRequest._();
  GetLockedCoinsRequest createEmptyInstance() => create();
  static $pb.PbList<GetLockedCoinsRequest> createRepeated() => $pb.PbList<GetLockedCoinsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetLockedCoinsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetLockedCoinsRequest>(create);
  static GetLockedCoinsRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);
}

class GetLockedCoinsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetLockedCoinsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'NodeVersion', protoName: 'NodeVersion')
    ..aOS(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Sender', protoName: 'Sender')
    ..pc<$2.Coin>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Amount', $pb.PbFieldType.PM, protoName: 'Amount', subBuilder: $2.Coin.create)
    ..hasRequiredFields = false
  ;

  GetLockedCoinsResponse._() : super();
  factory GetLockedCoinsResponse() => create();
  factory GetLockedCoinsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetLockedCoinsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetLockedCoinsResponse clone() => GetLockedCoinsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetLockedCoinsResponse copyWith(void Function(GetLockedCoinsResponse) updates) => super.copyWith((message) => updates(message as GetLockedCoinsResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetLockedCoinsResponse create() => GetLockedCoinsResponse._();
  GetLockedCoinsResponse createEmptyInstance() => create();
  static $pb.PbList<GetLockedCoinsResponse> createRepeated() => $pb.PbList<GetLockedCoinsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetLockedCoinsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetLockedCoinsResponse>(create);
  static GetLockedCoinsResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get nodeVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set nodeVersion($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasNodeVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearNodeVersion() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get sender => $_getSZ(1);
  @$pb.TagNumber(2)
  set sender($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasSender() => $_has(1);
  @$pb.TagNumber(2)
  void clearSender() => clearField(2);

  @$pb.TagNumber(3)
  $core.List<$2.Coin> get amount => $_getList(2);
}

class GetLockedCoinDetailsRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetLockedCoinDetailsRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..hasRequiredFields = false
  ;

  GetLockedCoinDetailsRequest._() : super();
  factory GetLockedCoinDetailsRequest() => create();
  factory GetLockedCoinDetailsRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetLockedCoinDetailsRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetLockedCoinDetailsRequest clone() => GetLockedCoinDetailsRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetLockedCoinDetailsRequest copyWith(void Function(GetLockedCoinDetailsRequest) updates) => super.copyWith((message) => updates(message as GetLockedCoinDetailsRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetLockedCoinDetailsRequest create() => GetLockedCoinDetailsRequest._();
  GetLockedCoinDetailsRequest createEmptyInstance() => create();
  static $pb.PbList<GetLockedCoinDetailsRequest> createRepeated() => $pb.PbList<GetLockedCoinDetailsRequest>();
  @$core.pragma('dart2js:noInline')
  static GetLockedCoinDetailsRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetLockedCoinDetailsRequest>(create);
  static GetLockedCoinDetailsRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);
}

class GetLockedCoinDetailsResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'GetLockedCoinDetailsResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'sender')
    ..pc<$2.Coin>(2, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'Amount', $pb.PbFieldType.PM, protoName: 'Amount', subBuilder: $2.Coin.create)
    ..pc<$3.LockedCoinDescribe>(3, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'LockCoinTrades', $pb.PbFieldType.PM, protoName: 'LockCoinTrades', subBuilder: $3.LockedCoinDescribe.create)
    ..pc<$3.LockedCoinDescribe>(4, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'LockCoinExecs', $pb.PbFieldType.PM, protoName: 'LockCoinExecs', subBuilder: $3.LockedCoinDescribe.create)
    ..hasRequiredFields = false
  ;

  GetLockedCoinDetailsResponse._() : super();
  factory GetLockedCoinDetailsResponse() => create();
  factory GetLockedCoinDetailsResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory GetLockedCoinDetailsResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  GetLockedCoinDetailsResponse clone() => GetLockedCoinDetailsResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  GetLockedCoinDetailsResponse copyWith(void Function(GetLockedCoinDetailsResponse) updates) => super.copyWith((message) => updates(message as GetLockedCoinDetailsResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static GetLockedCoinDetailsResponse create() => GetLockedCoinDetailsResponse._();
  GetLockedCoinDetailsResponse createEmptyInstance() => create();
  static $pb.PbList<GetLockedCoinDetailsResponse> createRepeated() => $pb.PbList<GetLockedCoinDetailsResponse>();
  @$core.pragma('dart2js:noInline')
  static GetLockedCoinDetailsResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<GetLockedCoinDetailsResponse>(create);
  static GetLockedCoinDetailsResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get sender => $_getSZ(0);
  @$pb.TagNumber(1)
  set sender($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasSender() => $_has(0);
  @$pb.TagNumber(1)
  void clearSender() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<$2.Coin> get amount => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<$3.LockedCoinDescribe> get lockCoinTrades => $_getList(2);

  @$pb.TagNumber(4)
  $core.List<$3.LockedCoinDescribe> get lockCoinExecs => $_getList(3);
}

class ListRecipeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListRecipeRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..hasRequiredFields = false
  ;

  ListRecipeRequest._() : super();
  factory ListRecipeRequest() => create();
  factory ListRecipeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListRecipeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListRecipeRequest clone() => ListRecipeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListRecipeRequest copyWith(void Function(ListRecipeRequest) updates) => super.copyWith((message) => updates(message as ListRecipeRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListRecipeRequest create() => ListRecipeRequest._();
  ListRecipeRequest createEmptyInstance() => create();
  static $pb.PbList<ListRecipeRequest> createRepeated() => $pb.PbList<ListRecipeRequest>();
  @$core.pragma('dart2js:noInline')
  static ListRecipeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListRecipeRequest>(create);
  static ListRecipeRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);
}

class ListRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListRecipeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..pc<$3.Recipe>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recipes', $pb.PbFieldType.PM, subBuilder: $3.Recipe.create)
    ..hasRequiredFields = false
  ;

  ListRecipeResponse._() : super();
  factory ListRecipeResponse() => create();
  factory ListRecipeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListRecipeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListRecipeResponse clone() => ListRecipeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListRecipeResponse copyWith(void Function(ListRecipeResponse) updates) => super.copyWith((message) => updates(message as ListRecipeResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListRecipeResponse create() => ListRecipeResponse._();
  ListRecipeResponse createEmptyInstance() => create();
  static $pb.PbList<ListRecipeResponse> createRepeated() => $pb.PbList<ListRecipeResponse>();
  @$core.pragma('dart2js:noInline')
  static ListRecipeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListRecipeResponse>(create);
  static ListRecipeResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$3.Recipe> get recipes => $_getList(0);
}

class ListRecipeByCookbookRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListRecipeByCookbookRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookID', protoName: 'cookbookID')
    ..hasRequiredFields = false
  ;

  ListRecipeByCookbookRequest._() : super();
  factory ListRecipeByCookbookRequest() => create();
  factory ListRecipeByCookbookRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListRecipeByCookbookRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListRecipeByCookbookRequest clone() => ListRecipeByCookbookRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListRecipeByCookbookRequest copyWith(void Function(ListRecipeByCookbookRequest) updates) => super.copyWith((message) => updates(message as ListRecipeByCookbookRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListRecipeByCookbookRequest create() => ListRecipeByCookbookRequest._();
  ListRecipeByCookbookRequest createEmptyInstance() => create();
  static $pb.PbList<ListRecipeByCookbookRequest> createRepeated() => $pb.PbList<ListRecipeByCookbookRequest>();
  @$core.pragma('dart2js:noInline')
  static ListRecipeByCookbookRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListRecipeByCookbookRequest>(create);
  static ListRecipeByCookbookRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookID => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCookbookID() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookID() => clearField(1);
}

class ListRecipeByCookbookResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListRecipeByCookbookResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..pc<$3.Recipe>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recipes', $pb.PbFieldType.PM, subBuilder: $3.Recipe.create)
    ..hasRequiredFields = false
  ;

  ListRecipeByCookbookResponse._() : super();
  factory ListRecipeByCookbookResponse() => create();
  factory ListRecipeByCookbookResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListRecipeByCookbookResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListRecipeByCookbookResponse clone() => ListRecipeByCookbookResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListRecipeByCookbookResponse copyWith(void Function(ListRecipeByCookbookResponse) updates) => super.copyWith((message) => updates(message as ListRecipeByCookbookResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListRecipeByCookbookResponse create() => ListRecipeByCookbookResponse._();
  ListRecipeByCookbookResponse createEmptyInstance() => create();
  static $pb.PbList<ListRecipeByCookbookResponse> createRepeated() => $pb.PbList<ListRecipeByCookbookResponse>();
  @$core.pragma('dart2js:noInline')
  static ListRecipeByCookbookResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListRecipeByCookbookResponse>(create);
  static ListRecipeByCookbookResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$3.Recipe> get recipes => $_getList(0);
}

class ListShortenRecipeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListShortenRecipeRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..hasRequiredFields = false
  ;

  ListShortenRecipeRequest._() : super();
  factory ListShortenRecipeRequest() => create();
  factory ListShortenRecipeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListShortenRecipeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListShortenRecipeRequest clone() => ListShortenRecipeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListShortenRecipeRequest copyWith(void Function(ListShortenRecipeRequest) updates) => super.copyWith((message) => updates(message as ListShortenRecipeRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListShortenRecipeRequest create() => ListShortenRecipeRequest._();
  ListShortenRecipeRequest createEmptyInstance() => create();
  static $pb.PbList<ListShortenRecipeRequest> createRepeated() => $pb.PbList<ListShortenRecipeRequest>();
  @$core.pragma('dart2js:noInline')
  static ListShortenRecipeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListShortenRecipeRequest>(create);
  static ListShortenRecipeRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);
}

class ListShortenRecipeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListShortenRecipeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..pc<$3.ShortenRecipe>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recipes', $pb.PbFieldType.PM, subBuilder: $3.ShortenRecipe.create)
    ..hasRequiredFields = false
  ;

  ListShortenRecipeResponse._() : super();
  factory ListShortenRecipeResponse() => create();
  factory ListShortenRecipeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListShortenRecipeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListShortenRecipeResponse clone() => ListShortenRecipeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListShortenRecipeResponse copyWith(void Function(ListShortenRecipeResponse) updates) => super.copyWith((message) => updates(message as ListShortenRecipeResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListShortenRecipeResponse create() => ListShortenRecipeResponse._();
  ListShortenRecipeResponse createEmptyInstance() => create();
  static $pb.PbList<ListShortenRecipeResponse> createRepeated() => $pb.PbList<ListShortenRecipeResponse>();
  @$core.pragma('dart2js:noInline')
  static ListShortenRecipeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListShortenRecipeResponse>(create);
  static ListShortenRecipeResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$3.ShortenRecipe> get recipes => $_getList(0);
}

class ListShortenRecipeByCookbookRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListShortenRecipeByCookbookRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'cookbookID', protoName: 'cookbookID')
    ..hasRequiredFields = false
  ;

  ListShortenRecipeByCookbookRequest._() : super();
  factory ListShortenRecipeByCookbookRequest() => create();
  factory ListShortenRecipeByCookbookRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListShortenRecipeByCookbookRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListShortenRecipeByCookbookRequest clone() => ListShortenRecipeByCookbookRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListShortenRecipeByCookbookRequest copyWith(void Function(ListShortenRecipeByCookbookRequest) updates) => super.copyWith((message) => updates(message as ListShortenRecipeByCookbookRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListShortenRecipeByCookbookRequest create() => ListShortenRecipeByCookbookRequest._();
  ListShortenRecipeByCookbookRequest createEmptyInstance() => create();
  static $pb.PbList<ListShortenRecipeByCookbookRequest> createRepeated() => $pb.PbList<ListShortenRecipeByCookbookRequest>();
  @$core.pragma('dart2js:noInline')
  static ListShortenRecipeByCookbookRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListShortenRecipeByCookbookRequest>(create);
  static ListShortenRecipeByCookbookRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get cookbookID => $_getSZ(0);
  @$pb.TagNumber(1)
  set cookbookID($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasCookbookID() => $_has(0);
  @$pb.TagNumber(1)
  void clearCookbookID() => clearField(1);
}

class ListShortenRecipeByCookbookResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListShortenRecipeByCookbookResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..pc<$3.ShortenRecipe>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'recipes', $pb.PbFieldType.PM, subBuilder: $3.ShortenRecipe.create)
    ..hasRequiredFields = false
  ;

  ListShortenRecipeByCookbookResponse._() : super();
  factory ListShortenRecipeByCookbookResponse() => create();
  factory ListShortenRecipeByCookbookResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListShortenRecipeByCookbookResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListShortenRecipeByCookbookResponse clone() => ListShortenRecipeByCookbookResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListShortenRecipeByCookbookResponse copyWith(void Function(ListShortenRecipeByCookbookResponse) updates) => super.copyWith((message) => updates(message as ListShortenRecipeByCookbookResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListShortenRecipeByCookbookResponse create() => ListShortenRecipeByCookbookResponse._();
  ListShortenRecipeByCookbookResponse createEmptyInstance() => create();
  static $pb.PbList<ListShortenRecipeByCookbookResponse> createRepeated() => $pb.PbList<ListShortenRecipeByCookbookResponse>();
  @$core.pragma('dart2js:noInline')
  static ListShortenRecipeByCookbookResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListShortenRecipeByCookbookResponse>(create);
  static ListShortenRecipeByCookbookResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$3.ShortenRecipe> get recipes => $_getList(0);
}

class ListTradeRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListTradeRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..hasRequiredFields = false
  ;

  ListTradeRequest._() : super();
  factory ListTradeRequest() => create();
  factory ListTradeRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListTradeRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListTradeRequest clone() => ListTradeRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListTradeRequest copyWith(void Function(ListTradeRequest) updates) => super.copyWith((message) => updates(message as ListTradeRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListTradeRequest create() => ListTradeRequest._();
  ListTradeRequest createEmptyInstance() => create();
  static $pb.PbList<ListTradeRequest> createRepeated() => $pb.PbList<ListTradeRequest>();
  @$core.pragma('dart2js:noInline')
  static ListTradeRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListTradeRequest>(create);
  static ListTradeRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);
}

class ListTradeResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'ListTradeResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..pc<$3.Trade>(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'trades', $pb.PbFieldType.PM, subBuilder: $3.Trade.create)
    ..hasRequiredFields = false
  ;

  ListTradeResponse._() : super();
  factory ListTradeResponse() => create();
  factory ListTradeResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ListTradeResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ListTradeResponse clone() => ListTradeResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ListTradeResponse copyWith(void Function(ListTradeResponse) updates) => super.copyWith((message) => updates(message as ListTradeResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static ListTradeResponse create() => ListTradeResponse._();
  ListTradeResponse createEmptyInstance() => create();
  static $pb.PbList<ListTradeResponse> createRepeated() => $pb.PbList<ListTradeResponse>();
  @$core.pragma('dart2js:noInline')
  static ListTradeResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ListTradeResponse>(create);
  static ListTradeResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$3.Trade> get trades => $_getList(0);
}

class PylonsBalanceRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PylonsBalanceRequest', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aOS(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'address')
    ..hasRequiredFields = false
  ;

  PylonsBalanceRequest._() : super();
  factory PylonsBalanceRequest() => create();
  factory PylonsBalanceRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PylonsBalanceRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PylonsBalanceRequest clone() => PylonsBalanceRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PylonsBalanceRequest copyWith(void Function(PylonsBalanceRequest) updates) => super.copyWith((message) => updates(message as PylonsBalanceRequest)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PylonsBalanceRequest create() => PylonsBalanceRequest._();
  PylonsBalanceRequest createEmptyInstance() => create();
  static $pb.PbList<PylonsBalanceRequest> createRepeated() => $pb.PbList<PylonsBalanceRequest>();
  @$core.pragma('dart2js:noInline')
  static PylonsBalanceRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PylonsBalanceRequest>(create);
  static PylonsBalanceRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get address => $_getSZ(0);
  @$pb.TagNumber(1)
  set address($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasAddress() => $_has(0);
  @$pb.TagNumber(1)
  void clearAddress() => clearField(1);
}

class PylonsBalanceResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'PylonsBalanceResponse', package: const $pb.PackageName(const $core.bool.fromEnvironment('protobuf.omit_message_names') ? '' : 'pylons'), createEmptyInstance: create)
    ..aInt64(1, const $core.bool.fromEnvironment('protobuf.omit_field_names') ? '' : 'balance')
    ..hasRequiredFields = false
  ;

  PylonsBalanceResponse._() : super();
  factory PylonsBalanceResponse() => create();
  factory PylonsBalanceResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PylonsBalanceResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  PylonsBalanceResponse clone() => PylonsBalanceResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  PylonsBalanceResponse copyWith(void Function(PylonsBalanceResponse) updates) => super.copyWith((message) => updates(message as PylonsBalanceResponse)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PylonsBalanceResponse create() => PylonsBalanceResponse._();
  PylonsBalanceResponse createEmptyInstance() => create();
  static $pb.PbList<PylonsBalanceResponse> createRepeated() => $pb.PbList<PylonsBalanceResponse>();
  @$core.pragma('dart2js:noInline')
  static PylonsBalanceResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PylonsBalanceResponse>(create);
  static PylonsBalanceResponse _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get balance => $_getI64(0);
  @$pb.TagNumber(1)
  set balance($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasBalance() => $_has(0);
  @$pb.TagNumber(1)
  void clearBalance() => clearField(1);
}

